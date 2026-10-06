import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../engine/call_controller.dart';
import '../engine/call_pip.dart';
import '../models/call_state.dart';
import 'call_screen.dart';
import 'call_overlay.dart';

/// What the minimized call UI needs to show and where tapping it goes.
class CallInfo {
  const CallInfo({
    required this.consultationId,
    required this.peerName,
    this.peerAvatarUrl,
    this.video = false,
  });

  final String consultationId;
  final String peerName;
  final String? peerAvatarUrl;
  final bool video;
}

/// App-wide owner of the one running call, so it outlives the room screen.
///
/// The room shows the full [CallScreen] while [expanded]; minimizing hands the
/// call to [CallOverlayHost] (a bar for voice, a floating window for video) and
/// the user can move around the app. Rooms report when they're open so a tap on
/// the minimized UI can go back to the existing screen instead of stacking a
/// second one.
class CallHub extends ChangeNotifier {
  CallController? _controller;
  CallInfo? _info;
  bool _expanded = true;
  final _openRooms = <String, int>{};

  CallController? get controller => _controller;
  CallInfo? get info => _info;
  bool get expanded => _expanded;
  bool get hasCall => _controller != null;

  bool isFor(String consultationId) =>
      _controller != null && _info?.consultationId == consultationId;

  StreamSubscription<CallState>? _watch;

  void _safeNotify() {
    final binding = WidgetsBinding.instance;
    if (binding.schedulerPhase != SchedulerPhase.idle) {
      binding.addPostFrameCallback((_) => notifyListeners());
    } else {
      notifyListeners();
    }
  }

  /// Take ownership of [controller]; any previous call is closed.
  void attach(CallController controller, CallInfo info) {
    final previous = _controller;
    _controller = controller;
    _info = info;
    _expanded = true;
    unawaited(_watch?.cancel());
    // A call that ends while minimized has no screen to clean it up: the bar
    // hides itself, and without this the hub would hold a finished call — and
    // go on claiming the consultation is "in progress" — until someone opened
    // the room again.
    _watch = controller.stream.listen((state) {
      // A live video call follows the user out of the app as a picture-in-picture
      // window; anything else (voice, or a call that is over) must not.
      unawaited(CallPip.setActive(active: info.video && state.phase.isLive));
      if (state.phase == CallPhase.ended) unawaited(release());
    });
    _safeNotify();
    if (previous != null && !identical(previous, controller)) {
      unawaited(previous.close());
    }
  }

  Future<void> minimize() async {
    if (_controller == null || !_expanded) return;
    _expanded = false;
    _safeNotify();
  }

  void expand() {
    if (_controller == null || _expanded) return;
    _expanded = true;
    _safeNotify();
  }

  /// Close and forget the call.
  Future<void> release() async {
    final c = _controller;
    if (c == null) return;
    unawaited(CallPip.setActive(active: false));
    unawaited(_watch?.cancel());
    _watch = null;
    _controller = null;
    _info = null;
    _expanded = true;
    _safeNotify();
    await c.close();
  }

  void roomOpened(String consultationId) =>
      _openRooms.update(consultationId, (n) => n + 1, ifAbsent: () => 1);

  void roomClosed(String consultationId) {
    final n = (_openRooms[consultationId] ?? 1) - 1;
    n <= 0 ? _openRooms.remove(consultationId) : _openRooms[consultationId] = n;
  }

  /// A room screen for [consultationId] is somewhere in the navigation stack.
  bool isRoomOpen(String consultationId) =>
      _openRooms.containsKey(consultationId);
}
