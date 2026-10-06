import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:talkacharya_ui/talkacharya_ui.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/util/time_format.dart';
import '../../../../shared/widgets/settings_widgets.dart';
import '../../data/performance_models.dart';
import '../cubit/performance_cubit.dart';

/// Returning customers who have gone quiet, longest relationships first. Each
/// opens their thread — the history is the best reminder of where things were.
class WinBackPage extends StatelessWidget {
  const WinBackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PerformanceCubit>()..loadLapsed(),
      child: const _WinBackView(),
    );
  }
}

class _WinBackView extends StatelessWidget {
  const _WinBackView();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final cubit = context.read<PerformanceCubit>();
    final slice = context.select((PerformanceCubit c) => c.state.lapsed);

    return SubPageScaffold(
      title: l.winBackTitle,
      subtitle: slice.value == null
          ? null
          : l.winBackSubtitle(slice.value!.afterDays),
      onRefresh: cubit.loadLapsed,
      children: slice.when(
        loading: () => const [_ListSkeleton()],
        error: (message) => [
          Padding(
            padding: const EdgeInsets.only(top: 48),
            child: ErrorView(message: message, onRetry: cubit.loadLapsed),
          ),
        ],
        data: (data) => data.customers.isEmpty
            ? [
                Padding(
                  padding: const EdgeInsets.only(top: 48),
                  child: EmptyState(
                    icon: Icons.favorite_rounded,
                    hue: AstroPalette.love,
                    title: l.winBackEmptyTitle,
                    message: l.winBackEmptyBody,
                  ),
                ),
              ]
            : FadeSlideIn.list([
                for (final c in data.customers) _CustomerTile(customer: c),
              ], step: const Duration(milliseconds: 40)),
      ),
    );
  }
}

class _CustomerTile extends StatelessWidget {
  const _CustomerTile({required this.customer});

  final LapsedCustomer customer;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    final c = customer;
    final name = c.name.trim().isEmpty ? l.winBackCustomer : c.name;
    final thread = c.conversationId;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Pressable(
        child: Material(
          color: theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Radii.md),
            side: BorderSide(color: brand.hairline),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: thread == null
                ? null
                : () => context.push(Routes.chatRoom(thread)),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 8, 12),
              child: Row(
                children: [
                  HueAvatar(
                    name: name,
                    hue: AstroPalette.forId(name),
                    size: 46,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          l.winBackTile(c.sessions, c.minutes),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: brand.inkMuted,
                          ),
                        ),
                        Text(
                          l.winBackLast(TimeFormat.relative(l, c.lastAt)),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: brand.inkMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (thread != null)
                    Icon(Icons.chevron_right_rounded, color: brand.inkMuted),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ListSkeleton extends StatelessWidget {
  const _ListSkeleton();

  @override
  Widget build(BuildContext context) {
    return const AppShimmer(
      child: Column(
        children: [
          SkeletonBox(height: 72, radius: 16),
          SizedBox(height: 10),
          SkeletonBox(height: 72, radius: 16),
          SizedBox(height: 10),
          SkeletonBox(height: 72, radius: 16),
        ],
      ),
    );
  }
}
