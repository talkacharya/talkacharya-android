/// What the customer chose to share *before* a consultation exists.
///
/// Tapping "Consult an astrologer" on a birth profile or a match parks the
/// choice here; the booking sheet picks it up when the consultation is created
/// and clears it. Avoids threading ids through discovery → profile → sheet.
class PendingShare {
  String? _birthProfileId;
  String? _matchId;
  String _label = '';

  String? get birthProfileId => _birthProfileId;
  String? get matchId => _matchId;

  /// Display text for the booking sheet's "sharing …" hint.
  String get label => _label;

  bool get isEmpty => _birthProfileId == null && _matchId == null;

  void setProfile(String id, {String label = ''}) {
    _birthProfileId = id;
    _matchId = null;
    _label = label;
  }

  void setMatch(String id, {String label = ''}) {
    _matchId = id;
    _birthProfileId = null;
    _label = label;
  }

  void clear() {
    _birthProfileId = null;
    _matchId = null;
    _label = '';
  }
}
