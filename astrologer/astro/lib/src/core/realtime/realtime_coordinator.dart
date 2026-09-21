import 'dart:async';

import 'package:flutter/widgets.dart';

import '../../features/auth/presentation/bloc/auth/auth_bloc.dart';
import '../astro/onboarding_store.dart';
import 'realtime_client.dart';

/// Decides *when* the realtime socket should be up: connected while the user is
/// authenticated and the app is foregrounded; dropped on logout or after a grace
/// period in the background — but never while a consultation room or call is
/// open (the screen turns off during a call; the chat must keep flowing).
class RealtimeCoordinator {
  RealtimeCoordinator({
    required RealtimeClient client,
    required AuthBloc authBloc,
    required OnboardingStore onboarding,
  }) : _client = client,
       _authBloc = authBloc,
       _onboarding = onboarding;

  final RealtimeClient _client;
  final AuthBloc _authBloc;
  final OnboardingStore _onboarding;

  StreamSubscription<AuthState>? _authSub;
  AppLifecycleListener? _lifecycle;
  Timer? _graceTimer;
  bool _foreground = true;

  void start() {
    _lifecycle = AppLifecycleListener(
      onResume: () {
        _foreground = true;
        _graceTimer?.cancel();
        _sync();
      },
      onHide: _onBackground,
      onPause: _onBackground,
    );
    _authSub = _authBloc.stream.listen((_) => _sync());
    _onboarding.addListener(_sync);
    _sync();
  }

  void _onBackground() {
    _foreground = false;
    _graceTimer?.cancel();
    _graceTimer = Timer(const Duration(seconds: 30), () {
      if (_foreground) return;
      if (_client.hasLiveRoom) {
        _onBackground(); // check again once the room is closed
      } else {
        _client.disconnect();
      }
    });
  }

  void _sync() {
    final state = _authBloc.state;
    final user = state.user;
    if (state.status == AuthStatus.authenticated &&
        user != null &&
        _foreground) {
      _client.connect(userId: user.id, astroProfileId: _onboarding.profileId);
    } else if (state.status != AuthStatus.authenticated) {
      _client.disconnect();
    }
  }

  Future<void> dispose() async {
    _graceTimer?.cancel();
    await _authSub?.cancel();
    _onboarding.removeListener(_sync);
    _lifecycle?.dispose();
  }
}
