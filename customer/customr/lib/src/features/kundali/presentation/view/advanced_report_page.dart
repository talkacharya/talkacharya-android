import 'package:astro_kundali/astro_kundali.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/astro_palette.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../data/kundali_repository.dart';
import '../kundali_terms.dart';
import '../widgets/kundali_ui.dart';

/// One advanced report — `report` is ashtakavarga | shadbala | kp | jaimini.
class AdvancedReportPage extends StatefulWidget {
  const AdvancedReportPage({
    required this.profileId,
    required this.report,
    super.key,
  });

  final String profileId;
  final String report;

  @override
  State<AdvancedReportPage> createState() => _AdvancedReportPageState();
}

class _AdvancedReportPageState extends State<AdvancedReportPage> {
  late Future<Object> _future;

  KundaliRepository get _repo => GetIt.I<KundaliRepository>();

  @override
  void initState() {
    super.initState();
    _future = _fetch();
  }

  Future<Object> _fetch() => switch (widget.report) {
    'ashtakavarga' => _repo.ashtakavarga(widget.profileId),
    'shadbala' => _repo.shadbala(widget.profileId),
    'kp' => _repo.kp(widget.profileId),
    'jaimini' => _repo.jaimini(widget.profileId),
    _ => _repo.kp(widget.profileId),
  };

  String _title(AppLocalizations l) => switch (widget.report) {
    'ashtakavarga' => l.kAdvAshtakavarga,
    'shadbala' => l.kAdvShadbala,
    'kp' => l.kAdvKp,
    'jaimini' => l.kAdvJaimini,
    _ => l.kAdvReport,
  };

  String _subtitle(AppLocalizations l) => switch (widget.report) {
    'ashtakavarga' => l.kAdvAshtakavargaSub,
    'shadbala' => l.kAdvShadbalaSub,
    'kp' => l.kAdvKpSub,
    'jaimini' => l.kAdvJaiminiSub,
    _ => '',
  };

