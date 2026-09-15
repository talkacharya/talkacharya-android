import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/fade_slide_in.dart';
import '../../../../shared/widgets/skeleton.dart';
import '../../../astrologers/presentation/view/widgets/astrologer_list_tile.dart';
import '../cubit/following_list_cubit.dart';

/// Profile → Following: astrologers the customer follows, newest first.
class FollowingPage extends StatefulWidget {
  const FollowingPage({super.key});

  @override
  State<FollowingPage> createState() => _FollowingPageState();
}

class _FollowingPageState extends State<FollowingPage> {
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      if (_scroll.position.extentAfter < 400) {
        context.read<FollowingListCubit>().loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final cubit = context.read<FollowingListCubit>();
    return Scaffold(
      backgroundColor: context.brand.canvas,
      appBar: AppBar(title: Text(l.followingTitle)),
      body: BlocBuilder<FollowingListCubit, FollowingListState>(
        builder: (context, state) {
          if (state.status == FollowingListStatus.loading &&
              state.items.isEmpty) {
            return const _Skeleton();
          }
          if (state.status == FollowingListStatus.error &&
              state.items.isEmpty) {
            return ErrorView(
              message: l.followingLoadError,
              onRetry: cubit.load,
            );
          }
          if (state.items.isEmpty) {
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: EmptyState(
                  icon: Icons.favorite_border_rounded,
                  title: l.followingEmptyTitle,
                  message: l.followingEmptyBody,
                  action: FilledButton(
                    onPressed: () => context.go(Routes.astrologers),
                    child: Text(l.followingExplore),
                  ),
                ),
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: cubit.load,
            child: ListView.separated(
              controller: _scroll,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
              itemCount: state.items.length + 1,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                if (i == 0) {
                  return Text(
                    l.followingHint,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: context.brand.inkMuted,
                      height: 1.4,
                    ),
                  );
                }
                final tile = AstrologerListTile(astrologer: state.items[i - 1]);
                return i <= 6
                    ? FadeSlideIn(
                        delay: Duration(milliseconds: 35 * i),
                        child: tile,
                      )
                    : tile;
              },
            ),
          );
        },
      ),
    );
  }
}

class _Skeleton extends StatelessWidget {
  const _Skeleton();

  @override
  Widget build(BuildContext context) => AppShimmer(
    child: ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
      itemCount: 5,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (_, _) => const SkeletonBox(height: 84, radius: 16),
    ),
  );
}
