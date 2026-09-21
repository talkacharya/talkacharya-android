import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/astro/onboarding_store.dart';
import '../../../../../core/availability/availability_coordinator.dart';
import '../../../../../core/di/service_locator.dart';
import '../../../../../core/l10n/l10n.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/theme/astro_palette.dart';
import '../../../../../core/theme/brand_colors.dart';
import '../../../../../core/utils/haptic_service.dart';
import '../../../../../shared/widgets/cosmic.dart';
import '../../../../../shared/widgets/pressable.dart';
import '../../../../auth/presentation/bloc/auth/auth_bloc.dart';
import '../../../../notifications/presentation/view/notification_bell.dart';
import 'dash_shared.dart';

/// Deep-space hero at the top of the dashboard: greeting, avatar, rating,
/// notifications, and the online/offline presence panel — the one control an
/// astrologer touches most, so it gets the prime spot.
class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final theme = Theme.of(context);
    final l = context.l10n;
    final user = context.select((AuthBloc b) => b.state.user);
    final store = getIt<OnboardingStore>();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(28),
          ),
          boxShadow: brand.shadowCosmic,
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(28),
          ),
          child: Stack(
            children: [
              const Positioned.fill(child: CosmicBackdrop()),
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 8, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          _RingedAvatar(
                            name: user?.shortName ?? '',
                            url: user?.avatar,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l.dashGreeting,
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    color: brand.onCosmicMuted,
                                  ),
                                ),
                                Text(
                                  user?.shortName ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.headlineSmall
                                      ?.copyWith(color: brand.onCosmic),
                                ),
                              ],
                            ),
                          ),
                          ListenableBuilder(
                            listenable: store,
                            builder: (context, _) {
                              final p = store.profile;
                              if (p == null || p.ratingCount == 0) {
                                return const SizedBox.shrink();
                              }
                              return _RatingPill(p.ratingAvg);
                            },
                          ),
                          NotificationBell(color: brand.onCosmic),
                        ],
                      ),
                      const SizedBox(height: 18),
                      const Padding(
                        padding: EdgeInsets.only(right: 12),
                        child: _PresencePanel(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RingedAvatar extends StatelessWidget {
  const _RingedAvatar({required this.name, this.url});

  final String name;
  final String? url;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2.5),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(colors: BrandColors.goldGradient),
      ),
      child: HueAvatar(
        name: name,
        url: url,
        hue: AstroPalette.career,
        size: 50,
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rounded, size: 16, color: brand.gold),
          const SizedBox(width: 3),
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(
              color: brand.onCosmic,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

/// Frosted panel showing presence + the go-online / go-offline button.
class _PresencePanel extends StatelessWidget {
  const _PresencePanel();

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
        final title = !on
            ? l.presenceOffline
            : switch (coord.presence) {
                'busy' => l.presenceBusy,
                'away' => l.presenceAway,
                'offline' => l.presenceOffline,
                _ => l.presenceOnline,
              };
        final followers = store.profile?.followersCount ?? 0;
        final hint = on
            ? l.presenceOnlineHint
            : followers > 0
            ? l.presenceFollowersHint(followers)
            : l.presenceOfflineHint;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Radii.lg),
            color: on
                ? brand.online.withValues(alpha: 0.16)
                : Colors.white.withValues(alpha: 0.07),
            border: Border.all(
              color: on
                  ? brand.online.withValues(alpha: 0.45)
                  : Colors.white.withValues(alpha: 0.12),
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 14,
                child: on
                    ? const LiveDot()
                    : Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: brand.onCosmicMuted.withValues(alpha: 0.6),
                        ),
                      ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: brand.onCosmic,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      hint,
                      maxLines: 2,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: brand.onCosmicMuted,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              _PresenceButton(
                on: on,
                onTap: () {
                  HapticService.medium();
                  coord.setEnabled(!on);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Gold "Go online" when offline (the call to action); a quiet outlined
/// "Go offline" once online.
class _PresenceButton extends StatelessWidget {
  const _PresenceButton({required this.on, required this.onTap});

  final bool on;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final label = on ? l.presenceGoOffline : l.presenceGoOnline;
    return Pressable(
      haptic: HapticLevel.none,
      child: Semantics(
        button: true,
        toggled: on,
        label: label,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(999),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                gradient: on
                    ? null
                    : const LinearGradient(colors: BrandColors.goldGradient),
                border: on
                    ? Border.all(color: Colors.white.withValues(alpha: 0.35))
                    : null,
                boxShadow: on
                    ? null
                    : [
                        BoxShadow(
                          color: BrandColors.goldGradient.last.withValues(
                            alpha: 0.45,
                          ),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.power_settings_new_rounded,
                    size: 18,
                    color: on ? brand.onCosmic : const Color(0xFF3A1703),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: on ? brand.onCosmic : const Color(0xFF3A1703),
                    ),
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
