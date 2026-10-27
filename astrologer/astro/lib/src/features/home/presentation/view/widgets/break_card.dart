import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talkacharya_ui/talkacharya_ui.dart';

import '../../../../../core/availability/availability_coordinator.dart';
import '../../../../../core/di/service_locator.dart';
import '../../../../../core/l10n/l10n.dart';
import '../../../../../shared/widgets/settings_widgets.dart';
import '../../../../performance/data/performance_models.dart';
import '../../../../performance/presentation/cubit/performance_cubit.dart';

/// Step away for a few minutes without going offline for the day — a row at
/// the foot of the presence strip. Offline, there is nothing to take a break
/// from, so it leaves itself out; on a break it turns into a countdown with a
/// way back.
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
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Divider(height: 1, color: context.brand.hairline),
            AnimatedSwitcher(
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
          ],
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 2, 6, 2),
      child: Row(
        children: [
          Icon(Icons.coffee_rounded, size: 18, color: AstroPalette.money.end),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              none ? l.breakNoneLeft : l.breakLeft(status.left),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(color: brand.inkMuted),
            ),
          ),
          TextButton(
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
      color: hue.tint(0.10),
      padding: const EdgeInsets.fromLTRB(14, 8, 10, 8),
      child: Row(
        children: [
          SizedBox.square(
            dimension: 30,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: total <= 0 ? 0 : (secs / total).clamp(0.0, 1.0),
                  strokeWidth: 3,
                  strokeCap: StrokeCap.round,
                  color: hue.end,
                  backgroundColor: hue.tint(0.25),
                ),
                Icon(Icons.coffee_rounded, size: 14, color: hue.end),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.breakOnTitle,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w800,
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
              minimumSize: const Size(0, 36),
              padding: const EdgeInsets.symmetric(horizontal: 14),
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
