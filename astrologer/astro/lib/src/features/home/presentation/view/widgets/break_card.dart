import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talkacharya_ui/talkacharya_ui.dart';

import '../../../../../core/availability/availability_coordinator.dart';
import '../../../../../core/di/service_locator.dart';
import '../../../../../core/l10n/l10n.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../shared/widgets/settings_widgets.dart';
import '../../../../performance/data/performance_models.dart';
import '../../../../performance/presentation/cubit/performance_cubit.dart';
import 'dash_shared.dart';

/// Step away for a few minutes without going offline for the day. Offline,
/// there is nothing to take a break from, so the card leaves itself out; on a
/// break it turns into a countdown with a way back.
class BreakCard extends StatelessWidget {
  const BreakCard({super.key});

  @override
  Widget build(BuildContext context) {
    final coord = getIt<AvailabilityCoordinator>();
    final status = context.select((PerformanceCubit c) => c.state.breaks.value);
    final busy = context.select((PerformanceCubit c) => c.state.breakBusy);
    return ListenableBuilder(
      listenable: coord,
      builder: (context, _) {
        if (status == null || (!coord.enabled && !status.onBreak)) {
          return const SizedBox.shrink();
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: DashGaps.section),
          child: Padding(
            padding: DashGaps.sidePad,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 260),
              child: status.onBreak
                  ? _OnBreak(
                      key: const ValueKey('on'),
                      status: status,
                      busy: busy,
                    )
                  : _Offer(
                      key: const ValueKey('off'),
                      status: status,
                      busy: busy,
                    ),
            ),
          ),
        );
      },
    );
  }
}

class _Offer extends StatelessWidget {
  const _Offer({required this.status, required this.busy, super.key});

  final BreakStatus status;
  final bool busy;

  Future<void> _pick(BuildContext context) async {
    final l = context.l10n;
    final cubit = context.read<PerformanceCubit>();
    final minutes = await showAppSheet<int>(
      context: context,
      title: l.breakSheetTitle,
      builder: (_) => _DurationSheet(durations: status.durations),
    );
    if (minutes == null) return;
    final error = await cubit.startBreak(minutes);
    if (error != null && context.mounted) showToast(context, error);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    final none = status.left <= 0;
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(Radii.lg),
        border: Border.all(color: brand.hairline),
      ),
      child: Row(
        children: [
          const HueIcon(hue: AstroPalette.money, icon: Icons.coffee_rounded),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.breakTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  none ? l.breakNoneLeft : l.breakLeft(status.left),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: brand.inkMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          FilledButton.tonal(
            style: FilledButton.styleFrom(
              minimumSize: const Size(0, 44),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            onPressed: none || busy ? null : () => _pick(context),
            child: Text(l.breakButton),
          ),
        ],
      ),
    );
  }
}

class _DurationSheet extends StatefulWidget {
  const _DurationSheet({required this.durations});

  final List<int> durations;

  @override
  State<_DurationSheet> createState() => _DurationSheetState();
}

class _DurationSheetState extends State<_DurationSheet> {
  late int? _minutes = widget.durations.isEmpty
      ? null
      : widget.durations[widget.durations.length > 1 ? 1 : 0];

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l.breakInfo,
          style: theme.textTheme.bodyMedium?.copyWith(color: brand.inkMuted),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final d in widget.durations)
              ChoiceChip(
                label: Text(l.breakMinutes(d)),
                selected: d == _minutes,
                onSelected: (_) => setState(() => _minutes = d),
              ),
          ],
        ),
        const SizedBox(height: 20),
        FilledButton(
          onPressed: _minutes == null
              ? null
              : () => Navigator.of(context).pop(_minutes),
          child: Text(l.breakStart),
        ),
      ],
    );
  }
}

/// The running break: a ring that empties as the time runs out.
class _OnBreak extends StatefulWidget {
  const _OnBreak({required this.status, required this.busy, super.key});

  final BreakStatus status;
  final bool busy;

  @override
  State<_OnBreak> createState() => _OnBreakState();
}

class _OnBreakState extends State<_OnBreak> {
  Timer? _tick;

  @override
  void initState() {
    super.initState();
    _tick = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tick?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    const hue = AstroPalette.money;
    final endsAt = widget.status.endsAt!;
    final startedAt = widget.status.startedAt ?? endsAt;
    final left = endsAt.difference(DateTime.now());
    final total = endsAt.difference(startedAt).inSeconds;
    final secs = left.isNegative ? 0 : left.inSeconds;
    final clock =
        '${(secs ~/ 60).toString().padLeft(2, '0')}:'
        '${(secs % 60).toString().padLeft(2, '0')}';

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
      decoration: BoxDecoration(
        color: hue.tint(0.12),
        borderRadius: BorderRadius.circular(Radii.lg),
        border: Border.all(color: hue.tint(0.4)),
      ),
      child: Row(
        children: [
          SizedBox.square(
            dimension: 44,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: total <= 0 ? 0 : (secs / total).clamp(0.0, 1.0),
                  strokeWidth: 4,
                  strokeCap: StrokeCap.round,
                  color: hue.end,
                  backgroundColor: hue.tint(0.25),
                ),
                Icon(Icons.coffee_rounded, size: 20, color: hue.end),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.breakOnTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  l.breakBackIn(clock),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: context.brand.inkMuted,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          FilledButton(
            style: FilledButton.styleFrom(
              minimumSize: const Size(0, 44),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            onPressed: widget.busy
                ? null
                : () async {
                    final error = await context
                        .read<PerformanceCubit>()
                        .endBreak();
                    if (error != null && context.mounted) {
                      showToast(context, error);
                    }
                  },
            child: Text(l.breakResume),
          ),
        ],
      ),
    );
  }
}
