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
import '../../../../../core/utils/haptic_service.dart';
import '../../../../performance/data/performance_models.dart';
import '../../../../performance/presentation/cubit/performance_cubit.dart';
import '../../../../performance/presentation/widgets/perf_format.dart';
import '../../../data/dashboard_models.dart';
import 'dash_shared.dart';

/// Today in one card: what was earned (maskable), the day in one line, the
/// month's earning club in one line, and the payout balance (→ Earnings).
class TodayCard extends StatelessWidget {
  const TodayCard({this.payout, super.key});

  /// `null` while it loads.
  final PayoutSummary? payout;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final accent = Theme.of(context).colorScheme.primary;
    final slice = context.select((PerformanceCubit c) => c.state.performance);
    final perf = slice.value;

    return Padding(
      padding: DashGaps.sidePad,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              accent.withValues(alpha: 0.10),
              accent.withValues(alpha: 0.03),
            ],
          ),
          borderRadius: BorderRadius.circular(Radii.lg),
          border: Border.all(color: accent.withValues(alpha: 0.16)),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SectionSwitcher(
                child: perf != null
                    ? _Today(key: const ValueKey('data'), perf: perf)
                    : slice.isError
                    ? Padding(
                        key: const ValueKey('err'),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: SectionError(
                          onRetry: context
                              .read<PerformanceCubit>()
                              .loadPerformance,
                        ),
                      )
                    : const _Skeleton(key: ValueKey('sk')),
              ),
              if (perf?.club != null) ...[
                Divider(height: 1, color: brand.hairline),
                _ClubLine(club: perf!.club!),
              ],
              Divider(height: 1, color: brand.hairline),
              _PayoutRow(summary: payout),
            ],
          ),
        ),
      ),
    );
  }
}

class _Today extends StatelessWidget {
  const _Today({required this.perf, super.key});

  final Performance perf;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    final today = perf.today;
    final privacy = getIt<AmountPrivacy>();

    return ValueListenableBuilder<bool>(
      valueListenable: privacy,
      builder: (_, hidden, _) => Padding(
        padding: const EdgeInsets.fromLTRB(14, 10, 4, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    l.todayTitle,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: brand.inkMuted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: hidden ? l.todayShow : l.todayHide,
                  visualDensity: VisualDensity.compact,
                  iconSize: 20,
                  onPressed: () {
                    HapticService.selection();
                    privacy.toggle();
                  },
                  icon: Icon(
                    hidden
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded,
                    color: brand.inkMuted,
                  ),
                ),
              ],
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              layoutBuilder: (current, previous) => Stack(
                alignment: Alignment.centerLeft,
                children: [...previous, ?current],
              ),
              child: Text(
                privacy.mask(
                  Money.format(today.net.roundToDouble(), today.currency),
                ),
                key: ValueKey(hidden),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Text(
                l.homeTodayLine(
                  today.sessions,
                  l.perfMinutes(today.minutes),
                  formatDuration(l, today.onlineSeconds ~/ 60 * 60),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: brand.inkMuted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The month's earning club in a line: which one, a thin bar to the next,
/// and what today needs. Opens the performance dashboard.
class _ClubLine extends StatelessWidget {
  const _ClubLine({required this.club});

  final EarningClub club;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    final reduce = MediaQuery.maybeDisableAnimationsOf(context) ?? false;

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

    return InkWell(
      onTap: () => context.push(Routes.performance),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 10, 8, 10),
        child: Row(
          children: [
            Icon(Icons.workspace_premium_rounded, size: 20, color: brand.gold),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 5),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: club.progress),
                      duration: reduce
                          ? Duration.zero
                          : const Duration(milliseconds: 900),
                      curve: Curves.easeOutCubic,
                      builder: (_, t, _) => LinearProgressIndicator(
                        value: t.clamp(0.02, 1.0),
                        minHeight: 4,
                        color: brand.gold,
                        backgroundColor: brand.gold.withValues(alpha: 0.18),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    nudge,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: brand.inkMuted,
                      height: 1.25,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, size: 20, color: brand.inkMuted),
          ],
        ),
      ),
    );
  }
}

class _PayoutRow extends StatelessWidget {
  const _PayoutRow({required this.summary});

  final PayoutSummary? summary;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    final privacy = getIt<AmountPrivacy>();
    final s = summary;
    return InkWell(
      onTap: () => context.go(Routes.earnings),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 10, 8, 10),
        child: ListenableBuilder(
          listenable: privacy,
          builder: (context, _) => Row(
            children: [
              Icon(
                Icons.account_balance_wallet_rounded,
                size: 20,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l.dashAvailable,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: brand.inkMuted,
                      ),
                    ),
                    if (s != null && s.pending > 0)
                      Text(
                        l.dashPending(
                          privacy.mask(Money.format(s.pending, s.currency)),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: brand.inkMuted,
                        ),
                      ),
                  ],
                ),
              ),
              if (s == null)
                const AppShimmer(child: SkeletonBox(width: 70, height: 18))
              else
                Text(
                  privacy.mask(Money.format(s.available, s.currency)),
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: brand.inkMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Skeleton extends StatelessWidget {
  const _Skeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(14),
      child: AppShimmer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SkeletonBox(width: 110, height: 14),
            SizedBox(height: 10),
            SkeletonBox(width: 150, height: 30, radius: 8),
            SizedBox(height: 8),
            SkeletonBox(width: 220, height: 14),
          ],
        ),
      ),
    );
  }
}
