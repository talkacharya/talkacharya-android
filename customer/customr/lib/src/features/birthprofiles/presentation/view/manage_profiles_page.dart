import '../../../../core/l10n/l10n.dart';
import '../../../consultations/presentation/view/widgets/share_with_astrologer.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/routes.dart';
import '../../../../core/theme/astro_palette.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../../shared/widgets/app_bottom_sheet.dart';
import '../../../../shared/widgets/cosmic.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/fade_slide_in.dart';
import '../../../../shared/widgets/hue_widgets.dart';
import '../bloc/birth_profiles_cubit.dart';
import '../../data/models/birth_profile.dart';
import 'widgets/profile_card.dart';
import '../../../../core/utils/haptic_service.dart';

class ManageProfilesPage extends StatefulWidget {
  const ManageProfilesPage({super.key});

  @override
  State<ManageProfilesPage> createState() => _ManageProfilesPageState();
}

class _ManageProfilesPageState extends State<ManageProfilesPage> {
  /// Height of your persistent floating bottom nav pill + the gap it keeps
  /// from the screen edge. Replace this with whatever constant your nav
  /// widget already exposes (e.g. `AppNav.height`) instead of hardcoding —
  /// I don't have that file so I can't read the real number.
  static const double _bottomNavClearance = 84;

  @override
  void initState() {
    super.initState();
    context.read<BirthProfilesCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final bottomSafeArea = MediaQuery.paddingOf(context).bottom;
    final fabClearance = _bottomNavClearance + bottomSafeArea;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        extendBody: true,
        backgroundColor: brand.canvas,
        body: BlocBuilder<BirthProfilesCubit, BirthProfilesState>(
          builder: (context, state) {
            final cubit = context.read<BirthProfilesCubit>();
            final slivers = <Widget>[
              _Header(
                count: state.profiles.length,
                onAdd: () => context.push(Routes.birthProfileNew),
              ),
            ];

            if (state.status == BpStatus.loading && state.profiles.isEmpty) {
              slivers.add(
                _ProfilesSkeleton(brand: brand, bottomPadding: fabClearance),
              );
            } else if (state.status == BpStatus.error &&
                state.profiles.isEmpty) {
              slivers.add(
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: ErrorView(
                    message: state.error ?? 'Could not load your profiles.',
                    onRetry: () => cubit.load(force: true),
                  ),
                ),
              );
            } else if (state.profiles.isEmpty) {
              slivers.add(
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: _EmptyState(),
                ),
              );
            } else {
              slivers.add(
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(16, 14, 16, fabClearance + 40),
                  sliver: SliverList.list(
                    children: [
                      const _SwipeHintBanner(),
                      for (
                        var index = 0;
                        index < state.profiles.length;
                        index++
                      )
                        _item(context, state, index),
                    ],
                  ),
                ),
              );
            }

            return RefreshIndicator(
              color: AstroPalette.romance[1],
              edgeOffset: 120,
              onRefresh: () => cubit.load(force: true),
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: slivers,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _item(BuildContext context, BirthProfilesState state, int index) {
    final brand = context.brand;
    final p = state.profiles[index];
    final isActive = p.id == state.activeProfileId;
    final card = ProfileCard(
      profile: p,
      selected: isActive,
      onTap: () => context.push('/kundali/${p.id}'),
      onLongPress: () => _showContextSheet(context, p, isActive),
    );

    final dismissible = Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Dismissible(
        key: ValueKey(p.id),
        confirmDismiss: (dir) => _onDismiss(context, p, dir),
        background: _SwipeBackground(
          alignment: Alignment.centerLeft,
          color: brand.online,
          icon: Icons.check_circle_rounded,
          label: 'Set Active',
        ),
        secondaryBackground: _SwipeBackground(
          alignment: Alignment.centerRight,
          color: brand.live,
          icon: Icons.delete_rounded,
          label: 'Delete',
        ),
        child: card,
      ),
    );

    return index < 6
        ? FadeSlideIn(
            key: ValueKey('fade-${p.id}'),
            delay: Duration(milliseconds: 50 * index),
            child: dismissible,
          )
        : dismissible;
  }

  // --- Swipe dismiss handler ---

  Future<bool> _onDismiss(
    BuildContext context,
    BirthProfile p,
    DismissDirection direction,
  ) async {
    final cubit = context.read<BirthProfilesCubit>();

    if (direction == DismissDirection.startToEnd) {
      HapticService.light();
      await cubit.select(p.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${p.displayName} is now active'),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
      }
      return false;
    }

    HapticService.medium();
    final ok = await _confirmDelete(context, p);
    if (ok) {
      await cubit.remove(p.id);
    }
    return false;
  }

  // --- Long-press context sheet ---

