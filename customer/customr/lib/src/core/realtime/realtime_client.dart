import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:centrifuge/centrifuge.dart' as centrifuge;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../constants/api_paths.dart';
import 'realtime_event.dart';

/// Builds the underlying Centrifugo client (overridable in tests).
typedef CentrifugoClientFactory =
    centrifuge.Client Function(String url, centrifuge.ClientConfig config);

/// Wraps the Centrifugo Dart client for the personal `user:{id}` channel plus any
/// room channels (`conv:` / `call:` / `chattyping:`) a screen asks for.
///
/// The connection JWT + ws url come from `POST /api/v1/realtime/token`; the
/// client refreshes the token itself via [centrifuge.ClientConfig.getToken].
/// Parsed personal frames land on [events].
///
/// Self-healing: the Centrifugo client gives up for good on some errors (a failed
/// token refresh, an auth rejection). While realtime is wanted — between
/// [connect] and [disconnect] — a dead client is rebuilt with a fresh token
/// (backoff up to 30 s), [ensureConnected] revives it at once (app resume), and a
/// room channel the server dropped is re-subscribed while a screen still listens.
class RealtimeClient {
  RealtimeClient(this._dio, {CentrifugoClientFactory? clientFactory})
    : _newClient = clientFactory ?? centrifuge.createClient;

  final Dio _dio;
  final CentrifugoClientFactory _newClient;

  centrifuge.Client? _client;
  final _personal = <centrifuge.Subscription>[];
  final _personalListeners = <StreamSubscription<Object?>>[];
  String? _userId;

  /// [connect] was called and [disconnect] wasn't — keep the socket alive.
  bool _wanted = false;
  Timer? _reviveTimer;
  int _reviveAttempt = 0;
  bool _building = false;

  final _events = StreamController<RealtimeEvent>.broadcast();
  Stream<RealtimeEvent> get events => _events.stream;

  final _connected = ValueNotifier<bool>(false);
  ValueListenable<bool> get connected => _connected;

  bool get isConnected => _connected.value;

  final _extra = <String, _ChannelSub>{};

  /// A consultation room or call is open — the socket must survive the app
  /// being backgrounded (screen off during a call, switching apps mid-chat).
  bool get hasLiveRoom =>
      _extra.keys.any((k) => k.startsWith('conv:') || k.startsWith('call:'));

  /// Subscribe to an additional private channel (e.g. `conv:{id}`) for as long
  /// as the returned stream has a listener. Frames are the raw decoded JSON
  /// (`{v, type, ts, data}`). No-ops (empty stream) when realtime is unavailable.
  Stream<Map<String, dynamic>> channelFrames(String name) =>
      _channel(name).controller.stream;

  /// Centrifugo join/leave on [name] — `(userId, joined)` per event. Empty when
  /// realtime is unavailable. Keeps the channel subscribed while it has a listener.
  Stream<({String userId, bool joined})> channelPresence(String name) =>
      _channel(name).presence.stream;

  /// Publish [data] straight to [name] (used for the ephemeral typing channel,
  /// where the namespace grants `allow_publish_for_subscriber`). Best-effort.
  Future<void> publishToChannel(String name, Map<String, dynamic> data) async {
    final s = _channel(name).subscription;
    if (s == null) return;
    try {
      // a just-created subscription is still subscribing — wait briefly so the
      // first call-signaling frames (hello / offer) aren't dropped
      await s.ready().timeout(const Duration(seconds: 3));
    } catch (_) {}
    try {
      await s.publish(utf8.encode(jsonEncode(data)));
    } catch (_) {}
  }

  // --- room channels ------------------------------------------------------

  _ChannelSub _channel(String name) {
    final existing = _extra[name];
    if (existing != null) return existing;

    final sub = _ChannelSub(
      StreamController<Map<String, dynamic>>.broadcast(),
      StreamController<({String userId, bool joined})>.broadcast(),
    );
    _extra[name] = sub;
    // Either stream may be the last one cancelled.
    sub.controller.onCancel = () => _maybeRelease(name, sub);
    sub.presence.onCancel = () => _maybeRelease(name, sub);

    final client = _client;
    if (client != null) _attachChannel(client, name, sub);
    return sub;
  }

