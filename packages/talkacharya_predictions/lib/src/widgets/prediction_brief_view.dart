import 'package:flutter/material.dart';

/// Renders a prediction's `factor_brief` (the engine snapshot) for the
/// astrologer. Self-contained — no dependency on `astro_kundali`. The brief is
/// `{factors: {lagna, houses, planets, karakas}, dasha, transits, area_houses}`.
class PredictionBriefView extends StatelessWidget {
  const PredictionBriefView({required this.brief, super.key});

  final Map<String, dynamic>? brief;

  @override
  Widget build(BuildContext context) {
    final b = brief ?? const {};
    if (b.isEmpty || b['error'] != null) {
      return _Note(
        b['error']?.toString() ??
            'Chart brief unavailable — work from the client\'s kundali directly.',
      );
    }
    final theme = Theme.of(context);
    final factors = (b['factors'] as Map?)?.cast<String, dynamic>() ?? const {};
    final lagna = (factors['lagna'] as Map?)?.cast<String, dynamic>() ?? const {};
    final houses = (factors['houses'] as Map?)?.cast<String, dynamic>() ?? const {};
    final planets = (factors['planets'] as Map?)?.cast<String, dynamic>() ?? const {};
    final karakas = (factors['karakas'] as Map?)?.cast<String, dynamic>() ?? const {};
    final dasha = (b['dasha'] as Map?)?.cast<String, dynamic>() ?? const {};
    final transits = (b['transits'] as Map?)?.cast<String, dynamic>() ?? const {};
    final areaHouses = (b['area_houses'] as List?)?.cast<dynamic>() ?? const [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Section('Ascendant', [
          '${lagna['sign'] ?? '—'} · lord ${lagna['lord'] ?? '—'} '
              'in ${lagna['lord_in_house'] ?? '—'} (${lagna['lord_dignity'] ?? '—'})',
          if ((lagna['occupants'] as List?)?.isNotEmpty ?? false)
            'Occupants: ${(lagna['occupants'] as List).join(', ')}',
        ]),
        if (dasha.isNotEmpty)
          _Section('Running dasha', [
            [
              if (dasha['maha'] != null) 'Maha ${dasha['maha']}',
              if (dasha['antar'] != null) 'Antar ${dasha['antar']}',
              if (dasha['pratyantar'] != null) 'Pratyantar ${dasha['pratyantar']}',
            ].join(' · '),
          ]),
        if (transits.isNotEmpty)
          _Section('Transits', [
            if ((transits['sade_sati'] as Map?)?['active'] == true)
              'Sade Sati active — ${(transits['sade_sati'] as Map)['phase'] ?? ''} phase',
            if (transits['jupiter'] is Map)
              'Jupiter: house ${(transits['jupiter'] as Map)['house_from_moon'] ?? '—'} from Moon',
          ]),
        if (areaHouses.isNotEmpty)
          _Section('Houses that matter here', [
            for (final h in areaHouses)
              _houseLine(houses['$h'] as Map?, h.toString()),
          ]),
        _Section('Planet strength (0–3)', [
          for (final e in planets.entries)
            '${e.key}: ${(e.value as Map?)?['strength'] ?? '—'} '
                '(${(e.value as Map?)?['sign'] ?? '—'}, h${(e.value as Map?)?['house'] ?? '—'}'
                '${(e.value as Map?)?['retrograde'] == true ? ', R' : ''})',
        ]),
        if (karakas.isNotEmpty)
          _Section('Chara karakas', [
            for (final e in karakas.entries) '${e.key}: ${e.value}',
          ]),
        const SizedBox(height: 8),
        Text(
          'Structural inputs only — you write the forecast.',
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  static String _houseLine(Map<dynamic, dynamic>? h, String n) {
    if (h == null) return 'House $n: —';
    return 'H$n (${h['sign'] ?? '—'}): lord ${h['lord'] ?? '—'} in '
        '${h['lord_in_house'] ?? '—'}, strength ${h['house_strength'] ?? '—'}'
        '${(h['occupants'] as List?)?.isNotEmpty ?? false ? ', with ${(h['occupants'] as List).join(', ')}' : ''}';
  }
}

class _Section extends StatelessWidget {
  const _Section(this.title, this.lines);
  final String title;
  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final visible = lines.where((l) => l.trim().isNotEmpty).toList();
    if (visible.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          for (final l in visible)
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text('· $l', style: const TextStyle(fontSize: 12.5, height: 1.4)),
            ),
        ],
      ),
    );
  }
}

class _Note extends StatelessWidget {
  const _Note(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(text, style: const TextStyle(fontSize: 13)),
  );
}
