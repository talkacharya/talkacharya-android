/// One rung of the Vimshottari tree, fetched a level at a time.
///
/// The whole tree is 9^4 periods — shipping it would be megabytes for the sake
/// of the handful of rows anyone actually opens. The server hands back the
/// children of one node, with exact timestamps: a pratyantar runs for days and
/// a sookshma for hours, so the whole-day rounding in the chart payload is too
/// coarse to divide any further on the client.
class DashaLevel {
  const DashaLevel({
    required this.level,
    this.path = const [],
    this.parent,
    this.periods = const [],
    this.expandable = false,
  });

  /// `maha` | `antar` | `pratyantar` | `sookshma`.
  final String level;

  /// The lords walked through to get here, top down.
  final List<String> path;

  /// The period these are inside. Null at the top.
  final DashaNode? parent;
  final List<DashaNode> periods;

  /// Whether the rows here have anything underneath them.
  final bool expandable;

  factory DashaLevel.fromMap(Map<String, dynamic> j) {
    final parent = (j['parent'] as Map?)?.cast<String, dynamic>();
    return DashaLevel(
      level: j['level'] as String? ?? 'maha',
      path: ((j['path'] as List<dynamic>?) ?? const [])
          .map((e) => '$e')
          .toList(),
      parent: parent == null ? null : DashaNode.fromMap(parent),
      periods: ((j['periods'] as List<dynamic>?) ?? const [])
          .map((e) => DashaNode.fromMap((e as Map).cast<String, dynamic>()))
          .toList(),
      expandable: j['expandable'] == true,
    );
  }

  DashaNode? get current {
    for (final p in periods) {
      if (p.isCurrent) return p;
    }
    return null;
  }
}

class DashaNode {
  const DashaNode({
    required this.lord,
    required this.start,
    required this.end,
    this.years = 0,
    this.days = 0,
    this.isCurrent = false,
  });

  final String lord;
  final DateTime start;
  final DateTime end;
  final double years;
  final double days;
  final bool isCurrent;

  factory DashaNode.fromMap(Map<String, dynamic> j) => DashaNode(
    lord: j['lord'] as String? ?? '',
    start: DateTime.tryParse('${j['start']}')?.toLocal() ?? DateTime(1900),
    end: DateTime.tryParse('${j['end']}')?.toLocal() ?? DateTime(2100),
    years: (j['years'] as num?)?.toDouble() ?? 0,
    days: (j['days'] as num?)?.toDouble() ?? 0,
    isCurrent: j['is_current'] == true,
  );

  bool get isPast => end.isBefore(DateTime.now());

  double progress(DateTime now) {
    final total = end.difference(start).inSeconds;
    if (total <= 0) return 0;
    return (now.difference(start).inSeconds / total).clamp(0.0, 1.0);
  }
}
