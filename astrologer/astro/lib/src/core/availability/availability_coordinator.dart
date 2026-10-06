import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../features/auth/presentation/bloc/auth/auth_bloc.dart';
import '../astro/onboarding_store.dart';
import '../constants/api_paths.dart';

/// Keeps the astrologer's presence heartbeat alive. The backend key has a 45 s
/// TTL, so we POST `/astro/availability/heartbeat` every 20 s while the app is
/// foregrounded, the astrologer is approved, and [enabled] is on. Toggling
/// [enabled] off calls `/astro/availability/offline`.
class AvailabilityCoordinator with ChangeNotifier {
  AvailabilityCoordinator({
    required Dio dio,
    required AuthBloc authBloc,
    required OnboardingStore onboarding,
    required FlutterSecureStorage storage,
  }) : _dio = dio,
       _authBloc = authBloc,
       _onboarding = onboarding,
       _storage = storage;

  final Dio _dio;
  final AuthBloc _authBloc;
  final OnboardingStore _onboarding;
  final FlutterSecureStorage _storage;

  static const _interval = Duration(seconds: 20);
  static const _key = 'ta_astro_online_enabled';

  StreamSubscription<AuthState>? _authSub;
  AppLifecycleListener? _lifecycle;
  Timer? _timer;
  bool _foreground = true;

  bool _enabled = false;
  bool get enabled => _enabled;

  /// Last presence the backend reported: online / away / busy / offline.
  String presence = 'offline';

  /// When the running break ends, while one is — the backend reads as offline
  /// for its length, and this is what tells a break from really being offline.
  DateTime? breakEndsAt;

  bool get onBreak =>
      _enabled && (breakEndsAt?.isAfter(DateTime.now()) ?? false);

  /// Re-reads presence now rather than at the next tick: a break just started
  /// or ended. Does nothing while offline — a beat would put them online.
  Future<void> refresh() async {
    if (_timer != null) await _beat();
  }

  Future<void> start() async {
    final cached = await _storage.read(key: _key);
    if (cached == 'true') {
      _enabled = true;
      notifyListeners();
    }

    _lifecycle = AppLifecycleListener(
      onResume: () {
        _foreground = true;
        _sync();
      },
      onHide: () => _foreground = false,
      onPause: () => _foreground = false,
    );
    _authSub = _authBloc.stream.listen((_) => _sync());
    _sync();
  }

  /// The Home toggle. `true` starts the heartbeat loop and beats once now;
  /// `false` tells the backend to go offline.
  Future<void> setEnabled(bool value) async {
    _enabled = value;
    await _storage.write(key: _key, value: value.toString());
    notifyListeners();
    if (value) {
      await _beat();
      _sync();
    } else {
      _timer?.cancel();
      try {
        final res = await _dio.post<Map<String, dynamic>>(
          ApiPaths.astroOffline,
        );
        presence = res.data?['presence_state'] as String? ?? 'offline';
      } catch (_) {}
      breakEndsAt = null;
      notifyListeners();
    }
  }

  void _sync() {
    final live =
        _authBloc.state.status == AuthStatus.authenticated &&
        _onboarding.stage == OnboardingStage.approved &&
        _foreground &&
        _enabled;
    if (live && _timer == null) {
      _timer = Timer.periodic(_interval, (_) => _beat());
      _beat();
    } else if (!live) {
      _timer?.cancel();
      _timer = null;
    }
  }

  Future<void> _beat() async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        ApiPaths.astroHeartbeat,
      );
      final next = res.data?['presence_state'] as String?;
      final until = DateTime.tryParse('${res.data?['break_ends_at']}');
      if ((next != null && next != presence) || until != breakEndsAt) {
        presence = next ?? presence;
        breakEndsAt = until;
        notifyListeners();
      }
    } catch (_) {}
  }

  @override
  Future<void> dispose() async {
    _timer?.cancel();
    await _authSub?.cancel();
    _lifecycle?.dispose();
    super.dispose();
  }
}
