import 'package:flutter/material.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/astro_palette.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/hue_widgets.dart';
import '../../../../shared/widgets/settings_widgets.dart';
import '../../data/consultation_api.dart';
import '../../data/models/consultation_share.dart';
import '../widgets/shared_details.dart';

/// The Guna Milan report the customer shared: score, the two people, the koota
/// table and doshas.
class MatchReportPage extends StatefulWidget {
  const MatchReportPage({
    required this.consultationId,
    required this.matchId,
    super.key,
  });

  final String consultationId;
  final String matchId;

  @override
  State<MatchReportPage> createState() => _MatchReportPageState();
}

class _MatchReportPageState extends State<MatchReportPage> {
  late Future<MatchReport> _future = _load();

  Future<MatchReport> _load() => getIt<ConsultationApi>().sharedMatch(
    widget.consultationId,
    widget.matchId,
  );

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return FutureBuilder<MatchReport>(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(title: Text(l.matchReportTitle)),
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        if (snap.hasError || !snap.hasData) {
          return Scaffold(
            appBar: AppBar(title: Text(l.matchReportTitle)),
            body: ErrorView(
              message: l.matchLoadError,
              onRetry: () => setState(() => _future = _load()),
            ),
          );
        }
        final r = snap.data!;
        return SubPageScaffold(
          title: l.matchReportTitle,
          children: [
            _Score(report: r),
            if (r.summary.boy != null)
              SharedPersonCard(
                consultationId: widget.consultationId,
                person: r.summary.boy!,
              ),
            if (r.summary.girl != null)
              SharedPersonCard(
                consultationId: widget.consultationId,
                person: r.summary.girl!,
              ),
            if (r.kootas.isNotEmpty)
              SettingsCard(
                title: l.matchKootas,
                icon: Icons.grid_view_rounded,
                hue: AstroPalette.career,
                child: Column(
                  children: [for (final k in r.kootas) _KootaRow(koota: k)],
                ),
              ),
            SettingsCard(
              title: l.matchDoshas,
              icon: Icons.warning_amber_rounded,
              hue: AstroPalette.fire,
              child: _Doshas(doshas: r.doshas),
            ),
          ],
        );
      },
    );
  }
}

class _Score extends StatelessWidget {
  const _Score({required this.report});

  final MatchReport report;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    final m = report.summary;
    final hue = AstroPalette.ratio(m.ratio);
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Radii.lg),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [hue.tint(0.18), Theme.of(context).colorScheme.surface],
        ),
        border: Border.all(color: hue.tint(0.3)),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              HueIcon(
                hue: hue,
                icon: Icons.favorite_rounded,
                size: 52,
                iconSize: 26,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l.sharedPoints(m.pointsLabel, m.maxLabel),
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: hue.end,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (m.verdict.isNotEmpty)
                      Text(
                        m.verdict,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: brand.inkMuted,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(Radii.pill),
            child: TweenAnimationBuilder<double>(
              tween: Tween(end: m.ratio),
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeOutCubic,
              builder: (_, v, _) => LinearProgressIndicator(
                value: v,
                minHeight: 8,
                color: hue.end,
                backgroundColor: hue.tint(0.15),
              ),
            ),
          ),
          if (report.description.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(report.description, style: theme.textTheme.bodyMedium),
          ],
        ],
      ),
    );
  }
}

class _KootaRow extends StatelessWidget {
  const _KootaRow({required this.koota});

  final MatchKoota koota;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final theme = Theme.of(context);
    final hue = AstroPalette.ratio(koota.ratio);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 92,
            child: Text(
              koota.name,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: koota.isZero ? brand.live : null,
              ),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Radii.pill),
              child: LinearProgressIndicator(
                value: koota.ratio,
                minHeight: 6,
                color: koota.isZero ? brand.live : hue.end,
                backgroundColor: brand.sectionBg,
              ),
            ),
          ),
          SizedBox(
            width: 56,
            child: Text(
              '${_trim(koota.points)}/${_trim(koota.maxPoints)}',
              textAlign: TextAlign.end,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: koota.isZero ? brand.live : brand.inkMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _trim(double v) =>
      v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(1);
}

class _Doshas extends StatelessWidget {
  const _Doshas({required this.doshas});

  final Map<String, bool> doshas;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final present = doshas.entries.where((e) => e.value).toList();
    if (present.isEmpty) {
      return Row(
        children: [
          Icon(Icons.check_circle_rounded, color: brand.online, size: 20),
          const SizedBox(width: 8),
          Text(
            l.matchNoDoshas,
            style: TextStyle(color: brand.online, fontWeight: FontWeight.w700),
          ),
        ],
      );
    }
    String label(String key) => switch (key) {
      'nadi' => l.matchDoshaNadi,
      'bhakoot' => l.matchDoshaBhakoot,
      'gana' => l.matchDoshaGana,
      _ => key,
    };
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final e in present)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: brand.live.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline_rounded, size: 15, color: brand.live),
                const SizedBox(width: 5),
                Text(
                  label(e.key),
                  style: TextStyle(
                    color: brand.live,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