  void _showContextSheet(BuildContext context, BirthProfile p, bool isActive) {
    HapticService.medium();
    final cubit = context.read<BirthProfilesCubit>();
    final brand = context.brand;

    showAppSheet(
      context: context,
      title: p.displayName,
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SheetAction(
            icon: Icons.auto_awesome_rounded,
            label: 'View kundali',
            color: brand.glowAccent,
            onTap: () {
              Navigator.pop(ctx);
              unawaited(context.push('/kundali/${p.id}'));
            },
          ),
          _SheetAction(
            icon: Icons.ios_share_rounded,
            label: context.l10n.shareWithAstrologer,
            color: brand.glowAccent,
            onTap: () {
              Navigator.pop(ctx);
              unawaited(
                shareWithAstrologer(
                  context,
                  birthProfileId: p.id,
                  label: p.displayName,
                ),
              );
            },
          ),
          _SheetAction(
            icon: Icons.edit_outlined,
            label: 'Edit details',
            color: brand.glowAccent,
            onTap: () {
              Navigator.pop(ctx);
              unawaited(context.push(Routes.birthProfileEdit(p.id)));
            },
          ),
          if (!isActive)
            _SheetAction(
              icon: Icons.check_circle_outline_rounded,
              label: 'Use this profile',
              color: brand.online,
              onTap: () async {
                Navigator.pop(ctx);
                await cubit.select(p.id);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${p.displayName} is now active'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
            ),
          if (!p.isPrimary)
            _SheetAction(
              icon: Icons.star_rounded,
              label: 'Set as default',
              color: brand.gold,
              onTap: () async {
                Navigator.pop(ctx);
                await cubit.makeDefault(p.id);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${p.displayName} set as default'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
            ),
          const Divider(height: 1),
          _SheetAction(
            icon: Icons.delete_outline_rounded,
            label: 'Delete',
            color: brand.live,
            onTap: () async {
              Navigator.pop(ctx);
              final ok = await _confirmDelete(context, p);
              if (ok) await cubit.remove(p.id);
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  // --- Delete confirmation ---

  Future<bool> _confirmDelete(BuildContext context, BirthProfile p) async {
    final brand = context.brand;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Delete "${p.displayName}"?'),
        content: const Text('Its saved charts and readings will be removed.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: brand.live),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    return ok ?? false;
  }
}

// ---------------------------------------------------------------------------
// Cosmic header: back, title, saved count, and the add action.
// ---------------------------------------------------------------------------

class _Header extends StatelessWidget {
  const _Header({required this.count, required this.onAdd});

  final int count;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = context.brand;
    return SliverAppBar(
      pinned: true,
      expandedHeight: 148,
      backgroundColor: brand.cosmicStart,
      surfaceTintColor: Colors.transparent,
      foregroundColor: Colors.white,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      title: Text(
        'Birth profiles',
        style: theme.textTheme.titleLarge?.copyWith(color: Colors.white),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: _AddButton(onTap: onAdd),
        ),
      ],
      flexibleSpace: Stack(
        fit: StackFit.expand,
        children: [
          const CosmicBackdrop(),
          FlexibleSpaceBar(
            collapseMode: CollapseMode.parallax,
            background: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Row(
                    children: [
                      Icon(
                        Icons.auto_awesome_rounded,
                        size: 16,
                        color: AstroPalette.money.start,
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          count == 1
                              ? '1 chart saved · tap to open kundali'
                              : '$count charts saved · tap to open kundali',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// New: dismissible hint teaching the swipe gestures, since nothing on
// screen currently signals that cards are swipeable.
// ---------------------------------------------------------------------------

class _SwipeHintBanner extends StatefulWidget {
  const _SwipeHintBanner();

  @override
  State<_SwipeHintBanner> createState() => _SwipeHintBannerState();
}

class _SwipeHintBannerState extends State<_SwipeHintBanner> {
  bool _dismissed = false;

  @override
  Widget build(BuildContext context) {
    if (_dismissed) return const SizedBox.shrink();
    final theme = Theme.of(context);
    final brand = context.brand;

    const hue = AstroPalette.air;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 8, 6, 8),
        decoration: BoxDecoration(
          color: hue.tint(0.09),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: hue.tint(0.22)),
        ),
        child: Row(
          children: [
            Icon(Icons.swipe_rounded, size: 17, color: hue.end),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Swipe right to activate, left to delete · long-press for more',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: brand.inkMuted,
                ),
              ),
            ),
            IconButton(
              visualDensity: VisualDensity.compact,
              onPressed: () => setState(() => _dismissed = true),
              icon: Icon(Icons.close_rounded, size: 16, color: brand.inkMuted),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Existing sub-widgets (unchanged apart from noted tweaks)
// ---------------------------------------------------------------------------

class _SwipeBackground extends StatelessWidget {
  const _SwipeBackground({
    required this.alignment,
    required this.color,
    required this.icon,
    required this.label,
  });

  final AlignmentGeometry alignment;
  final Color color;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (alignment == Alignment.centerRight) ...[
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
            const SizedBox(width: 6),
          ],
          Icon(icon, color: color, size: 22),
          if (alignment == Alignment.centerLeft) ...[
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SheetAction extends StatelessWidget {
  const _SheetAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        label,
        style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}

class _ProfilesSkeleton extends StatelessWidget {
  const _ProfilesSkeleton({required this.brand, required this.bottomPadding});

  final BrandColors brand;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(16, 14, 16, bottomPadding + 40),
      sliver: SliverList.list(
        children: [
          for (var i = 0; i < 3; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                height: 76,
                decoration: BoxDecoration(
                  color: brand.shimmerBase,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = context.brand;
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 24, 32, 140),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const HueIcon(
            hue: AstroPalette.career,
            icon: Icons.person_add_alt_rounded,
            size: 72,
            iconSize: 34,
          ),
          const SizedBox(height: 20),
          Text(
            'No profiles yet',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add a birth profile to get your\nkundali and personalised readings.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: brand.inkMuted,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => context.push(Routes.birthProfileNew),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add profile'),
            style: FilledButton.styleFrom(
              minimumSize: const Size(180, 46),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Glass "+ Add" action on the cosmic header.
class _AddButton extends StatelessWidget {
  const _AddButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.white.withValues(alpha: 0.1),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.35)),
        minimumSize: const Size(0, 36),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        visualDensity: VisualDensity.compact,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      icon: const Icon(Icons.add_rounded, size: 18),
      label: const Text('Add'),
    );
  }
}