  (IconData, AstroHue) get _look => switch (widget.report) {
    'ashtakavarga' => (Icons.grid_4x4_rounded, AstroPalette.career),
    'shadbala' => (Icons.bar_chart_rounded, AstroPalette.health),
    'jaimini' => (Icons.hub_rounded, AstroPalette.love),
    _ => (Icons.tune_rounded, AstroPalette.air),
  };

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final (icon, hue) = _look;
    return FutureBuilder<Object>(
      future: _future,
      builder: (context, snap) {
        final done = snap.connectionState == ConnectionState.done;
        final data = done && !snap.hasError ? snap.data : null;
        return KundaliScaffold(
          title: _title(l),
          eyebrow: l.kAdvTitle,
          headline: _title(l),
          subheadline: _subtitle(l),
          hue: hue,
          heroTrailing: KHeroGlyph(hue: hue, icon: icon, size: 72),
          heroChips: switch (data) {
            final Ashtakavarga av when av.sarvaTotal > 0 => [
              KHeroChip(
                icon: Icons.functions_rounded,
                label: l.kAdvSarvaTotal(av.sarvaTotal),
              ),
            ],
            final Shadbala sb when sb.strongest.isNotEmpty => [
              KHeroChip(
                icon: Icons.arrow_upward_rounded,
                label: l.kAdvStrongest(KTerms.planetName(l, sb.strongest)),
                color: AstroPalette.health.start,
              ),
            ],
            _ => const <Widget>[],
          },
          onRefresh: () async {
            setState(() => _future = _fetch());
            await _future.catchError((Object _) => Object());
          },
          animate: data != null,
          children: !done
              ? const [
                  KBodySkeleton(blocks: [60, 320, 140]),
                ]
              : data == null
              ? [
                  ErrorView(
                    message: l.kAdvLoadError,
                    onRetry: () => setState(() => _future = _fetch()),
                  ),
                ]
              : switch (widget.report) {
                  'ashtakavarga' => _ashtakavarga(
                    context,
                    data as Ashtakavarga,
                  ),
                  'shadbala' => _shadbala(context, data as Shadbala),
                  'kp' => _raw(
                    context,
                    data as Map<String, dynamic>,
                    intro: l.kAdvKpIntro,
                    hue: hue,
                    sections: const [
                      'cuspal_sublords',
                      'ruling_planets',
                      'house_significators',
                    ],
                  ),
                  'jaimini' => _raw(
                    context,
                    data as Map<String, dynamic>,
                    intro: l.kAdvJaiminiIntro,
                    hue: hue,
                    sections: const [
                      'chara_karakas',
                      'arudha_padas',
                      'karakamsa',
                      'chara_dasha',
                    ],
                  ),
                  _ => const <Widget>[],
                },
        );
      },
    );
  }

  Widget _intro(BuildContext context, String text) => Text(
    text,
    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
      color: context.brand.inkMuted,
      height: 1.45,
    ),
  );

  List<Widget> _ashtakavarga(BuildContext context, Ashtakavarga data) {
    final l = context.l10n;
    return [
      _intro(context, l.kAdvAvIntro),
      KSection(
        title: l.kAdvAvHousesTitle,
        hue: AstroPalette.career,
        padTop: 18,
        child: KSurface(child: _SarvaBars(byHouse: data.sarvaByHouse)),
      ),
      KSection(
        title: l.kAdvBhinnaTotals,
        hue: AstroPalette.air,
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final p in planetOrder)
              if (data.bhinnaTotals[p] != null)
                _BinduTile(planet: p, value: data.bhinnaTotals[p]!),
          ],
        ),
      ),
      const KAskCta(),
    ];
  }

  List<Widget> _shadbala(BuildContext context, Shadbala data) {
    final l = context.l10n;
    return [
      _intro(context, l.kAdvShadbalaIntro),
      if (data.strongest.isNotEmpty || data.weakest.isNotEmpty) ...[
        const SizedBox(height: 14),
        Row(
          children: [
            if (data.strongest.isNotEmpty)
              Expanded(
                child: _Extreme(
                  planet: data.strongest,
                  label: l.kAdvStrongest(KTerms.planetName(l, data.strongest)),
                  hue: AstroPalette.health,
                ),
              ),
            if (data.strongest.isNotEmpty && data.weakest.isNotEmpty)
              const SizedBox(width: 10),
            if (data.weakest.isNotEmpty)
              Expanded(
                child: _Extreme(
                  planet: data.weakest,
                  label: l.kAdvWeakest(KTerms.planetName(l, data.weakest)),
                  hue: AstroPalette.money,
                ),
              ),
          ],
        ),
      ],
      KSection(
        title: l.kAdvShadbala,
        hue: AstroPalette.health,
        child: KSurface(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          child: Column(
            children: [for (final p in data.planets) _StrengthRow(p: p)],
          ),
        ),
      ),
      const KAskCta(),
    ];
  }

  List<Widget> _raw(
    BuildContext context,
    Map<String, dynamic> map, {
    required String intro,
    required AstroHue hue,
    required List<String> sections,
  }) {
    final l = context.l10n;
    final present = sections.where((s) => map[s] != null).toList();
    final keys = present.isEmpty
        ? map.keys.where((k) => k != 'engine').toList()
        : present;
    return [
      _intro(context, intro),
      for (var i = 0; i < keys.length; i++)
        KSection(
          title: _sectionTitle(l, keys[i]),
          hue: i.isEven ? hue : AstroPalette.career,
          padTop: i == 0 ? 18 : 22,
          child: KSurface(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: _RawValue(value: map[keys[i]]),
          ),
        ),
      KAskCta(title: l.kAdvReadWithAstrologer),
    ];
  }

  static String _sectionTitle(AppLocalizations l, String key) => switch (key) {
    'cuspal_sublords' => l.kAdvSecCuspalSublords,
    'ruling_planets' => l.kAdvSecRulingPlanets,
    'house_significators' => l.kAdvSecHouseSignificators,
    'chara_karakas' => l.kAdvSecCharaKarakas,
    'arudha_padas' => l.kAdvSecArudhaPadas,
    'karakamsa' => l.kAdvSecKarakamsa,
    'chara_dasha' => l.kAdvSecCharaDasha,
    _ => key.replaceAll('_', ' '),
  };
}

