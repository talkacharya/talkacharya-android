import 'package:flutter/foundation.dart';

/// Which consultation room is currently on screen.
///
/// Two things depend on it: the "live consultation · Return" banner hides
/// itself while you're already in the room, and deep links arriving during a
/// call are *pushed* on top instead of replacing the stack — replacing it would
/// dispose the call controller and drop the call.
class RoomPresence extends ChangeNotifier {
  String? _threadId;
  String? _consultationId;
  bool _isCall = false;

  /// The thread whose room is mounted, or null. Realtime frames and the chats
  /// list are keyed on this.
  String? get openId => _threadId;

  /// The paid session running inside that room, when there is one. The
  /// "live consultation" banner is about sessions, not threads, so it needs
  /// this one — a thread id would never match and the banner would sit there
  /// telling you to return to the room you are already in.
  String? get openConsultationId => _consultationId;

  /// True while the open room is a voice/video call.
  bool get callOnScreen => _threadId != null && _isCall;

  /// Whether [id] names the open room, by either id.
  bool isOpen(String? id) =>
      id != null && (id == _threadId || id == _consultationId);

  void opened(String threadId, {required bool isCall, String? consultationId}) {
    if (_threadId == threadId &&
        _isCall == isCall &&
        _consultationId == consultationId) {
      return;
    }
    _threadId = threadId;
    _consultationId = consultationId;
    _isCall = isCall;
    notifyListeners();
  }

  void closed(String threadId) {
    if (_threadId != threadId) return;
    _threadId = null;
    _consultationId = null;
    _isCall = false;
    notifyListeners();
  }
}