  void _maybeRelease(String name, _ChannelSub sub) {
    if (!sub.idle || _extra[name] != sub) return;
    _extra.remove(name);
    _detachChannel(sub, unsubscribe: true);
    sub.controller.close();
    sub.presence.close();
  }

  void _attachChannel(centrifuge.Client client, String name, _ChannelSub sub) {
    // Leaving a room only unsubscribes; the client keeps the Subscription in its
    // registry, and `newSubscription` throws for a channel it already knows.
    final s =
        client.getSubscription(name) ??
        client.newSubscription(
          name,
          centrifuge.SubscriptionConfig(joinLeave: true),
        );
    sub.subscription = s;
    sub.listeners
      ..add(
        s.publication.listen((event) {
          try {
            sub.controller.add(
              jsonDecode(utf8.decode(event.data)) as Map<String, dynamic>,
            );
          } catch (_) {}
        }),
      )
      ..add(
        s.join.listen(
          (e) => sub.presence.add((userId: e.user, joined: true)),
          onError: (_) {},
        ),
      )
      ..add(
        s.leave.listen(
          (e) => sub.presence.add((userId: e.user, joined: false)),
          onError: (_) {},
        ),
      )
      ..add(s.subscribed.listen((_) => sub.retryAttempt = 0))
      ..add(
        s.unsubscribed.listen((e) {
          // The server dropped us (permission refused, transient proxy error,
          // unsubscribe). Retry while a screen still listens.
          if (sub.subscription != s || sub.idle) return;
          debugPrint('RealtimeClient: $name unsubscribed ($e) — retrying');
          sub.retry?.cancel();
          sub.retry = Timer(_backoff(sub.retryAttempt++), () {
            if (sub.subscription == s && !sub.idle) s.subscribe().ignore();
          });
        }),
      );
    s.subscribe().ignore();
  }

  void _detachChannel(_ChannelSub sub, {required bool unsubscribe}) {
    sub.retry?.cancel();
    sub.retry = null;
    for (final l in sub.listeners) {
      l.cancel();
    }
    sub.listeners.clear();
    final s = sub.subscription;
    sub.subscription = null;
    if (unsubscribe && s != null) s.unsubscribe().ignore();
  }

  // --- connection -----------------------------------------------------------