/// Sarvashtakavarga points per house as gradient bars: ≥28 strong, <25 weak.
class _SarvaBars extends StatelessWidget {
  const _SarvaBars({required this.byHouse});
  final Map<String, int> byHouse;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final vals = byHouse.values.toList()..sort();
    final maxV = vals.isEmpty ? 1 : vals.last;
    return Column(
      children: [
        for (var h = 1; h <= 12; h++)
          Builder(
            builder: (context) {
              final v = byHouse['$h'] ?? 0;
              final hue = v >= 28
                  ? AstroPalette.health
                  : v < 25
                  ? AstroPalette.money
                  : AstroPalette.career;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  children: [
                    SizedBox(
                      width: 72,
                      child: Text(
                        l.kAdvHouseN(h),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: context.brand.inkMuted,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(99),
                        child: Stack(
                          children: [
                            Container(height: 10, color: hue.tint(0.13)),
                            FractionallySizedBox(
                              widthFactor: maxV == 0
                                  ? 0
                                  : (v / maxV).clamp(0.0, 1.0),
                              child: Container(
                                height: 10,
                                decoration: BoxDecoration(
                                  gradient: hue.linear(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 34,
                      child: Text(
                        '$v',
                        textAlign: TextAlign.end,
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: hue.end,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }
}

class _BinduTile extends StatelessWidget {
  const _BinduTile({required this.planet, required this.value});
  final String planet;
  final int value;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return SizedBox(
      width: 104,
      child: KSurface(
        radius: 16,
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            PlanetBadge(planet, size: 28),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$value',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    KTerms.planetName(l, planet),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: context.brand.inkMuted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Extreme extends StatelessWidget {
  const _Extreme({
    required this.planet,
    required this.label,
    required this.hue,
  });
  final String planet;
  final String label;
  final AstroHue hue;

  @override
  Widget build(BuildContext context) => KHueCard(
    hue: hue,
    padding: const EdgeInsets.all(12),
    child: Row(
      children: [
        PlanetBadge(planet, size: 34),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w700,
              height: 1.3,
            ),
          ),
        ),
      ],
    ),
  );
}

class _StrengthRow extends StatelessWidget {
  const _StrengthRow({required this.p});
  final PlanetStrength p;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final hue = p.isStrong ? AstroPalette.health : AstroPalette.money;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          PlanetBadge(p.name, size: 34),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        KTerms.planetName(l, p.name),
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(
                      '${p.totalRupa.toStringAsFixed(1)} / ${p.requiredRupa.toStringAsFixed(1)}',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: context.brand.inkMuted,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      p.isStrong
                          ? Icons.check_circle_rounded
                          : Icons.remove_circle_outline_rounded,
                      size: 16,
                      color: hue.end,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: Stack(
                    children: [
                      Container(height: 7, color: hue.tint(0.13)),
                      FractionallySizedBox(
                        widthFactor: (p.ratio / 1.6).clamp(0.0, 1.0),
                        child: Container(
                          height: 7,
                          decoration: BoxDecoration(gradient: hue.linear()),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A raw KP / Jaimini value: maps become label ↔ value rows, lists join.
class _RawValue extends StatelessWidget {
  const _RawValue({required this.value});
  final Object? value;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final v = value;
    if (v is Map) {
      final entries = v.entries.toList();
      return Column(
        children: [
          for (var i = 0; i < entries.length; i++) ...[
            if (i > 0) Divider(height: 1, color: context.brand.hairline),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 110,
                    child: Text(
                      KTerms.displayName(
                        l,
                        '${entries[i].key}'.replaceAll('_', ' '),
                      ),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: context.brand.inkMuted,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      _flat(l, entries[i].value),
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(
        _flat(l, v),
        style: theme.textTheme.bodyMedium?.copyWith(height: 1.45),
      ),
    );
  }

  /// Flattens a raw technical value; planet / sign / nakshatra names inside it
  /// are shown in the app language.
  static String _flat(AppLocalizations l, Object? v) {
    if (v is Map) {
      return v.entries.map((e) => '${e.key}: ${_flat(l, e.value)}').join(', ');
    }
    if (v is List) return v.map((x) => _flat(l, x)).join(', ');
    if (v is double) return v.toStringAsFixed(2);
    if (v is String) return KTerms.displayName(l, v);
    return '$v';
  }
}
