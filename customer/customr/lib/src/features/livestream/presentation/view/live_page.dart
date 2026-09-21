import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/api_error_l10n.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/astro_palette.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/pressable.dart';
import '../../../../shared/widgets/skeleton.dart';
import '../../data/models/live_stream_summary.dart';
import '../cubit/live_list_cubit.dart';

/// Live tab — who is on air now, and what is scheduled next.
class LivePage extends StatefulWidget {
  const LivePage({super.key});

  @override
  State<LivePage> createState() => _LivePageState();
}

class _LivePageState extends State<LivePage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    context.read<LiveListCubit>().watch();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // no point polling a tab nobody is looking at
    final cubit = context.read<LiveListCubit>();
    state == AppLifecycleState.resumed ? cubit.watch() : cubit.unwatch();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      backgroundColor: context.brand.canvas,
      appBar: AppBar(title: Text(l.liveTabTitle)),
      body: BlocBuilder<LiveListCubit, LiveListState>(
        builder: (context, state) {
          final cubit = context.read<LiveListCubit>();
          if (state.isEmpty) {
            return switch (state.status) {
              LiveListStatus.loading => const _LiveSkeleton(),
              LiveListStatus.failed => ErrorView(
                message: localizedError(context, state.error),
                onRetry: cubit.load,
              ),
              LiveListStatus.ready => RefreshIndicator(
                onRefresh: cubit.load,
                child: ListView(
                  children: [
                    SizedBox(height: MediaQuery.sizeOf(context).height * 0.12),
                    EmptyState(
                      icon: Icons.live_tv_rounded,
                      title: l.liveEmptyTitle,
                      message: l.liveEmptyBody,
                    ),
                  ],
                ),
              ),
            };
          }
          return RefreshIndicator(
            onRefresh: cubit.load,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
              children: [
                if (state.live.isNotEmpty) ...[
                  _SectionHeader(
                    title: l.liveNowTitle,
                    trailing: l.liveWatchingCount(
                      state.live.fold(0, (sum, s) => sum + s.viewerCount),
                    ),
                  ),
                  for (final stream in state.live)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _LiveCard(stream: stream),
                    ),
                ],
                if (state.upcoming.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  _SectionHeader(title: l.liveUpcomingTitle),
                  for (final stream in state.upcoming)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _UpcomingTile(stream: stream),
                    ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.trailing});
  final String title;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 12, 2, 10),
      child: Row(
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const Spacer(),
          if (trailing != null)
            Text(
              trailing!,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }
}

/// A stream that is on air: big, tappable, with the live badge and head count.
class _LiveCard extends StatelessWidget {
  const _LiveCard({required this.stream});
  final LiveStreamSummary stream;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = context.l10n;
    return Pressable(
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AstroPalette.romance.first.withValues(alpha: 0.25),
                AstroPalette.romance.last.withValues(alpha: 0.18),
              ],
            ),
            border: Border.all(color: context.brand.hairline),
          ),
          child: InkWell(
            onTap: () => context.push(Routes.liveRoom(stream.id)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  _HostAvatar(name: stream.hostName, live: true),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const _LiveBadge(),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.visibility_rounded,
                              size: 14,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${stream.viewerCount}',
                              style: theme.textTheme.labelMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          stream.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          stream.hostName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  FilledButton(
                    onPressed: () => context.push(Routes.liveRoom(stream.id)),
                    child: Text(l.liveWatch),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _UpcomingTile extends StatelessWidget {
  const _UpcomingTile({required this.stream});
  final LiveStreamSummary stream;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final at = stream.scheduledAt;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: context.brand.hairline),
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          _HostAvatar(name: stream.hostName, live: false),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stream.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  at == null
                      ? stream.hostName
                      : '${stream.hostName} · ${_when(context, at)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.schedule_rounded,
            size: 18,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }

  String _when(BuildContext context, DateTime at) {
    final material = MaterialLocalizations.of(context);
    final now = DateTime.now();
    final time = material.formatTimeOfDay(TimeOfDay.fromDateTime(at));
    final sameDay =
        at.year == now.year && at.month == now.month && at.day == now.day;
    return sameDay ? time : '${material.formatShortDate(at)}, $time';
  }
}

class _HostAvatar extends StatelessWidget {
  const _HostAvatar({required this.name, required this.live});
  final String name;
  final bool live;

  @override
  Widget build(BuildContext context) {
    final initial = name.isEmpty ? '?' : name.characters.first.toUpperCase();
    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(colors: AstroPalette.romance),
        border: live ? Border.all(color: context.brand.live, width: 2) : null,
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 20,
        ),
      ),
    );
  }
}

class _LiveBadge extends StatelessWidget {
  const _LiveBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: context.brand.live,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        context.l10n.liveBadge.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

class _LiveSkeleton extends StatelessWidget {
  const _LiveSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
      children: [
        for (var i = 0; i < 4; i++)
          const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: SkeletonBox(height: 86, radius: 20),
          ),
      ],
    );
  }
}
