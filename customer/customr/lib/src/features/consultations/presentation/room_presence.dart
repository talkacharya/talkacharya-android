import 'package:flutter/foundation.dart';

/// Which consultation room is currently on screen.
///
/// Two things depend on it: the "live consultation · Return" banner hides
/// itself while you're already in the room, and deep links arriving during a
/// call are *pushed* on top instead of replacing the stack — replacing it would
/// dispose the call controller and drop the call.
class RoomPresence extends ChangeNotifier {
  String? _openId;
  bool _isCall = false;

  /// Consultation whose room is mounted, or null.
  String? get openId => _openId;

  /// True while the open room is a voice/video call.
  bool get callOnScreen => _openId != null && _isCall;

  void opened(String consultationId, {required bool isCall}) {
    if (_openId == consultationId && _isCall == isCall) return;
    _openId = consultationId;
    _isCall = isCall;
    notifyListeners();
  }

  void closed(String consultationId) {
    if (_openId != consultationId) return;
    _openId = null;
    _isCall = false;
    notifyListeners();
  }
}
