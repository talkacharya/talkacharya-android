import 'package:astro_kundali/astro_kundali.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/astro_palette.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../../core/util/async_value.dart';
import '../cubit/kundali_cubit.dart';
import '../kundali_terms.dart';
import '../widgets/k_chart.dart';
import '../widgets/kundali_ui.dart';

/// Planetary periods: what's running now and the whole life timeline, in the
/// Vimshottari, Yogini or Ashtottari system.
class DashaPage extends StatefulWidget {
  const DashaPage({required this.profileId, super.key});
  final String profileId;

  @override
  State<DashaPage> createState() => _DashaPageState();
}

class _DashaPageState extends State<DashaPage> {
  static const _systems = ['vimshottari', 'yogini', 'ashtottari'];
  String _system = 'vimshottari';

  @override
  void initState() {
    super.initState();
    context.read<KundaliCubit>()
      ..loadDasha()
      ..loadAllDashas()
      ..loadDashaNarrative();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return BlocBuilder<KundaliCubit, KundaliState>(
      builder: (context, state) {
        final cubit = context.read<KundaliCubit>();
        final timeline = _system == 'vimshottari'
            ? state.dasha
            : state.allDashas.when<AsyncValue<DashaTimeline>>(
                idle: () => const AsyncValue.loading(),
                loading: () => const AsyncValue.loading(),
                error: (m) => AsyncValue.error(m),
                data: (m) => m[_system] == null
                    ? const AsyncValue.error('missing')
                    : AsyncValue.data(m[_system]!),
              );
        final d = timeline.value;
        final narrative = _system == 'vimshottari'
            ? state.dashaNarrative.value
            : null;
        final maha = d?.currentMaha ?? '';
        final hue = maha.isEmpty ? AstroPalette.career : kPlanetHue(maha);
        final labels = [
          l.kDashaVimshottari,
          l.kDashaYogini,
          l.kDashaAshtottari,
        ];

        return KundaliScaffold(
          title: l.kOvExDasha,
          eyebrow: '${l.kOvExDasha} · ${labels[_systems.indexOf(_system)]}',
          headline: maha.isEmpty
              ? l.kOvExDasha
              : l.kOvMahadasha(KTerms.displayName(l, maha)),
          subheadline: d == null || d.currentAntar.isEmpty
              ? null
              : [
                  KTerms.displayName(l, d.currentAntar),
                  if (d.currentPratyantar.isNotEmpty)
                    KTerms.displayName(l, d.currentPratyantar),
                ].join(' › '),
          hue: hue,
          heroTrailing: maha.isEmpty
              ? null
              : KHeroGlyph(
                  hue: hue,
                  text: KundaliStrings.of(context).planetToken(maha),
                  size: 72,
                ),
          heroBottom: Align(
            alignment: Alignment.centerLeft,
            child: KDarkSegment(
              labels: labels,
              selected: _systems.indexOf(_system),
              onSelect: (i) => setState(() => _system = _systems[i]),
            ),
          ),
          onRefresh: () async {
            await Future.wait([
              cubit.loadDasha(force: true),
              cubit.loadAllDashas(force: true),
              cubit.loadDashaNarrative(force: true),
            ]);
          },
          animate: d != null,
          children: d == null
              ? [
                  SliceBuilder<DashaTimeline>(
                    slice: timeline,
                    onRetry: () => cubit
                      ..loadDasha(force: true)
                      ..loadAllDashas(force: true),
                    skeleton: const KBodySkeleton(blocks: [170, 70, 70, 70]),
                    builder: (_, _) => const SizedBox.shrink(),
                  ),
                ]
              : [
                  Text(
                    switch (_system) {
                      'vimshottari' => l.kDashaIntroVimshottari,
                      'yogini' => l.kDashaIntroYogini,
                      _ => l.kDashaIntroAshtottari,
                    },
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: context.brand.inkMuted,
                      height: 1.45,
                    ),
                  ),
                  if (d.currentMaha.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    _NowRunning(timeline: d, narrative: narrative),
                  ],
                  KSection(
                    title: l.kDashaTimelineTitle,
                    subtitle: d.balanceLord.isEmpty
                        ? null
                        : l.kDashaBalance(
                            KTerms.displayName(l, d.balanceLord),
                            d.balanceYears.toStringAsFixed(1),
                          ),
                    hue: hue,
                    child: _Timeline(timeline: d, narrative: narrative),
                  ),
                  if (narrative != null && narrative.disclaimer.isNotEmpty)
                    KFootnote(narrative.disclaimer),
                  const KAskCta(),
                ],
        );
      },
    );
  }
}

