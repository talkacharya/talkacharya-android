import 'package:customr/src/core/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/router/routes.dart';
import '../../../../../core/theme/brand_colors.dart';
import '../../../../../shared/widgets/pressable.dart';
import '../../../data/models/live_stream_card.dart';
import '../../cubit/home_cubit.dart';
import 'home_shared.dart';

/// Astrologers broadcasting right now. Hidden entirely when nobody is live.
/// Redesigned with pulsing LIVE badge and gradient avatar ring.
class LiveNowRail extends StatelessWidget {
  const LiveNowRail({super.key});

  @override
  Widget build(BuildContext context) {
    final live = context.select((HomeCubit c) => c.state.live);

    return SectionSwitcher(
      child: live.when(
        idle: () => const _LiveSkeleton(),
        loading: () => const _LiveSkeleton(),
        error: (_) => const SizedBox.shrink(),
        data: (streams) {
          if (streams.isEmpty) return const SizedBox.shrink();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(
                title: context.l10n.homeLiveNowTitle,
                onSeeAll: () => context.go(Routes.live),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 120,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: HomeGaps.sidePad,
                  itemCount: streams.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 14),
                  itemBuilder: (context, i) =>
                      Pressable(child: _LiveTile(stream: streams[i])),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _LiveTile extends StatelessWidget {
  const _LiveTile({required this.stream});
  final LiveStreamCard stream;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = context.brand;
    return InkWell(
      onTap: () => context.go(Routes.liveRoom(stream.id)),
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        width: 70,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [brand.live, theme.colorScheme.primary, brand.live],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: brand.live.withValues(alpha: 0.3),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 27,
                backgroundColor: theme.colorScheme.surface,
                child: CircleAvatar(
                  radius: 24,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Text(
                    stream.hostName.isEmpty
                        ? '★'
                        : stream.hostName.characters.first.toUpperCase(),
                    style: TextStyle(
                      color: theme.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            _PulsingLiveBadge(viewerCount: stream.viewerCount),
            const SizedBox(height: 3),
            Text(
              stream.hostName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// LIVE badge with a subtle pulsing glow animation.
class _PulsingLiveBadge extends StatefulWidget {
  const _PulsingLiveBadge({required this.viewerCount});
  final int viewerCount;

  @override
  State<_PulsingLiveBadge> createState() => _PulsingLiveBadgeState();
}

class _PulsingLiveBadgeState extends State<_PulsingLiveBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = context.brand;
    final text = widget.viewerCount > 0
        ? '● ${_compact(widget.viewerCount)}'
        : '● LIVE';

    if (MediaQuery.maybeDisableAnimationsOf(context) ?? false) {
      return _badge(brand.live, text, theme);
    }

    return AnimatedBuilder(
      animation: _c,
      builder: (context, child) {
        final t = Curves.easeInOut.transform(_c.value);
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            boxShadow: [
              BoxShadow(
                color: brand.live.withValues(alpha: 0.15 + 0.2 * t),
                blurRadius: 6 + 4 * t,
                spreadRadius: 1,
              ),
            ],
          ),
          child: child,
        );
      },
      child: _badge(brand.live, text, theme),
    );
  }

  Widget _badge(Color bg, String text, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: theme.textTheme.labelSmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 9,
        ),
      ),
    );
  }

  static String _compact(int n) =>
      n >= 1000 ? '${(n / 1000).toStringAsFixed(1)}k' : '$n';
}

class _LiveSkeleton extends StatelessWidget {
  const _LiveSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: context.l10n.homeLiveNowTitle),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: HomeShimmer(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: HomeGaps.sidePad,
              itemCount: 4,
              separatorBuilder: (_, _) => const SizedBox(width: 14),
              itemBuilder: (_, _) => const Column(
                children: [
                  SkeletonBox(width: 60, height: 60, radius: 30),
                  SizedBox(height: 8),
                  SkeletonBox(width: 44, height: 10),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
