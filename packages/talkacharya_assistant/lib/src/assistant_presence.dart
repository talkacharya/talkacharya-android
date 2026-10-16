/// Which assistant room is on screen, so a push for it can be dropped — the
/// message is already in front of the user.
class AssistantPresence {
  AssistantPresence._();

  static String? _open;

  static bool isOpen(String? threadId) =>
      threadId != null && threadId.isNotEmpty && threadId == _open;

  static void opened(String threadId) => _open = threadId;

  static void closed(String threadId) {
    if (_open == threadId) _open = null;
  }
}
