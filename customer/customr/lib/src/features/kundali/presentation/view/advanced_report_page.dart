import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../data/kundali_repository.dart';
import 'package:astro_kundali/astro_kundali.dart';
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

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(_title(l))),
      body: FutureBuilder<Object>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError || !snap.hasData) {
            return ErrorView(
              message: l.kAdvLoadError,
              onRetry: () => setState(() => _future = _fetch()),
            );
          }
          final data = snap.data!;
          return switch (widget.report) {
            'ashtakavarga' => _AshtakavargaView(data: data as Ashtakavarga),
            'shadbala' => _ShadbalaView(data: data as Shadbala),
            'kp' => _RawReport(
              map: data as Map<String, dynamic>,
              intro: l.kAdvKpIntro,
              sections: const [
                'cuspal_sublords',
                'ruling_planets',
                'house_significators',
              ],
            ),
            'jaimini' => _RawReport(
              map: data as Map<String, dynamic>,
              intro: l.kAdvJaiminiIntro,
              sections: const [
                'chara_karakas',
                'arudha_padas',
                'karakamsa',
                'chara_dasha',
              ],
            ),
            _ => const SizedBox.shrink(),
          };
        },
      ),
    );
  }
}

class _AshtakavargaView extends StatelessWidget {
  const _AshtakavargaView({required this.data});
  final Ashtakavarga data;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l = context.l10n;
    final byHouse = data.sarvaByHouse;
    final vals = byHouse.values.toList()..sort();
    final maxV = vals.isEmpty ? 1 : vals.last;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      children: [
        Text(
          l.kAdvAvIntro,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
        ),
        const SizedBox(height: 14),
        KCard(
          child: Column(
            children: [
              for (var h = 1; h <= 12; h++)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 62,
                        child: Text(
                          l.kAdvHouseN(h),
                          style: const TextStyle(fontSize: 12.5),
                        ),
                      ),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(99),
                          child: LinearProgressIndicator(
                            value: maxV == 0 ? 0 : (byHouse['$h'] ?? 0) / maxV,
                            minHeight: 8,
                            backgroundColor: scheme.surfaceContainerHighest,
                            valueColor: AlwaysStoppedAnimation(
                              (byHouse['$h'] ?? 0) >= 28
                                  ? const Color(0xFF2E9E4F)
                                  : (byHouse['$h'] ?? 0) < 25
                                  ? const Color(0xFFC77A1F)
                                  : scheme.primary,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 30,
                        child: Text(
                          '${byHouse['$h'] ?? 0}',
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 12.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        KLabel(l.kAdvBhinnaTotals),
        const SizedBox(height: 8),
        KCard(
          child: Wrap(
            spacing: 14,
            runSpacing: 8,
            children: [
              for (final p in planetOrder)
                if (data.bhinnaTotals[p] != null)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: planetColor(p),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '${KTerms.planetName(l, p)} ${data.bhinnaTotals[p]}',
                        style: const TextStyle(fontSize: 12.5),
                      ),
                    ],
                  ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ShadbalaView extends StatelessWidget {
  const _ShadbalaView({required this.data});
  final Shadbala data;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l = context.l10n;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      children: [
        Text(
          l.kAdvShadbalaIntro,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
        ),
        const SizedBox(height: 14),
        KCard(
          child: Column(
            children: [
              for (final p in data.planets)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 22,
                            height: 22,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: planetColor(p.name),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              KundaliStrings.of(context).planetToken(p.name),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              KTerms.planetName(l, p.name),
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Text(
                            '${p.totalRupa.toStringAsFixed(1)} / ${p.requiredRupa.toStringAsFixed(1)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            p.isStrong
                                ? Icons.check_circle_rounded
                                : Icons.remove_circle_outline_rounded,
                            size: 16,
                            color: p.isStrong
                                ? const Color(0xFF2E9E4F)
                                : const Color(0xFFC77A1F),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(99),
                        child: LinearProgressIndicator(
                          value: (p.ratio / 1.6).clamp(0.0, 1.0),
                          minHeight: 7,
                          backgroundColor: scheme.surfaceContainerHighest,
                          valueColor: AlwaysStoppedAnimation(
                            p.isStrong
                                ? const Color(0xFF2E9E4F)
                                : const Color(0xFFC77A1F),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: MetaChip(
                l.kAdvStrongest(KTerms.planetName(l, data.strongest)),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: MetaChip(
                l.kAdvWeakest(KTerms.planetName(l, data.weakest)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _RawReport extends StatelessWidget {
  const _RawReport({
    required this.map,
    required this.intro,
    required this.sections,
  });
  final Map<String, dynamic> map;
  final String intro;
  final List<String> sections;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l = context.l10n;
    final present = sections.where((s) => map[s] != null).toList();
    final keys = present.isEmpty
        ? map.keys.where((k) => k != 'engine').toList()
        : present;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      children: [
        Text(
          intro,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
        ),
        const SizedBox(height: 14),
        for (final key in keys) ...[
          KLabel(_sectionTitle(l, key)),
          const SizedBox(height: 8),
          KCard(child: _renderValue(context, l, map[key])),
          const SizedBox(height: 12),
        ],
        KCard(
          tint: true,
          child: Column(
            children: [
              Text(
                l.kAdvReadWithAstrologer,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 6),
              AskAstrologerBar(label: l.kundaliTalkToAstrologer, onTap: () {}),
            ],
          ),
        ),
      ],
    );
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

  Widget _renderValue(BuildContext context, AppLocalizations l, Object? value) {
    final scheme = Theme.of(context).colorScheme;
    if (value is Map) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final e in value.entries)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 110,
                    child: Text(
                      '${e.key}'.replaceAll('_', ' '),
                      style: TextStyle(
                        fontSize: 12.5,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      _flat(l, e.value),
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      );
    }
    if (value is List) {
      return Text(
        value.map((v) => _flat(l, v)).join(', '),
        style: const TextStyle(fontSize: 12.5),
      );
    }
    return Text(_flat(l, value), style: const TextStyle(fontSize: 12.5));
  }

  /// Flattens a raw technical value; planet / sign / nakshatra names inside it
  /// are shown in the app language.
  String _flat(AppLocalizations l, Object? v) {
    if (v is Map) {
      return v.entries.map((e) => '${e.key}: ${_flat(l, e.value)}').join(', ');
    }
    if (v is List) return v.map((x) => _flat(l, x)).join(', ');
    if (v is double) return v.toStringAsFixed(2);
    if (v is String) return KTerms.displayName(l, v);
    return '$v';
  }
}
