import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/astro_palette.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../../core/utils/haptic_service.dart';
import '../../../../shared/widgets/hue_widgets.dart';
import '../../../../shared/widgets/pressable.dart';
import '../../../astrologers/data/models/astrologer.dart';
import '../../data/follows_api.dart';
import '../cubit/follow_cubit.dart';

/// Toggles the follow edge through the app-wide [FollowCubit] and tells the
/// user what happened (or that it failed). Shared by every follow control.
Future<void> toggleFollow(
  BuildContext context, {
  required String astrologerId,
  required String astrologerName,
  FollowSource source = FollowSource.profile,
  FollowEntry? fallback,
}) async {
  final l = context.l10n;
  final messenger = ScaffoldMessenger.maybeOf(context);
  final cubit = context.read<FollowCubit>();
  HapticService.light();
  final result = await cubit.toggle(
    astrologerId,
    source: source,
    fallback: fallback,
  );
  messenger
    ?..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(
          result == null
              ? l.followFailed
              : result
              ? l.followedToast(astrologerName)
              : l.unfollowedToast(astrologerName),
        ),
      ),
    );
}

/// Human count: 950 · 1.2k · 3.4L.
String compactFollowers(int n) {
  if (n >= 100000) return '${(n / 100000).toStringAsFixed(1)}L';
  if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
  return '$n';
}

/// The live follow entry for [astrologerId], or [fallback] (the screen's own
/// server data) until the app-wide cubit knows about it.
FollowEntry? watchFollow(
  BuildContext context,
  String astrologerId, [
  FollowEntry? fallback,
]) => context.select((FollowCubit c) => c.state.of(astrologerId)) ?? fallback;

/// A [FollowEntry] from an astrologer the screen already loaded.
FollowEntry followEntryOf(Astrologer a) =>
    FollowEntry(following: a.isFollowing, followersCount: a.followersCount);

bool watchFollowPending(BuildContext context, String astrologerId) =>
    context.select((FollowCubit c) => c.state.isPending(astrologerId));

/// Glass "Follow / Following" pill for the dark profile header.
class FollowGlassButton extends StatelessWidget {
  const FollowGlassButton({
    required this.astrologerId,
    required this.astrologerName,
    this.fallback,
    this.compact = false,
    super.key,
  });

  final String astrologerId;
  final String astrologerName;
  final FollowEntry? fallback;

  /// Icon-only, for the collapsed toolbar.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final following =
        watchFollow(context, astrologerId, fallback)?.following ?? false;
    final pending = watchFollowPending(context, astrologerId);
    final icon = following
        ? Icons.notifications_active_rounded
        : Icons.person_add_alt_1_rounded;
    final label = following ? l.followFollowing : l.followFollow;
    void onTap() => toggleFollow(
      context,
      astrologerId: astrologerId,
      astrologerName: astrologerName,
      fallback: fallback,
    );

    if (compact) {
      return IconButton(
        tooltip: label,
        onPressed: pending ? null : onTap,
        icon: Icon(
          icon,
          size: 21,
          color: following ? BrandColors.goldGradient.first : Colors.white,
        ),
        style: IconButton.styleFrom(
          backgroundColor: Colors.white.withValues(alpha: 0.1),
          minimumSize: const Size(38, 38),
          padding: EdgeInsets.zero,
        ),
      );
    }

    return Semantics(
      button: true,
      toggled: following,
      label: label,
      child: Pressable(
        child: Material(
          color: following
              ? Colors.white.withValues(alpha: 0.18)
              : Colors.white.withValues(alpha: 0.1),
          shape: StadiumBorder(
            side: BorderSide(
              color: following
                  ? BrandColors.goldGradient.first.withValues(alpha: 0.7)
                  : Colors.white.withValues(alpha: 0.3),
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: pending ? null : onTap,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 7, 12, 7),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      icon,
                      key: ValueKey(following),
                      size: 16,
                      color: following
                          ? BrandColors.goldGradient.first
                          : Colors.white,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    label,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
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

/// Small round follow toggle for list cards (heart outline ↔ filled).
class FollowIconToggle extends StatelessWidget {
  const FollowIconToggle({
    required this.astrologerId,
    required this.astrologerName,
    this.fallback,
    this.size = 32,
    super.key,
  });

  final String astrologerId;
  final String astrologerName;
  final FollowEntry? fallback;
  final double size;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final following =
        watchFollow(context, astrologerId, fallback)?.following ?? false;
    final pending = watchFollowPending(context, astrologerId);
    const hue = AstroPalette.love;
    return Semantics(
      button: true,
      toggled: following,
      label: following ? l.followFollowing : l.followFollow,
      child: Tooltip(
        message: following ? l.followFollowing : l.followFollow,
        child: InkResponse(
          radius: size * 0.7,
          onTap: pending
              ? null
              : () => toggleFollow(
                  context,
                  astrologerId: astrologerId,
                  astrologerName: astrologerName,
                  source: FollowSource.card,
                  fallback: fallback,
                ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: following ? hue.tint(0.14) : null,
              border: Border.all(
                color: following ? hue.tint(0.4) : brand.hairline,
              ),
            ),
            child: Icon(
              following
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              size: size * 0.52,
              color: following ? hue.end : brand.inkMuted,
            ),
          ),
        ),
      ),
    );
  }
}

/// Post-session "Follow {name} to know when they're online" card. Loads the
/// current edge itself, and hides once the customer already follows.
class FollowPromptCard extends StatefulWidget {
  const FollowPromptCard({
    required this.astrologerId,
    required this.astrologerName,
    super.key,
  });

  final String astrologerId;
  final String astrologerName;

  @override
  State<FollowPromptCard> createState() => _FollowPromptCardState();
}

class _FollowPromptCardState extends State<FollowPromptCard> {
  /// Set once the customer follows from this card — keeps the thank-you line
  /// visible instead of the card vanishing under their thumb.
  bool _followedHere = false;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<FollowCubit>();
    if (cubit.state.of(widget.astrologerId) != null) {
      _loaded = true;
    } else {
      cubit.load(widget.astrologerId).whenComplete(() {
        if (mounted) setState(() => _loaded = true);
      });
    }
  }

  Future<void> _follow() async {
    final result = await context.read<FollowCubit>().toggle(
      widget.astrologerId,
      source: FollowSource.postSession,
    );
    if (!mounted) return;
    if (result == true) {
      setState(() => _followedHere = true);
    } else {
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(context.l10n.followFailed),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    final entry = watchFollow(context, widget.astrologerId);
    final pending = watchFollowPending(context, widget.astrologerId);
    if (!_loaded) return const SizedBox.shrink();
    if ((entry?.following ?? false) && !_followedHere) {
      return const SizedBox.shrink(); // already a follower before the session
    }
    final done = _followedHere && (entry?.following ?? false);
    const hue = AstroPalette.love;

    return Material(
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: brand.hairline),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
        child: Row(
          children: [
            HueIcon(
              hue: hue,
              icon: done
                  ? Icons.notifications_active_rounded
                  : Icons.person_add_alt_1_rounded,
              size: 42,
              iconSize: 21,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    done
                        ? l.followPromptDoneTitle
                        : l.followPromptTitle(widget.astrologerName),
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    done
                        ? l.followPromptDoneBody(widget.astrologerName)
                        : l.followPromptBody,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: brand.inkMuted,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            if (!done) ...[
              const SizedBox(width: 8),
              FilledButton(
                onPressed: pending ? null : _follow,
                style: FilledButton.styleFrom(
                  backgroundColor: hue.end,
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                ),
                child: Text(l.followFollow),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
