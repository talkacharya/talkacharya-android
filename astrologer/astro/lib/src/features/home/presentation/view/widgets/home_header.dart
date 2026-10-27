import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/astro/onboarding_store.dart';
import '../../../../../core/availability/availability_coordinator.dart';
import '../../../../../core/di/service_locator.dart';
import '../../../../../core/l10n/l10n.dart';
import '../../../../../core/router/routes.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/haptic_service.dart';
import '../../../../auth/presentation/bloc/auth/auth_bloc.dart';
import '../../../../notifications/presentation/view/notification_bell.dart';
import '../../../../../shared/widgets/language_quick_button.dart';
import '../../../../../shared/widgets/settings_widgets.dart' show showToast;
import 'break_card.dart';
import 'dash_shared.dart';

import 'package:talkacharya_ui/talkacharya_ui.dart';

/// Home's plain app bar: who is signed in, their rating, language and the
/// notification bell.
AppBar homeAppBar(BuildContext context) {
  final l = context.l10n;
  final theme = Theme.of(context);
  final brand = context.brand;
  final user = context.select((AuthBloc b) => b.state.user);
  final store = getIt<OnboardingStore>();
  final ink = theme.colorScheme.onSurface;
  return AppBar(
    centerTitle: false,
    titleSpacing: DashGaps.side,
    title: Row(
      children: [
        _RingedAvatar(name: user?.shortName ?? '', url: user?.avatar),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l.dashGreeting,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: brand.inkMuted,
                ),
              ),
              Text(
                user?.shortName ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
    actions: [
      ListenableBuilder(
        listenable: store,
        builder: (context, _) {
          final p = store.profile;
          if (p == null || p.ratingCount == 0) return const SizedBox.shrink();
          return _RatingPill(p.ratingAvg);
        },
      ),
      LanguageQuickButton(color: ink),
      NotificationBell(color: ink),
      const SizedBox(width: 4),
    ],
  );
}

class _RingedAvatar extends StatelessWidget {
  const _RingedAvatar({required this.name, this.url});

  final String name;
  final String? url;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(colors: BrandColors.goldGradient),
      ),
      child: HueAvatar(
        name: name,
        url: url,
        hue: AstroPalette.career,
        size: 34,
      ),
    );
  }
}

class _RatingPill extends StatelessWidget {
  const _RatingPill(this.rating);

  final double rating;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return Container(
      margin: const EdgeInsets.only(right: 2),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: brand.tint,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rounded, size: 15, color: brand.gold),
          const SizedBox(width: 2),
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(
              color: brand.onTint,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

/// Headline presence line.
String presenceTitle(AppLocalizations l, AvailabilityCoordinator coord) {
  if (!coord.enabled) return l.presenceOffline;
  if (coord.onBreak) return l.presenceOnBreak;
  return switch (coord.presence) {
    'busy' => l.presenceBusy,
    'away' => l.presenceAway,
    'offline' => l.presenceOffline,
    _ => l.presenceOnline,
  };
}

/// The one control an astrologer touches most, first on the page: where they
/// stand, a plain on/off switch, their availability one tap away, and a break
/// while online.
class PresenceStrip extends StatelessWidget {
  const PresenceStrip({super.key});

  @override
  Widget build(BuildContext context) {
    final coord = getIt<AvailabilityCoordinator>();
    final store = getIt<OnboardingStore>();
    return ListenableBuilder(
      listenable: Listenable.merge([coord, store]),
      builder: (context, _) {
        final l = context.l10n;
        final brand = context.brand;
        final theme = Theme.of(context);
        final on = coord.enabled;
        final followers = store.profile?.followersCount ?? 0;
        final hint = coord.onBreak
            ? l.presenceOnBreakHint
            // Switch on, yet offline: every type waits for its next-online
            // time (Availability & hours), and comes back by itself.
            : on && coord.presence == 'offline'
            ? l.presenceAllWaitingHint
            : on
            ? l.presenceOnlineHint
            : followers > 0
            ? l.presenceFollowersHint(followers)
            : l.presenceOfflineHint;

        return Padding(
          padding: DashGaps.sidePad,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 260),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Radii.lg),
              color: on
                  ? Color.alphaBlend(
                      brand.online.withValues(alpha: 0.07),
                      theme.colorScheme.surface,
                    )
                  : theme.colorScheme.surface,
              border: Border.all(
                color: on
                    ? brand.online.withValues(alpha: 0.35)
                    : brand.hairline,
              ),
            ),
            child: Material(
              type: MaterialType.transparency,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 10, 8, 10),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 14,
                          child: on && !coord.onBreak
                              ? const LiveDot()
                              : Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: brand.inkMuted.withValues(
                                      alpha: 0.5,
                                    ),
                                  ),
                                ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                presenceTitle(l, coord),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                hint,
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
                        const SizedBox(width: 8),
                        Switch(
                          value: on,
                          activeTrackColor: brand.online,
                          onChanged: (value) async {
                            HapticService.medium();
                            // The switch is the server's; if it says no
                            // (training unfinished, no connection) it goes
                            // back and this says why.
                            final why = await coord.setEnabled(value);
                            if (why != null && context.mounted) {
                              showToast(context, why);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 1, color: brand.hairline),
                  InkWell(
                    onTap: () => context.go(Routes.profileWorkingHours),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(14, 10, 10, 10),
                      child: Row(
                        children: [
                          Icon(
                            Icons.schedule_rounded,
                            size: 18,
                            color: brand.inkMuted,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              l.profileHours,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
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
                  // Only while online (or on a break); draws its own divider.
                  const BreakCard(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
