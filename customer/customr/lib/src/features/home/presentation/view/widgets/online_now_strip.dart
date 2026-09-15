import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/l10n/l10n.dart';
import '../../../../../core/router/routes.dart';
import '../../../../../core/theme/astro_palette.dart';
import '../../../../../core/theme/brand_colors.dart';
import '../../../../../shared/widgets/pressable.dart';
import '../../../../astrologers/data/models/astrologer.dart';
import '../../cubit/home_cubit.dart';
import 'home_shared.dart';

/// "Online now" as a stories-style row: big faces in colour-coded gradient rings,
/// a live dot on each, one tap into the profile.
class OnlineNowStrip extends StatelessWidget {
  const OnlineNowStrip({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final online = context.select((HomeCubit c) => c.state.online);
    final people = online.value ?? const <Astrologer>[];
    final available = people.where((a) => a.isAvailable).toList();
    final show = available.isNotEmpty ? available : people;
    final loading = online.isLoading && show.isEmpty;
    if (!loading && show.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: available.isEmpty
              ? l.homeOnlineNow
              : '${l.homeOnlineNow} · ${available.length}',
          hue: AstroPalette.health,
          onSeeAll: () =>
              context.go(Routes.astrologersWith(sort: 'recommended')),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 98,
          child: loading
              ? const _StoriesSkeleton()
              : ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: HomeGaps.sidePad,
                  itemCount: show.take(12).length,
                  separatorBuilder: (_, _) => const SizedBox(width: 14),
                  itemBuilder: (context, i) => _Story(astrologer: show[i]),
                ),
        ),
      ],
    );
  }
}

class _Story extends StatelessWidget {
  const _Story({required this.astrologer});
  final Astrologer astrologer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = context.brand;
    final a = astrologer;
    final hue = HomeHues.forId(a.id);
    final surface = theme.colorScheme.surface;

    return Pressable(
      child: InkWell(
        onTap: () => context.go(Routes.astrologer(a.id)),
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          width: 68,
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: const EdgeInsets.all(2.5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: a.isAvailable
                          ? SweepGradient(
                              colors: [hue.start, hue.end, hue.start],
                            )
                          : null,
                      color: a.isAvailable ? null : brand.hairline,
                      boxShadow: a.isAvailable
                          ? [
                              BoxShadow(
                                color: hue.start.withValues(alpha: 0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: surface,
                      ),
                      child: HueAvatar(
                        name: a.name,
                        url: a.avatar,
                        hue: hue,
                        size: 56,
                      ),
                    ),
                  ),
                  if (a.isAvailable)
                    Positioned(
                      right: 3,
                      bottom: 3,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: brand.online,
                          shape: BoxShape.circle,
                          border: Border.all(color: surface, width: 2.5),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                a.name.split(' ').first,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StoriesSkeleton extends StatelessWidget {
  const _StoriesSkeleton();

  @override
  Widget build(BuildContext context) {
    return HomeShimmer(
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: HomeGaps.sidePad,
        itemCount: 6,
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemBuilder: (_, _) => const Column(
          children: [
            SkeletonBox(width: 66, height: 66, radius: 33),
            SizedBox(height: 8),
            SkeletonBox(width: 44, height: 9),
          ],
        ),
      ),
    );
  }
}
