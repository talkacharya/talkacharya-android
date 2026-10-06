import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/astro/onboarding_store.dart';
import '../../../../../core/availability/availability_coordinator.dart';
import '../../../../../core/di/service_locator.dart';
import '../../../../../core/l10n/l10n.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/haptic_service.dart';
import '../../../../auth/presentation/bloc/auth/auth_bloc.dart';
import '../../../../notifications/presentation/view/notification_bell.dart';
import 'dash_shared.dart';

import 'package:talkacharya_ui/talkacharya_ui.dart';

/// Deep-space hero at the top of the dashboard: greeting, avatar, rating,
/// notifications, and the online/offline presence panel — the one control an
/// astrologer touches most, so it gets the prime spot. Pinned: it collapses
/// into a compact bar (avatar, name, presence, bell) as the page scrolls.
///
/// The expanded height isn't hard-coded: the expanded layout reports its real
/// height after layout ([onBodyMeasured]) and the owner feeds it back in as
/// [bodyHeight], so fonts, locale, width and text scale all fit.
class DashboardHeaderDelegate extends SliverPersistentHeaderDelegate {
  DashboardHeaderDelegate({
    required this.topPad,
    required this.bodyHeight,
    required this.onBodyMeasured,
  });

  final double topPad;

  /// Expanded content height below [topPad], as last measured.
  final double bodyHeight;
  final ValueChanged<double> onBodyMeasured;

  /// First-frame estimate, replaced by the measured height right after.
  static const initialBodyHeight = 190.0;

  static const _bar = 60.0; // collapsed content height

  @override
  double get minExtent => topPad + _bar;

  @override
  double get maxExtent => topPad + (bodyHeight > _bar ? bodyHeight : _bar);

  @override
  bool shouldRebuild(covariant DashboardHeaderDelegate old) =>
      old.topPad != topPad || old.bodyHeight != bodyHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlaps) {
    final t = (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);
    return _HeaderBody(
      t: t,
      topPad: topPad,
      height: maxExtent,
      onBodyMeasured: onBodyMeasured,
    );
  }
}

class _HeaderBody extends StatelessWidget {
  const _HeaderBody({
    required this.t,
    required this.topPad,
    required this.height,
    required this.onBodyMeasured,
  });

  final double t; // 0 = expanded, 1 = collapsed
  final double topPad;
  final double height; // fully expanded height, including [topPad]
  final ValueChanged<double> onBodyMeasured;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final theme = Theme.of(context);
    final l = context.l10n;
    final user = context.select((AuthBloc b) => b.state.user);
    final store = getIt<OnboardingStore>();
    final coord = getIt<AvailabilityCoordinator>();

