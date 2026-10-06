import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:talkacharya_ui/talkacharya_ui.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/network/friendly_error.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/util/time_format.dart';
import '../../../../shared/widgets/settings_widgets.dart';
import '../../../consultations/data/consultation_api.dart';
import '../../../home/presentation/cubit/tool_counts_cubit.dart';
import '../../../consultations/data/models/consultation.dart';
import '../../../consultations/presentation/widgets/consultation_style.dart';
import '../../../performance/presentation/widgets/perf_format.dart';

/// Which calls the list shows.
enum CallFilter { all, completed, missed }

/// Calls that never became a conversation: rang out, declined, or dropped
/// before connecting.
const kMissedCallStatuses = {'expired', 'rejected', 'no_show', 'failed'};

/// [calls] narrowed to [filter]. Requests still ringing or in progress are
/// not history yet and are left out of every view.
List<Consultation> filterCalls(List<Consultation> calls, CallFilter filter) => [
  for (final c in calls)
    if (c.isTerminal &&
        switch (filter) {
          CallFilter.all => true,
          CallFilter.completed => c.isEnded,
          CallFilter.missed => kMissedCallStatuses.contains(c.status),
        })
      c,
];

/// Voice and video calls, newest first: what was earned on the ones that
/// happened, and which ones got away.
class CallHistoryPage extends StatefulWidget {
  const CallHistoryPage({super.key});

  @override
  State<CallHistoryPage> createState() => _CallHistoryPageState();
}

class _CallHistoryPageState extends State<CallHistoryPage> {
  List<Consultation>? _calls;
  String? _error;
  CallFilter _filter = CallFilter.all;

  @override
  void initState() {
    super.initState();
    _load();
    // Opening the list is what clears the missed-calls badge on Home.
    if (getIt.isRegistered<ToolCountsCubit>()) {
      getIt<ToolCountsCubit>().markCallsSeen();
    }
  }

  Future<void> _load() async {
    try {
      final calls = await getIt<ConsultationApi>().list(channel: 'voice,video');
      if (mounted) {
        setState(() {
          _calls = calls;
          _error = null;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _error = friendlyError(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final calls = _calls;

    final List<Widget> body;
    if (calls == null && _error != null) {
      body = [
        Padding(
          padding: const EdgeInsets.only(top: 48),
          child: ErrorView(message: _error!, onRetry: _load),
        ),
      ];
    } else if (calls == null) {
      body = const [_Skeleton()];
    } else {
      final history = filterCalls(calls, CallFilter.all);
      final shown = filterCalls(calls, _filter);
      body = [
        if (history.isNotEmpty) _Summary(calls: history),
        if (history.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 14, bottom: 6),
            child: Wrap(
              spacing: 8,
              children: [
                for (final f in CallFilter.values)
                  ChoiceChip(
                    label: Text(switch (f) {
                      CallFilter.all => l.callsFilterAll,
                      CallFilter.completed => l.callsFilterCompleted,
                      CallFilter.missed => l.callsFilterMissed,
                    }),
                    selected: f == _filter,
                    onSelected: (_) => setState(() => _filter = f),
                  ),
              ],
            ),
          ),
        if (shown.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: EmptyState(
              icon: Icons.call_rounded,
              hue: AstroPalette.health,
              title: history.isEmpty ? l.callsEmptyTitle : l.callsEmptyFilter,
              message: history.isEmpty ? l.callsEmptyBody : null,
            ),
          )
        else
          ..._grouped(context, shown),
      ];
    }

    return SubPageScaffold(
      title: l.callsTitle,
      onRefresh: _load,
      children: body,
    );
  }

  /// Rows under a heading per day.
  List<Widget> _grouped(BuildContext context, List<Consultation> calls) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final out = <Widget>[];
    DateTime? day;
    var card = <Widget>[];

    void flush() {
      if (card.isEmpty) return;
      out.add(_DayCard(rows: card));
      card = [];
    }

    for (final c in calls) {
      final at = (c.endedAt ?? c.requestedAt)?.toLocal();
      final d = at == null ? null : DateTime(at.year, at.month, at.day);
      if (d != day) {
        flush();
        day = d;
        if (at != null) {
          out.add(
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 14, 4, 8),
              child: Text(
                TimeFormat.day(l, at),
                style: theme.textTheme.labelLarge?.copyWith(
                  color: context.brand.inkMuted,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          );
        }
      }
      card.add(
        ConsultationTile(
          consultation: c,
          showStatus: true,
          onTap: () => context.push(Routes.requestDetail(c.id)),
        ),
      );
    }
    flush();
    return out;
  }
}

class _DayCard extends StatelessWidget {
  const _DayCard({required this.rows});

  final List<Widget> rows;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return Material(
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Radii.md),
        side: BorderSide(color: brand.hairline),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0) Divider(height: 1, indent: 76, color: brand.hairline),
            rows[i],
          ],
        ],
      ),
    );
  }
}

/// Completed calls, time on them, and how many got away.
class _Summary extends StatelessWidget {
  const _Summary({required this.calls});

  final List<Consultation> calls;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final done = calls.where((c) => c.isEnded).toList();
    final seconds = done.fold<int>(0, (s, c) => s + c.billedSeconds);
    final missed = calls
        .where((c) => kMissedCallStatuses.contains(c.status))
        .length;
    return Row(
      children: [
        _Stat(
          hue: AstroPalette.health,
          icon: Icons.call_rounded,
          value: '${done.length}',
          label: l.callsStatCompleted,
        ),
        const SizedBox(width: 10),
        _Stat(
          hue: AstroPalette.air,
          icon: Icons.timer_rounded,
          value: formatDuration(l, seconds ~/ 60 * 60),
          label: l.callsStatTalkTime,
        ),
        const SizedBox(width: 10),
        _Stat(
          hue: AstroPalette.fire,
          icon: Icons.phone_missed_rounded,
          value: '$missed',
          label: l.callsStatMissed,
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({
    required this.hue,
    required this.icon,
    required this.value,
    required this.label,
  });

  final AstroHue hue;
  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: HueTile(
        hue: hue,
        radius: Radii.md,
        padding: const EdgeInsets.fromLTRB(12, 12, 8, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 18, color: hue.end),
            const SizedBox(height: 8),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                value,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelSmall?.copyWith(
                color: context.brand.inkMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Skeleton extends StatelessWidget {
  const _Skeleton();

  @override
  Widget build(BuildContext context) {
    return const AppShimmer(
      child: Column(
        children: [
          SkeletonBox(height: 84, radius: 16),
          SizedBox(height: 16),
          SkeletonBox(height: 200, radius: 16),
        ],
      ),
    );
  }
}
