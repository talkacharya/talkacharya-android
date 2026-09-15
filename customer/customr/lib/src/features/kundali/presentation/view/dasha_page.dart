import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:astro_kundali/astro_kundali.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/util/async_value.dart';
import '../cubit/kundali_cubit.dart';
import '../kundali_terms.dart';
import '../widgets/kundali_ui.dart';

class DashaPage extends StatefulWidget {
  const DashaPage({required this.profileId, super.key});
  final String profileId;

  @override
  State<DashaPage> createState() => _DashaPageState();
}

class _DashaPageState extends State<DashaPage> {
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
    return Scaffold(
      appBar: AppBar(title: Text(l.kOvExDasha)),
      body: BlocBuilder<KundaliCubit, KundaliState>(
        builder: (context, state) {
          final timeline = _system == 'vimshottari'
              ? state.dasha
              : state.allDashas.when<AsyncValue<DashaTimeline>>(
                  idle: () => const AsyncValue.loading(),
                  loading: () => const AsyncValue.loading(),
                  error: (m) => AsyncValue.error(m),
                  data: (m) => AsyncValue.data(m[_system]!),
                );
          final narrative = _system == 'vimshottari'
              ? state.dashaNarrative.value
              : null;
          return SliceBuilder<DashaTimeline>(
            slice: timeline,
            onRetry: () => context.read<KundaliCubit>()
              ..loadDasha()
              ..loadAllDashas()
              ..loadDashaNarrative(),
            builder: (context, d) => ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
              children: [
                Text(
                  _system == 'vimshottari'
                      ? l.kDashaIntroVimshottari
                      : _system == 'yogini'
                      ? l.kDashaIntroYogini
                      : l.kDashaIntroAshtottari,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),
                _systemToggle(),
                const SizedBox(height: 14),
                if (d.currentMaha.isNotEmpty)
                  _nowRunning(context, d, narrative),
                const SizedBox(height: 12),
                _timeline(context, d, narrative),
                if (narrative != null && narrative.disclaimer.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(
                    narrative.disclaimer,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                ],
                if (d.balanceLord.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      l.kDashaBalance(
                        KTerms.displayName(l, d.balanceLord),
                        d.balanceYears.toStringAsFixed(1),
                      ),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _systemToggle() {
    final scheme = Theme.of(context).colorScheme;
    final l = context.l10n;
    const systems = ['vimshottari', 'yogini', 'ashtottari'];
    final labels = [l.kDashaVimshottari, l.kDashaYogini, l.kDashaAshtottari];
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(11),
      ),
      child: Row(
        children: [
          for (var i = 0; i < systems.length; i++)
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _system = systems[i]),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: _system == systems[i]
                        ? scheme.surface
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    labels[i],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12.5,
                      color: _system == systems[i]
                          ? scheme.onSurface
                          : scheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _nowRunning(
    BuildContext context,
    DashaTimeline d,
    DashaNarrative? narrative,
  ) {
    final span = d.currentSpan;
    final progress = span?.progress(DateTime.now()) ?? 0;
    final l = context.l10n;
    return KCard(
      tint: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          KLabel(l.kDashaNowRunning),
          const SizedBox(height: 5),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                KTerms.displayName(l, d.currentMaha),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              if (d.currentAntar.isNotEmpty)
                Text(
                  '  ›  ${KTerms.displayName(l, d.currentAntar)}',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              if (d.currentPratyantar.isNotEmpty)
                Text(
                  '  ›  ${KTerms.displayName(l, d.currentPratyantar)}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(value: progress, minHeight: 6),
          ),
          if (span != null) ...[
            const SizedBox(height: 5),
            Text(
              '${span.start.year} → ${span.end.year}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(height: 10),
          Text(
            narrative?.mahaFor(d.currentMaha)?.summary ??
                KTerms.dashaTone(context.l10n, d.currentMaha),
            style: const TextStyle(fontSize: 13, height: 1.45),
          ),
          if (narrative != null &&
              d.currentAntar.isNotEmpty &&
              (narrative.antarFor(d.currentMaha, d.currentAntar)?.summary ?? '')
                  .isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              narrative.antarFor(d.currentMaha, d.currentAntar)!.summary,
              style: TextStyle(
                fontSize: 12.5,
                height: 1.4,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _timeline(
    BuildContext context,
    DashaTimeline d,
    DashaNarrative? narrative,
  ) {
    final now = DateTime.now();
    return KCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      child: Column(
        children: [
          for (var i = 0; i < d.periods.length; i++)
            _MahaRow(
              span: d.periods[i],
              note: narrative?.mahaFor(d.periods[i].lord),
              isCurrent: d.periods[i].contains(now),
              isPast: d.periods[i].end.isBefore(now),
              last: i == d.periods.length - 1,
            ),
        ],
      ),
    );
  }
}

class _MahaRow extends StatefulWidget {
  const _MahaRow({
    required this.span,
    required this.note,
    required this.isCurrent,
    required this.isPast,
    required this.last,
  });
  final DashaSpan span;
  final DashaPeriodNote? note;
  final bool isCurrent;
  final bool isPast;
  final bool last;

  @override
  State<_MahaRow> createState() => _MahaRowState();
}

class _MahaRowState extends State<_MahaRow> {
  late bool _open = widget.isCurrent;

  DashaPeriodNote? _antarNote(String lord) {
    for (final a in widget.note?.antardashas ?? const <DashaPeriodNote>[]) {
      if (a.lord == lord) return a;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l = context.l10n;
    final now = DateTime.now();
    return Container(
      decoration: BoxDecoration(
        border: widget.last
            ? null
            : Border(bottom: BorderSide(color: scheme.outlineVariant)),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: widget.span.children.isEmpty
                ? null
                : () => setState(() => _open = !_open),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Opacity(
                opacity: widget.isPast && !_open ? 0.5 : 1,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 5,
                      height: 34,
                      margin: const EdgeInsets.only(right: 12, top: 1),
                      decoration: BoxDecoration(
                        color: planetColor(widget.span.lord),
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                l.kOvMahadasha(
                                  KTerms.displayName(l, widget.span.lord),
                                ),
                                style: TextStyle(
                                  fontWeight: widget.isCurrent
                                      ? FontWeight.w700
                                      : FontWeight.w600,
                                  fontSize: widget.isCurrent ? 15 : 14,
                                ),
                              ),
                              if (widget.isCurrent) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 1,
                                  ),
                                  decoration: BoxDecoration(
                                    color: scheme.primary,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    l.kDashaNow,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          Text(
                            '${widget.span.start.year} – ${widget.span.end.year}  ·  '
                            '${l.kDashaYears(widget.span.end.difference(widget.span.start).inDays ~/ 365)}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (widget.span.children.isNotEmpty)
                      Icon(
                        _open
                            ? Icons.expand_less_rounded
                            : Icons.expand_more_rounded,
                        size: 20,
                        color: scheme.onSurfaceVariant,
                      ),
                  ],
                ),
              ),
            ),
          ),
          if (_open) ...[
            if ((widget.note?.summary ?? '').isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 17, right: 4, bottom: 8),
                child: Text(
                  widget.note!.summary,
                  style: const TextStyle(fontSize: 12.5, height: 1.45),
                ),
              ),
            if (widget.span.children.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(left: 17, bottom: 12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHighest.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    for (final antar in widget.span.children)
                      _AntarRow(
                        maha: widget.span.lord,
                        antar: antar,
                        note: _antarNote(antar.lord),
                        isCurrent: antar.contains(now),
                      ),
                  ],
                ),
              ),
          ],
        ],
      ),
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
    final scheme = theme.colorScheme;
    final summary = widget.note?.summary ?? '';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: summary.isEmpty
                ? null
                : () => setState(() => _open = !_open),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${KTerms.displayName(context.l10n, widget.maha)} \u203a '
                    '${KTerms.displayName(context.l10n, widget.antar.lord)}',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: widget.isCurrent
                          ? FontWeight.w700
                          : FontWeight.w400,
                    ),
                  ),
                ),
                Text(
                  '${widget.antar.start.year} \u2013 ${widget.antar.end.year}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                if (summary.isNotEmpty)
                  Icon(
                    _open
                        ? Icons.expand_less_rounded
                        : Icons.expand_more_rounded,
                    size: 16,
                    color: scheme.onSurfaceVariant,
                  ),
              ],
            ),
          ),
          if (_open && summary.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 2),
              child: Text(
                summary,
                style: TextStyle(
                  fontSize: 11.5,
                  height: 1.4,
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
