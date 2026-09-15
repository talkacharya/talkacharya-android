/// Holds a location that arrived (via deep link or notification tap) while the
/// user was unauthenticated. The router replays it once auth succeeds, then
/// clears it. Registered as a singleton.
class PendingDeepLink {
  String? _location;

  void set(String location) => _location = location;

  /// Returns the stashed location and clears it.
  String? take() {
    final loc = _location;
    _location = null;
    return loc;
  }

  bool get hasPending => _location != null;
}
