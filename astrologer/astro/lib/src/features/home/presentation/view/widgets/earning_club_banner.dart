import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:talkacharya_ui/talkacharya_ui.dart';

import '../../../../../core/di/service_locator.dart';
import '../../../../../core/l10n/l10n.dart';
import '../../../../../core/router/routes.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/util/amount_privacy.dart';
import '../../../../../core/util/money.dart';
import '../../../../performance/data/performance_models.dart';
import '../../../../performance/presentation/cubit/performance_cubit.dart';
import '../../../../performance/presentation/widgets/perf_format.dart';
import 'dash_shared.dart';

/// The month's earning club: which one this month's pace lands in, how far the
/// next one is, and what today needs to bring in to get there. Leaves itself
/// out until the scorecard has loaded, and where no clubs are configured for
/// the astrologer's currency.
class EarningClubBanner extends StatelessWidget {
  const EarningClubBanner({super.key});

  /// Whether the banner has anything to show for [state].
  static bool visibleFor(PerformanceState state) =>
      state.performance.value?.club != null;

  @override
  Widget build(BuildContext context) {
    final perf = context.select(
      (PerformanceCubit c) => c.state.performance.value,
    );
    final club = perf?.club;
    if (perf == null || club == null) return const SizedBox.shrink();

    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    final privacy = getIt<AmountPrivacy>();
    final tip = focusTip(l, perf.focus);

    final title = club.tier == null
        ? l.clubTitleNone
        : l.clubTitle(compactMoney(club.tier!, club.currency));
    final next = club.nextTier == null
        ? null
        : compactMoney(club.nextTier!, club.currency);
    final String nudge;
    if (next == null) {
      nudge = l.clubTop;
    } else if ((club.neededToday ?? 0) <= 0) {
      nudge = l.clubOnTrack(next);
    } else {
      nudge = l.clubNeedToday(
        Money.format(club.neededToday!, club.currency),
        next,
      );
    }

    return Padding(
      padding: DashGaps.sidePad,
      child: Pressable(
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Radii.lg),
            boxShadow: brand.shadowCosmic,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(Radii.lg),
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: () => context.push(Routes.performance),
                child: Stack(
                  children: [
                    const Positioned.fill(child: CosmicBackdrop()),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const _Medal(),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      title,
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                            color: brand.onCosmic,
                                            fontWeight: FontWeight.w800,
                                          ),
                                    ),
                                    const SizedBox(height: 2),
                                    ValueListenableBuilder<bool>(
                                      valueListenable: privacy,
                                      builder: (_, _, _) => Text(
                                        l.clubProjection(
                                          privacy.mask(
                                            Money.format(
                                              club.projected.roundToDouble(),
                                              club.currency,
                                            ),
                                          ),
                                        ),
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                              color: brand.onCosmicMuted,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.chevron_right_rounded,
                                color: brand.onCosmicMuted,
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          _ClubProgress(club: club, next: next),
                          const SizedBox(height: 12),
                          Text(
                            nudge,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: brand.onCosmic,
                              height: 1.3,
                            ),
                          ),
                          if (tip != null) ...[
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.fromLTRB(10, 8, 12, 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(Radii.sm),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.lightbulb_rounded,
                                    size: 16,
                                    color: brand.gold,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      tip,
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color: brand.onCosmicMuted,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Medal extends StatelessWidget {
  const _Medal();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: BrandColors.goldGradient,
        ),
        boxShadow: [
          BoxShadow(
            color: BrandColors.goldGradient.last.withValues(alpha: 0.5),
            blurRadius: 14,
          ),
        ],
      ),
      child: const Icon(
        Icons.workspace_premium_rounded,
        color: Color(0xFF3A1703),
      ),
    );
  }
}

/// Gold bar from the current club to the next one, labelled at both ends.
class _ClubProgress extends StatelessWidget {
  const _ClubProgress({required this.club, required this.next});

  final EarningClub club;
  final String? next;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final style = Theme.of(context).textTheme.labelSmall?.copyWith(
      color: brand.onCosmicMuted,
      fontWeight: FontWeight.w700,
    );
    final reduce = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: SizedBox(
            height: 8,
            child: Stack(
              children: [
                Positioned.fill(
                  child: ColoredBox(
                    color: Colors.white.withValues(alpha: 0.14),
                  ),
                ),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: club.progress),
                  duration: reduce
                      ? Duration.zero
                      : const Duration(milliseconds: 900),
                  curve: Curves.easeOutCubic,
                  builder: (_, t, _) => FractionallySizedBox(
                    widthFactor: t.clamp(0.02, 1.0),
                    child: const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: BrandColors.goldGradient,
                        ),
                      ),
                      child: SizedBox.expand(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Text(
              club.tier == null
                  ? compactMoney(0, club.currency)
                  : compactMoney(club.tier!, club.currency),
              style: style,
            ),
            const Spacer(),
            if (next != null) Text(next!, style: style),
          ],
        ),
      ],
    );
  }
}