    final expandedOpacity = (1 - t * 1.8).clamp(0.0, 1.0);
    final collapsedOpacity = ((t - 0.55) / 0.45).clamp(0.0, 1.0);
    final radius = Radius.circular(28 - 8 * t);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(bottom: radius),
          boxShadow: brand.shadowCosmic,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(bottom: radius),
          child: Stack(
            children: [
              const Positioned.fill(child: CosmicBackdrop()),

              // Expanded content: fades out and drifts up. Laid out at full
              // height and clipped as the header shrinks, so it never reflows.
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: height,
                child: IgnorePointer(
                  ignoring: t > 0.5,
                  child: Opacity(
                    opacity: expandedOpacity,
                    child: Transform.translate(
                      offset: Offset(0, -24 * t),
                      child: OverflowBox(
                        alignment: Alignment.topCenter,
                        minHeight: 0,
                        maxHeight: double.infinity,
                        child: _ReportHeight(
                          onChanged: (h) => onBodyMeasured(h - topPad),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                              20,
                              topPad + 12,
                              8,
                              20,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            l.dashGreeting,
                                            style: theme.textTheme.labelLarge
                                                ?.copyWith(
                                                  color: brand.onCosmicMuted,
                                                ),
                                          ),
                                          Text(
                                            user?.shortName ?? '',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: theme.textTheme.headlineSmall
                                                ?.copyWith(
                                                  color: brand.onCosmic,
                                                ),
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
                      ),
                    ),
                  ),
                ),
              ),

              // Collapsed bar: fades in near the end of the collapse.
              Positioned(
                top: topPad,
                left: 0,
                right: 0,
                height: DashboardHeaderDelegate._bar,
                child: IgnorePointer(
                  ignoring: t < 0.5,
                  child: Opacity(
                    opacity: collapsedOpacity,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 8, 0),
                      child: Row(
                        children: [
                          _RingedAvatar(
                            name: user?.shortName ?? '',
                            url: user?.avatar,
                            size: 34,
                          ),
                          const SizedBox(width: 10),
                          // The bar is a fixed 60 tall: at very large text
                          // sizes the name/status shrink to fit, not overflow.
                          Expanded(
                            child: LayoutBuilder(
                              builder: (context, box) => FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: SizedBox(
                                  width: box.maxWidth,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        user?.shortName ?? '',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                              color: brand.onCosmic,
                                              fontWeight: FontWeight.w800,
                                            ),
                                      ),
                                      ListenableBuilder(
                                        listenable: coord,
                                        builder: (context, _) {
                                          return Row(
                                            children: [
                                              Container(
                                                width: 7,
                                                height: 7,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: coord.enabled
                                                      ? brand.online
                                                      : brand.onCosmicMuted,
                                                ),
                                              ),
                                              const SizedBox(width: 6),
                                              Flexible(
                                                child: Text(
                                                  _presenceTitle(l, coord),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: theme
                                                      .textTheme
                                                      .bodySmall
                                                      ?.copyWith(
                                                        color:
                                                            brand.onCosmicMuted,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          NotificationBell(color: brand.onCosmic),
                        ],
                      ),
                    ),
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

/// Reports its child's laid-out height whenever it changes, after the frame
/// (so the listener can safely setState).
class _ReportHeight extends SingleChildRenderObjectWidget {
  const _ReportHeight({required this.onChanged, required super.child});

  final ValueChanged<double> onChanged;

  @override
  _RenderReportHeight createRenderObject(BuildContext context) =>
      _RenderReportHeight(onChanged);

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderReportHeight renderObject,
  ) => renderObject.onChanged = onChanged;
}

class _RenderReportHeight extends RenderProxyBox {
  _RenderReportHeight(this.onChanged);

  ValueChanged<double> onChanged;
  double? _last;

  @override
  void performLayout() {
    super.performLayout();
    final h = size.height;
    if (h == _last) return;
    _last = h;
    WidgetsBinding.instance.addPostFrameCallback((_) => onChanged(h));
  }
}

class _RingedAvatar extends StatelessWidget {
  const _RingedAvatar({required this.name, this.url, this.size = 50});

  final String name;
  final String? url;
  final double size;

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
        size: size,
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

/// Headline presence line, shared by the panel and the collapsed bar.
String _presenceTitle(AppLocalizations l, AvailabilityCoordinator coord) {
  if (!coord.enabled) return l.presenceOffline;
  if (coord.onBreak) return l.presenceOnBreak;
  return switch (coord.presence) {
    'busy' => l.presenceBusy,
    'away' => l.presenceAway,
    'offline' => l.presenceOffline,
    _ => l.presenceOnline,
  };
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
        final title = _presenceTitle(l, coord);
        final followers = store.profile?.followersCount ?? 0;
        final hint = coord.onBreak
            ? l.presenceOnBreakHint
            : on
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
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
              Flexible(
                child: _PresenceButton(
                  on: on,
                  onTap: () {
                    HapticService.medium();
                    coord.setEnabled(!on);
                  },
                ),
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
              // Shrinks rather than overflows at very large text sizes.
              child: FittedBox(
                fit: BoxFit.scaleDown,
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
      ),
    );
  }
}
