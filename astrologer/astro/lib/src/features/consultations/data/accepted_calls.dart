import 'models/consultation.dart';

/// What Accept answered with, kept for a few seconds for the room it opens.
///
/// The accept response carries the session, its thread and — for a call —
/// how to join it. Without this the room asked for each of those again, one
/// request after another, before the call could even start: seconds of the
/// customer hearing it ring after the astrologer had picked up.
class AcceptedCalls {
  AcceptedCalls._();

  /// Long enough to open the room; short enough that an old answer is never
  /// used for a call that has moved on.
  static const _fresh = Duration(seconds: 30);

  static final Map<String, _Accepted> _byId = {};

  static void put(
    Consultation consultation, {
    String? conversationId,
    Map<String, dynamic>? join,
  }) {
    _byId[consultation.id] = _Accepted(
      consultation: consultation,
      conversationId: (conversationId?.isEmpty ?? true) ? null : conversationId,
      join: join,
      at: DateTime.now(),
    );
  }

  static _Accepted? _get(String id) {
    final a = _byId[id];
    if (a == null) return null;
    if (DateTime.now().difference(a.at) > _fresh) {
      _byId.remove(id);
      return null;
    }
    return a;
  }

  /// The thread of a consultation accepted just now.
  static String? threadFor(String consultationId) =>
      _get(consultationId)?.conversationId;

  /// The consultation as accepted just now, by its id or its thread's.
  static Consultation? consultationFor(String id) {
    final direct = _get(id);
    if (direct != null) return direct.consultation;
    for (final key in _byId.keys.toList()) {
      final a = _get(key);
      if (a != null && a.conversationId == id) return a.consultation;
    }
    return null;
  }

  /// How to join the call, once: a second join (a retry, a rejoin) asks the
  /// server again.
  static Map<String, dynamic>? takeJoin(String consultationId) {
    final a = _get(consultationId);
    final join = a?.join;
    if (a != null) _byId[consultationId] = a.withoutJoin();
    return join;
  }
}

class _Accepted {
  const _Accepted({
    required this.consultation,
    required this.conversationId,
    required this.join,
    required this.at,
  });

  final Consultation consultation;
  final String? conversationId;
  final Map<String, dynamic>? join;
  final DateTime at;

  _Accepted withoutJoin() => _Accepted(
    consultation: consultation,
    conversationId: conversationId,
    join: null,
    at: at,
  );
}
