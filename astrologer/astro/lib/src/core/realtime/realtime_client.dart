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
  centrifuge.Subscription? _astroSub;
  String? _userId;
  String? _astroProfileId;

  final _events = StreamController<RealtimeEvent>.broadcast();
  Stream<RealtimeEvent> get events => _events.stream;

  final _connected = ValueNotifier<bool>(false);
  ValueListenable<bool> get connected => _connected;

  bool get isConnected => _connected.value;

  final _extra = <String, _ChannelSub>{};

  /// Subscribe to an additional private channel (e.g. `conv:{id}`) for as long
  /// as the returned stream has a listener. Frames are the raw decoded JSON
  /// (`{v, type, ts, data}`). No-ops (empty stream) when realtime is unavailable.
  Stream<Map<String, dynamic>> channelFrames(String name) {
    final existing = _extra[name];
    if (existing != null) return existing.controller.stream;

    final sub = _ChannelSub(StreamController<Map<String, dynamic>>.broadcast());
    _extra[name] = sub;
    sub.controller.onCancel = () {
      if (!sub.controller.hasListener) {
        sub.subscription?.unsubscribe();
        sub.controller.close();
        _extra.remove(name);
      }
    };

    final client = _client;
    if (client != null) {
      final s = client.newSubscription(name);
      sub.subscription = s;
      s.publication.listen((event) {
        try {
          sub.controller.add(
            jsonDecode(utf8.decode(event.data)) as Map<String, dynamic>,
          );
        } catch (_) {}
      });
      s.subscribe().ignore();
    }
    return sub.controller.stream;
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

  /// [astroProfileId] is the `AstrologerProfile.public_id` (from `/astro/onboarding`),
  /// used for the `astro:{id}` channel that carries incoming requests.
  Future<void> connect({required String userId, String? astroProfileId}) async {
    if (_client != null && _userId == userId && _astroProfileId == astroProfileId) {
      return;
    }
    await disconnect();
    _userId = userId;
    _astroProfileId = astroProfileId;

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

    if (_astroProfileId != null && _astroProfileId!.isNotEmpty) {
      final asub = client.newSubscription('astro:${_astroProfileId!}');
      _astroSub = asub;
      asub.publication.listen((event) => _onData(event.data));
      asub.subscribe().ignore();
    }

    // Re-attach any channel subscriptions that outlived the previous connection.
    for (final entry in _extra.entries) {
      final s = client.newSubscription(entry.key);
      entry.value.subscription = s;
      s.publication.listen((event) {
        try {
          entry.value.controller.add(
            jsonDecode(utf8.decode(event.data)) as Map<String, dynamic>,
          );
        } catch (_) {}
      });
      s.subscribe().ignore();
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
    _astroProfileId = null;
    _connected.value = false;
    try {
      for (final s in _extra.values) {
        await s.subscription?.unsubscribe();
      }
      await _astroSub?.unsubscribe();
      await _sub?.unsubscribe();
      await _client?.disconnect();
    } catch (_) {}
    _astroSub = null;
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
  _ChannelSub(this.controller);
  final StreamController<Map<String, dynamic>> controller;
  centrifuge.Subscription? subscription;
}