class _NowRunning extends StatelessWidget {
  const _NowRunning({required this.timeline, required this.narrative});
  final DashaTimeline timeline;
  final DashaNarrative? narrative;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final d = timeline;
    final span = d.currentSpan;
    final progress = (span?.progress(DateTime.now()) ?? 0).clamp(0.0, 1.0);
    final hue = kPlanetHue(d.currentMaha);
    final antarSummary = narrative
        ?.antarFor(d.currentMaha, d.currentAntar)
        ?.summary;
    return KHueCard(
      hue: hue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 6,
            children: [
              KToneChip(l.kDashaNowRunning, hue: hue),
              if (span != null)
                Text(
                  '${span.start.year} → ${span.end.year}',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: hue.end,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              for (final (i, lord) in [
                d.currentMaha,
                d.currentAntar,
                d.currentPratyantar,
              ].where((e) => e.isNotEmpty).indexed) ...[
                if (i > 0)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Icon(
                      Icons.chevron_right_rounded,
                      size: 18,
                      color: context.brand.inkMuted,
                    ),
                  ),
                Flexible(
                  child: Column(
                    children: [
                      PlanetBadge(lord, size: i == 0 ? 44 : 34),
                      const SizedBox(height: 4),
                      Text(
                        KTerms.displayName(l, lord),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: i == 0
                              ? FontWeight.w800
                              : FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: Stack(
              children: [
                Container(height: 8, color: hue.tint(0.15)),
                FractionallySizedBox(
                  widthFactor: progress,
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(gradient: hue.linear()),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l.kDashaProgressPct('${(progress * 100).round()}'),
            style: theme.textTheme.labelSmall?.copyWith(
              color: context.brand.inkMuted,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            narrative?.mahaFor(d.currentMaha)?.summary ??
                KTerms.dashaTone(l, d.currentMaha),
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
          ),
          if ((antarSummary ?? '').isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              antarSummary!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: context.brand.inkMuted,
                height: 1.45,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Timeline extends StatelessWidget {
  const _Timeline({required this.timeline, required this.narrative});
  final DashaTimeline timeline;
  final DashaNarrative? narrative;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final periods = timeline.periods;
    return Column(
      children: [
        for (var i = 0; i < periods.length; i++)
          _MahaNode(
            key: ValueKey('${periods[i].lord}-${periods[i].start}'),
            span: periods[i],
            note: narrative?.mahaFor(periods[i].lord),
            isCurrent: periods[i].contains(now),
            isPast: periods[i].end.isBefore(now),
            first: i == 0,
            last: i == periods.length - 1,
          ),
      ],
    );
  }
}

/// One mahadasha on the vertical rail; expands to its note + antardashas.
class _MahaNode extends StatefulWidget {
  const _MahaNode({
    required this.span,
    super.key,
    required this.note,
    required this.isCurrent,
    required this.isPast,
    required this.first,
    required this.last,
  });

  final DashaSpan span;
  final DashaPeriodNote? note;
  final bool isCurrent;
  final bool isPast;
  final bool first;
  final bool last;

  @override
  State<_MahaNode> createState() => _MahaNodeState();
}

class _MahaNodeState extends State<_MahaNode> {
  late bool _open = widget.isCurrent;

  DashaPeriodNote? _antarNote(String lord) {
    for (final a in widget.note?.antardashas ?? const <DashaPeriodNote>[]) {
      if (a.lord == lord) return a;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    final hue = kPlanetHue(widget.span.lord);
    final years = widget.span.end.difference(widget.span.start).inDays ~/ 365;
    final expandable =
        widget.span.children.isNotEmpty ||
        (widget.note?.summary ?? '').isNotEmpty;
    final now = DateTime.now();

    // The rail is painted behind the row so the card can grow (expand /
    // animate) freely — no intrinsic-height pass.
    const dotCenter = 22.0;
    return Stack(
      children: [
        Positioned(
          left: 13,
          top: widget.first ? dotCenter : 0,
          bottom: widget.last ? null : 0,
          height: widget.last ? dotCenter : null,
          child: Container(width: 2, color: brand.hairline),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 28,
              height: dotCenter * 2,
              child: Center(
                child: Container(
                  width: widget.isCurrent ? 18 : 12,
                  height: widget.isCurrent ? 18 : 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: widget.isPast ? null : hue.linear(),
                    color: widget.isPast ? brand.hairline : null,
                    border: widget.isCurrent
                        ? Border.all(color: hue.tint(0.4), width: 4)
                        : null,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Opacity(
                  opacity: widget.isPast && !_open ? 0.55 : 1,
                  child: KSurface(
                    radius: 16,
                    padding: const EdgeInsets.all(12),
                    color: widget.isCurrent
                        ? Color.alphaBlend(
                            hue.tint(0.08),
                            theme.colorScheme.surface,
                          )
                        : null,
                    borderColor: widget.isCurrent ? hue.tint(0.4) : null,
                    onTap: expandable
                        ? () => setState(() => _open = !_open)
                        : null,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            PlanetBadge(widget.span.lord, size: 32),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l.kOvMahadasha(
                                      KTerms.displayName(l, widget.span.lord),
                                    ),
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    '${widget.span.start.year} – ${widget.span.end.year} · ${l.kDashaYears(years)}',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: brand.inkMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (widget.isCurrent)
                              KToneChip(l.kDashaNow, hue: hue),
                            if (expandable)
                              AnimatedRotation(
                                turns: _open ? 0.5 : 0,
                                duration: const Duration(milliseconds: 200),
                                child: Icon(
                                  Icons.expand_more_rounded,
                                  color: brand.inkMuted,
                                ),
                              ),
                          ],
                        ),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 220),
                          alignment: Alignment.topCenter,
                          child: !_open
                              ? const SizedBox(width: double.infinity)
                              : Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    if ((widget.note?.summary ?? '').isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Text(
                                          widget.note!.summary,
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(height: 1.45),
                                        ),
                                      ),
                                    if (widget.span.children.isNotEmpty) ...[
                                      const SizedBox(height: 10),
                                      for (final antar in widget.span.children)
                                        _AntarRow(
                                          maha: widget.span.lord,
                                          antar: antar,
                                          note: _antarNote(antar.lord),
                                          isCurrent: antar.contains(now),
                                        ),
                                    ],
                                  ],
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _AntarRow extends StatefulWidget {
  const _AntarRow({
    required this.maha,
    required this.antar,
    required this.note,
    required this.isCurrent,
  });
  final String maha;
  final DashaSpan antar;
  final DashaPeriodNote? note;
  final bool isCurrent;

  @override
  State<_AntarRow> createState() => _AntarRowState();
}

class _AntarRowState extends State<_AntarRow> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = context.l10n;
    final hue = kPlanetHue(widget.antar.lord);
    final summary = widget.note?.summary ?? '';
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: summary.isEmpty ? null : () => setState(() => _open = !_open),
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: widget.isCurrent ? hue.tint(0.12) : context.brand.sectionBg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                PlanetBadge(widget.antar.lord, size: 22),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${KTerms.displayName(l, widget.maha)} › '
                    '${KTerms.displayName(l, widget.antar.lord)}',
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: widget.isCurrent
                          ? FontWeight.w800
                          : FontWeight.w500,
                    ),
                  ),
                ),
                Text(
                  '${widget.antar.start.year} – ${widget.antar.end.year}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: context.brand.inkMuted,
                  ),
                ),
                if (summary.isNotEmpty)
                  Icon(
                    _open
                        ? Icons.expand_less_rounded
                        : Icons.expand_more_rounded,
                    size: 16,
                    color: context.brand.inkMuted,
                  ),
              ],
            ),
            if (_open && summary.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  summary,
                  style: theme.textTheme.bodySmall?.copyWith(height: 1.4),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
