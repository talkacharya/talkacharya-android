import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/astro/onboarding_store.dart';
import '../../../../../core/di/service_locator.dart';
import '../../../../../core/l10n/l10n.dart';
import '../../../../../core/theme/astro_palette.dart';
import '../../../../../core/theme/brand_colors.dart';
import '../../../../../shared/widgets/skeleton.dart';
import '../../cubit/dashboard_cubit.dart';
import 'dash_shared.dart';

/// Six hue-coded KPI tiles for the selected window (period is shared with the
/// earnings card).
class PerformanceGrid extends StatelessWidget {
  const PerformanceGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final state = context.watch<DashboardCubit>().state;
    final s = state.stats.value;
    final store = getIt<OnboardingStore>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(
          title: l.dashPerformance,
          subtitle: l.dashLastDays(state.period),
          hue: AstroPalette.health,
        ),
        const SizedBox(height: 12),
        Padding(
          padding: DashGaps.sidePad,
          child: ListenableBuilder(
            listenable: store,
            builder: (context, _) {
              final tiles = <_Kpi>[
                _Kpi(
                  hue: AstroPalette.career,
                  icon: Icons.forum_rounded,
                  label: l.dashStatSessions,
                  value: s == null ? null : '${s.completed}',
                  sub: s == null ? '' : l.dashStatSessionsSub(s.requested),
                ),
                _Kpi(
                  hue: AstroPalette.air,
                  icon: Icons.timer_rounded,
                  label: l.dashStatMinutes,
                  value: s?.minutes.round().toString(),
                  sub: l.dashStatMinutesSub,
                ),
                _Kpi(
                  hue: AstroPalette.health,
                  icon: Icons.task_alt_rounded,
                  label: l.dashStatAcceptance,
                  value: s == null ? null : _pct(s.acceptanceRate),
                  sub: l.dashStatAcceptanceSub,
                ),
                _Kpi(
                  hue: AstroPalette.money,
                  icon: Icons.star_rounded,
                  label: l.dashStatRating,
                  value: s == null
                      ? null
                      : (s.ratingAvg > 0
                            ? s.ratingAvg.toStringAsFixed(1)
                            : '—'),
                  sub: s == null ? '' : l.dashStatRatingSub(s.ratingCount),
                ),
                _Kpi(
                  hue: AstroPalette.fire,
                  icon: Icons.replay_rounded,
                  label: l.dashStatRepeat,
                  value: s == null ? null : _pct(s.repeatClientRate),
                  sub: l.dashStatRepeatSub,
                ),
                _Kpi(
                  hue: AstroPalette.love,
                  icon: Icons.favorite_rounded,
                  label: l.dashStatFollowers,
                  value: '${store.profile?.followersCount ?? 0}',
                  sub: l.dashStatFollowersSub,
                ),
              ];
              return LayoutBuilder(
                builder: (context, c) {
                  // 2 columns on phones, 3 once there's room.
                  final cols = c.maxWidth >= 520 ? 3 : 2;
                  const gap = 12.0;
                  final w = (c.maxWidth - gap * (cols - 1)) / cols;
                  return Wrap(
                    spacing: gap,
                    runSpacing: gap,
                    children: [
                      for (final t in tiles) SizedBox(width: w, child: t),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  static String _pct(double v) => '${v.round()}%';
}

class _Kpi extends StatelessWidget {
  const _Kpi({
    required this.hue,
    required this.icon,
    required this.label,
    required this.value,
    required this.sub,
  });

  final AstroHue hue;
  final IconData icon;
  final String label;

  /// `null` while loading.
  final String? value;
  final String sub;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = context.brand;
    return HueTile(
      hue: hue,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              HueIcon(hue: hue, icon: icon, size: 32, iconSize: 17),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 32,
            child: SectionSwitcher(
              child: value == null
                  ? const Align(
                      key: ValueKey('sk'),
                      alignment: Alignment.centerLeft,
                      child: AppShimmer(
                        child: SkeletonBox(width: 56, height: 24, radius: 6),
                      ),
                    )
                  : Text(
                      value!,
                      key: ValueKey(value),
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: hue.end,
                      ),
                    ),
            ),
          ),
          Text(
            sub,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelSmall?.copyWith(color: brand.inkMuted),
          ),
        ],
      ),
    );
  }
}
