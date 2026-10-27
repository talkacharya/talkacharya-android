import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../features/auth/presentation/bloc/auth/auth_bloc.dart';
import '../astro/onboarding_store.dart';
import '../constants/api_paths.dart';
import '../network/api_exception.dart';
import '../network/friendly_error.dart';

/// The astrologer's Online switch, and the heartbeat while the app is open.
///
/// Online is a switch kept on the **server** (`/astro/availability/online` and
/// `/offline`): it stays on with the app closed, in the background or with the
/// phone locked, and a request reaches the phone by push. The server turns it
/// off by itself only when nobody could reach them — no contact from the app for
/// hours, no phone left to ring, too many missed requests — so the app reads the
/// switch back whenever it opens rather than trusting what it last set.
///
/// While the app is in front and the switch is on, a heartbeat every 20 s says
/// "the app is open" and keeps the contact time fresh. It is no longer what
/// keeps the astrologer online.
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

  /// The Online switch as the server has it (shown by the Home toggle).
  bool get enabled => _enabled;

  /// Last presence the backend reported: online / away / busy / offline.
  String presence = 'offline';

  /// When the running break ends, while one is — the backend reads as offline
  /// for its length, and this is what tells a break from really being offline.
  DateTime? breakEndsAt;

  bool get onBreak =>
      _enabled && (breakEndsAt?.isAfter(DateTime.now()) ?? false);

  bool get _approved =>
      _authBloc.state.status == AuthStatus.authenticated &&
      _onboarding.stage == OnboardingStage.approved;

  /// Re-reads presence now rather than at the next tick: a break just started
  /// or ended. Only while the switch is on — a beat would otherwise put an
  /// astrologer online who had switched off.
  Future<void> refresh() async {
    if (_enabled) await _beat();
  }

  Future<void> start() async {
    // What it was last time, shown at once; the server's answer follows.
    final cached = await _storage.read(key: _key);
    if (cached == 'true') {
      _enabled = true;
      notifyListeners();
    }

    _lifecycle = AppLifecycleListener(
      onResume: () {
        _foreground = true;
        // The switch may have been turned off for them while the app was away.
        unawaited(_readSwitch());
        _sync();
      },
      onHide: () => _foreground = false,
      onPause: () => _foreground = false,
    );
    _authSub = _authBloc.stream.listen((_) {
      unawaited(_readSwitch());
      _sync();
    });
    unawaited(_readSwitch());
    _sync();
  }

  /// The Home toggle. Says so to the server — the switch lives there — and
  /// returns why it could not be done, or null.
  Future<String?> setEnabled(bool value) async {
    final before = _enabled;
    _set(value);
    try {
      final res = (await _dio.post<Map<String, dynamic>>(
        value ? ApiPaths.astroOnline : ApiPaths.astroOffline,
      )).ensureOk();
      presence = res.data?['presence_state'] as String? ?? presence;
      if (!value) breakEndsAt = null;
      notifyListeners();
      _sync();
      return null;
    } catch (e) {
      // Not taken (training unfinished, no connection): the toggle goes back.
      _set(before);
      _sync();
      return friendlyError(e);
    }
  }

  void _set(bool value) {
    if (_enabled == value) return;
    _enabled = value;
    unawaited(_storage.write(key: _key, value: value.toString()));
    notifyListeners();
  }

  /// The switch and presence as the server has them now.
  Future<void> _readSwitch() async {
    if (!_approved) return;
    try {
      final res = (await _dio.get<Map<String, dynamic>>(
        ApiPaths.astroAvailability,
      )).ensureOk();
      final online = res.data?['online'];
      final state = res.data?['presence_state'] as String?;
      if (state != null) presence = state;
      if (online is bool) {
        _set(online);
        _sync();
      }
      notifyListeners();
    } catch (_) {
      // Offline or the server is old: keep what is shown.
    }
  }

  void _sync() {
    final live = _approved && _foreground && _enabled;
    if (live && _timer == null) {
      _timer = Timer.periodic(_interval, (_) => _beat());
      unawaited(_beat());
    } else if (!live) {
      _timer?.cancel();
      // Null as well as cancelled: a cancelled timer left here read as one
      // still running, so switching back on never started the beats again.
      _timer = null;
    }
  }

  Future<void> _beat() async {
    if (!_enabled) return;
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        ApiPaths.astroHeartbeat,
      );
      final next = res.data?['presence_state'] as String?;
      final until = DateTime.tryParse('${res.data?['break_ends_at']}');
      // A safety rule (missed requests, ops) may have switched them off while
      // the app was open: the toggle follows the server, and the beats stop.
      if (res.data?['online'] == false) {
        presence = next ?? 'offline';
        breakEndsAt = null;
        _set(false);
        _sync();
        notifyListeners();
        return;
      }
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
    _timer = null;
    await _authSub?.cancel();
    _lifecycle?.dispose();
    super.dispose();
  }
}
