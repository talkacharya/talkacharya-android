import 'package:flutter/foundation.dart';

/// Which consultation room is currently on screen.
///
/// The app-wide "live session · Return" banner hides while the room is open,
/// and deep links arriving during a call are pushed on top instead of
/// replacing the stack (replacing it would dispose the call and hang up).
class RoomPresence extends ChangeNotifier {
  String? _openId;
  bool _isCall = false;

  String? get openId => _openId;
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