  /// The initial grant; `null` when the API can't be reached right now.
  Future<_TokenGrant?> _fetchGrant() async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(ApiPaths.realtimeToken);
      final data = res.data;
      if (res.statusCode == 200 && data != null && data['token'] != null) {
        return _TokenGrant(
          token: data['token'] as String,
          wsUrl: (data['ws_url'] as String?) ?? '',
        );
      }
    } catch (e) {
      debugPrint('RealtimeClient: token fetch failed ($e)');
    }
    return null;
  }

  /// Token for the client's refresh/reconnect. Must throw on failure: an empty
  /// token makes the server reject the refresh and the client stop for good.
  Future<String> _refreshToken() async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(ApiPaths.realtimeToken);
      final token = res.data?['token'];
      if (res.statusCode == 200 && token is String && token.isNotEmpty) {
        return token;
      }
      if (res.statusCode == 401 || res.statusCode == 403) {
        throw centrifuge.UnauthorizedException();
      }
      throw Exception('realtime token: HTTP ${res.statusCode}');
    } on DioException catch (e) {
      final code = e.response?.statusCode;
      if (code == 401 || code == 403) throw centrifuge.UnauthorizedException();
      rethrow;
    }
  }

  Future<void> connect({required String userId}) async {
    _wanted = true;
    if (_userId == userId && (_client != null || _building)) {
      ensureConnected();
      return;
    }
    await _rebuild(userId);
  }

  /// Revive a socket that gave up (call on app resume). No-op while healthy.
  void ensureConnected() {
    final userId = _userId;
    if (!_wanted || userId == null || _building) return;
    final client = _client;
    if (client == null || client.state == centrifuge.State.disconnected) {
      _reviveTimer?.cancel();
      _rebuild(userId);
    }
  }

  void _scheduleRevive() {
    if (!_wanted) return;
    _reviveTimer?.cancel();
    _reviveTimer = Timer(_backoff(_reviveAttempt++), ensureConnected);
  }

  Future<void> _rebuild(String userId) async {
    _building = true;
    try {
      await _teardownClient();
      _userId = userId;

      final grant = await _fetchGrant();
      if (!_wanted || _userId != userId) return; // disconnected meanwhile
      if (grant == null) {
        _scheduleRevive();
        return;
      }
      if (grant.wsUrl.isEmpty) {
        debugPrint('RealtimeClient: no ws url — realtime disabled');
        return;
      }

      final client = _newClient(
        grant.wsUrl,
        centrifuge.ClientConfig(
          token: grant.token,
          getToken: (_) => _refreshToken(),
        ),
      );
      _client = client;

      client.connected.listen((_) {
        _reviveAttempt = 0;
        _connected.value = true;
      });
      client.connecting.listen((_) => _connected.value = false);
      client.disconnected.listen((e) {
        _connected.value = false;
        // Terminal for this client. Unless we asked for it, build a new one.
        if (identical(_client, client) && _wanted) {
          debugPrint('RealtimeClient: gave up ($e) — rebuilding');
          _scheduleRevive();
        }
      });
      client.error.listen((e) => debugPrint('RealtimeClient: $e'));

      _subscribePersonal(client, 'user:$userId');
      // Re-attach room channels that outlived the previous connection.
      for (final entry in _extra.entries) {
        _attachChannel(client, entry.key, entry.value);
      }

      try {
        await client.connect();
      } catch (e) {
        debugPrint('RealtimeClient: connect failed ($e)');
        _scheduleRevive();
      }
    } finally {
      _building = false;
    }
  }

  void _subscribePersonal(centrifuge.Client client, String channel) {
    final s = client.newSubscription(channel);
    _personal.add(s);
    _personalListeners.add(s.publication.listen((e) => _onData(e.data)));
    s.subscribe().ignore();
  }

  /// Drop the current client but keep the room channels' streams, so screens
  /// stay attached and get frames again once a new client connects.
  Future<void> _teardownClient() async {
    final client = _client;
    _client = null; // before disconnect(): its `disconnected` must not revive
    _connected.value = false;
    for (final sub in _extra.values) {
      _detachChannel(sub, unsubscribe: false);
    }
    for (final l in _personalListeners) {
      // not awaited: a cancelled broadcast listener's future can complete late
      unawaited(l.cancel());
    }
    _personalListeners.clear();
    _personal.clear();
    try {
      await client?.disconnect();
    } catch (_) {}
  }

  static Duration _backoff(int attempt) =>
      Duration(seconds: min(30, 1 << min(attempt, 5)));

  void _onData(List<int> bytes) {
    try {
      final frame = jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>;
      final event = RealtimeEvent.fromFrame(frame);
      if (event != null) _events.add(event);
    } catch (e) {
      debugPrint('RealtimeClient: bad frame ($e)');
    }
  }

  Future<void> disconnect() async {
    _wanted = false;
    _userId = null;
    _reviveTimer?.cancel();
    _reviveAttempt = 0;
    await _teardownClient();
  }

  Future<void> dispose() async {
    await disconnect();
    await _events.close();
    _connected.dispose();
  }
}

class _TokenGrant {
  const _TokenGrant({required this.token, required this.wsUrl});
  final String token;
  final String wsUrl;
}

class _ChannelSub {
  _ChannelSub(this.controller, this.presence);
  final StreamController<Map<String, dynamic>> controller;
  final StreamController<({String userId, bool joined})> presence;
  centrifuge.Subscription? subscription;
  final listeners = <StreamSubscription<Object?>>[];
  Timer? retry;
  int retryAttempt = 0;

  bool get idle => !controller.hasListener && !presence.hasListener;
}
