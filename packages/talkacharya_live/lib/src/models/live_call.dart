import 'package:equatable/equatable.dart';

/// Voice calls during a live stream (backend `apps/livestream/calls.py`).
///
/// A viewer asks for a **public** call (everyone watching hears both of them) or a
/// **private** one (only the two of them; the stream goes on showing the host).
/// One call at a time — the rest wait in the stream's line, and the next comes on
/// air by itself when a call ends. The host stays live throughout.
enum LiveCallMode {
  public,
  private;

  static LiveCallMode parse(Object? v) =>
      '$v' == 'private' ? LiveCallMode.private : LiveCallMode.public;
}

/// Where one request stands.
enum LiveCallStatus {
  waiting,
  connecting,
  active,
  ended,
  cancelled,
  missed;

  static LiveCallStatus parse(Object? v) => LiveCallStatus.values.firstWhere(
    (s) => s.name == '$v',
    orElse: () => LiveCallStatus.ended,
  );

  /// Still holding a place: waiting, coming on, or on air.
  bool get isOpen => this == waiting || this == connecting || this == active;
}

/// What a call costs a minute, per mode; null when the mode is not on offer here
/// (no private rate set for this astrologer).
class LiveCallQuote extends Equatable {
  const LiveCallQuote({this.public, this.private, this.currency = 'INR'});

  final String? public;
  final String? private;
  final String currency;

  String? rateFor(LiveCallMode mode) =>
      mode == LiveCallMode.private ? private : public;

  factory LiveCallQuote.fromJson(Map<String, dynamic>? j) => LiveCallQuote(
    public: j?['public'] as String?,
    private: j?['private'] as String?,
    currency: '${j?['currency'] ?? 'INR'}',
  );

  @override
  List<Object?> get props => [public, private, currency];
}

/// The call on air, as every viewer sees it. A private caller is not named.
class LiveOnAir extends Equatable {
  const LiveOnAir({
    required this.id,
    required this.mode,
    this.muted = false,
    this.callerId,
    this.callerName,
    this.startedAt,
  });

  final String id;
  final LiveCallMode mode;
  final bool muted;
  final String? callerId;
  final String? callerName;
  final DateTime? startedAt;

  static LiveOnAir? fromJson(Object? raw) {
    if (raw is! Map) return null;
    final j = raw.cast<String, dynamic>();
    final caller = (j['caller'] as Map?)?.cast<String, dynamic>();
    return LiveOnAir(
      id: '${j['id'] ?? ''}',
      mode: LiveCallMode.parse(j['mode']),
      muted: j['muted'] == true,
      callerId: caller?['id'] as String?,
      callerName: caller?['name'] as String?,
      startedAt: DateTime.tryParse('${j['started_at'] ?? ''}'),
    );
  }

  @override
  List<Object?> get props => [id, mode, muted, callerId, callerName, startedAt];
}

/// One place in the stream's line — the caller's own, or a row of the host's list.
class LiveCallRequest extends Equatable {
  const LiveCallRequest({
    required this.id,
    required this.mode,
    required this.status,
    this.muted = false,
    this.customerId = '',
    this.customerName = '',
    this.consultationId,
    this.startedAt,
    this.ratePerMinute,
    this.connectBy,
  });

  final String id;
  final LiveCallMode mode;
  final LiveCallStatus status;
  final bool muted;
  final String customerId;
  final String customerName;

  /// The consultation behind the call, once their turn came (for the rating).
  final String? consultationId;
  final DateTime? startedAt;
  final String? ratePerMinute;
  final DateTime? connectBy;

  static LiveCallRequest? fromJson(Object? raw) {
    if (raw is! Map) return null;
    final j = raw.cast<String, dynamic>();
    final customer = (j['customer'] as Map?)?.cast<String, dynamic>();
    return LiveCallRequest(
      id: '${j['id'] ?? ''}',
      mode: LiveCallMode.parse(j['mode']),
      status: LiveCallStatus.parse(j['status']),
      muted: j['muted'] == true,
      customerId: '${customer?['id'] ?? ''}',
      customerName: '${customer?['name'] ?? ''}',
      consultationId: j['consultation'] as String?,
      startedAt: DateTime.tryParse('${j['started_at'] ?? ''}'),
      ratePerMinute: j['rate_per_minute'] as String?,
      connectBy: DateTime.tryParse('${j['connect_by'] ?? ''}'),
    );
  }

  @override
  List<Object?> get props => [
    id,
    mode,
    status,
    muted,
    customerId,
    customerName,
    consultationId,
    startedAt,
    ratePerMinute,
    connectBy,
  ];
}

/// How to come on air. Public: speak in the stream's own room (the server has
/// allowed this viewer's microphone there). Private: a two-person room of its own,
/// and the token for it — only ever in the caller's (or host's) own response.
class LiveCallMedia extends Equatable {
  const LiveCallMedia({
    required this.mode,
    required this.url,
    required this.room,
    this.token,
  });

  final LiveCallMode mode;
  final String url;
  final String room;
  final String? token;

  static LiveCallMedia? fromJson(Object? raw) {
    if (raw is! Map) return null;
    final j = raw.cast<String, dynamic>();
    return LiveCallMedia(
      mode: LiveCallMode.parse(j['mode']),
      url: '${j['url'] ?? ''}',
      room: '${j['room'] ?? ''}',
      token: j['token'] as String?,
    );
  }

  @override
  List<Object?> get props => [mode, url, room, token];
}

/// `GET /app/livestreams/{id}/calls` — everything a viewer's screen needs.
class LiveViewerCalls extends Equatable {
  const LiveViewerCalls({
    this.quote = const LiveCallQuote(),
    this.onAir,
    this.waiting = 0,
    this.mine,
    this.ahead = 0,
    this.media,
  });

  final LiveCallQuote quote;
  final LiveOnAir? onAir;
  final int waiting;
  final LiveCallRequest? mine;

  /// How many wait ahead of this viewer (the call on air not counted).
  final int ahead;
  final LiveCallMedia? media;

  factory LiveViewerCalls.fromJson(Map<String, dynamic>? j) => LiveViewerCalls(
    quote: LiveCallQuote.fromJson((j?['quote'] as Map?)?.cast()),
    onAir: LiveOnAir.fromJson(j?['on_air']),
    waiting: (j?['waiting'] as num?)?.toInt() ?? 0,
    mine: LiveCallRequest.fromJson(j?['mine']),
    ahead: (j?['ahead'] as num?)?.toInt() ?? 0,
    media: LiveCallMedia.fromJson(j?['media']),
  );

  @override
  List<Object?> get props => [quote, onAir, waiting, mine, ahead, media];
}

/// `GET /astro/livestreams/{id}/calls` — the host's line, and the way into a
/// private call on air.
class LiveHostCalls extends Equatable {
  const LiveHostCalls({this.line = const [], this.media});

  final List<LiveCallRequest> line;
  final LiveCallMedia? media;

  /// The call coming on or on air, if any.
  LiveCallRequest? get current {
    for (final r in line) {
      if (r.status == LiveCallStatus.connecting ||
          r.status == LiveCallStatus.active) {
        return r;
      }
    }
    return null;
  }

  int get waiting =>
      line.where((r) => r.status == LiveCallStatus.waiting).length;

  factory LiveHostCalls.fromJson(Map<String, dynamic>? j) => LiveHostCalls(
    line: [
      for (final r in (j?['line'] as List?) ?? const [])
        ?LiveCallRequest.fromJson(r),
    ],
    media: LiveCallMedia.fromJson(j?['media']),
  );

  @override
  List<Object?> get props => [line, media];
}
