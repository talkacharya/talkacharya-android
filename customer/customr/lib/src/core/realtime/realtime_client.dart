import 'dart:async';
import 'dart:convert';

import 'package:centrifuge/centrifuge.dart' as centrifuge;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../constants/api_paths.dart';
import 'realtime_event.dart';

/// Wraps the Centrifugo Dart client for the personal `user:{id}` channel.
///
/// The connection JWT + ws url come from `POST /api/v1/realtime/token`; the
/// client refreshes the token itself via the [centrifuge.ClientConfig.getToken]
/// callback. Parsed frames land on [events]. Safe to call [connect] when the ws
/// url is unset — it just no-ops.
class RealtimeClient {
  RealtimeClient(this._dio);

  final Dio _dio;

  centrifuge.Client? _client;
  centrifuge.Subscription? _sub;
  String? _userId;

  final _events = StreamController<RealtimeEvent>.broadcast();
  Stream<RealtimeEvent> get events => _events.stream;

  final _connected = ValueNotifier<bool>(false);
  ValueListenable<bool> get connected => _connected;

  bool get isConnected => _connected.value;

  final _extra = <String, _ChannelSub>{};

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

  _ChannelSub _channel(String name) {
    final existing = _extra[name];
    if (existing != null) return existing;

    final sub = _ChannelSub(
      StreamController<Map<String, dynamic>>.broadcast(),
      StreamController<({String userId, bool joined})>.broadcast(),
    );
    _extra[name] = sub;
    sub.controller.onCancel = () {
      if (!sub.controller.hasListener && !sub.presence.hasListener) {
        sub.subscription?.unsubscribe();
        sub.controller.close();
        sub.presence.close();
        _extra.remove(name);
      }
    };

    final client = _client;
    if (client != null) _attachChannel(client, name, sub);
    return sub;
  }

  void _attachChannel(centrifuge.Client client, String name, _ChannelSub sub) {
    final s = client.newSubscription(
      name,
      centrifuge.SubscriptionConfig(joinLeave: true),
    );
    sub.subscription = s;
    s.publication.listen((event) {
      try {
        sub.controller.add(
          jsonDecode(utf8.decode(event.data)) as Map<String, dynamic>,
        );
      } catch (_) {}
    });
    s.join.listen(
      (e) => sub.presence.add((userId: e.user, joined: true)),
      onError: (_) {},
    );
    s.leave.listen(
      (e) => sub.presence.add((userId: e.user, joined: false)),
      onError: (_) {},
    );
    s.subscribe().ignore();
  }

  Future<_TokenGrant?> _fetchToken() async {
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

  Future<void> connect({required String userId}) async {
    if (_client != null && _userId == userId) return;
    await disconnect();
    _userId = userId;

    final grant = await _fetchToken();
    if (grant == null || grant.wsUrl.isEmpty) {
      debugPrint('RealtimeClient: no ws url — realtime disabled');
      return;
    }

    final client = centrifuge.createClient(
      grant.wsUrl,
      centrifuge.ClientConfig(
        token: grant.token,
        getToken: (_) async => (await _fetchToken())?.token ?? '',
      ),
    );
    _client = client;

    client.connected.listen((_) => _connected.value = true);
    client.disconnected.listen((_) => _connected.value = false);
    client.error.listen((e) => debugPrint('RealtimeClient: $e'));

    final sub = client.newSubscription('user:$userId');
    _sub = sub;
    sub.publication.listen((event) => _onData(event.data));

    // Re-attach any channel subscriptions that outlived the previous connection.
    for (final entry in _extra.entries) {
      _attachChannel(client, entry.key, entry.value);
    }

    try {
      await client.connect();
      await sub.subscribe();
    } catch (e) {
      debugPrint('RealtimeClient: connect failed ($e)');
    }
  }

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
    _userId = null;
    _connected.value = false;
    try {
      for (final s in _extra.values) {
        await s.subscription?.unsubscribe();
      }
      await _sub?.unsubscribe();
      await _client?.disconnect();
    } catch (_) {}
    _sub = null;
    _client = null;
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
}
