import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../core/theme/astro_palette.dart';
import '../../../../matchmaking/presentation/view/widgets/match_widgets.dart';
import '../../../../../shared/widgets/pressable.dart';
import '../../cubit/home_cubit.dart';
import 'home_shared.dart';

/// Eye-catching refer-and-earn banner with gradient background and animated
/// floating gift icon. Uses the [ReferralOverview] from [HomeCubit] state.
class ReferEarnBanner extends StatelessWidget {
  const ReferEarnBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final referral = context.select((HomeCubit c) => c.state.referral);
    final overview = referral.when(
      idle: () => null,
      loading: () => null,
      error: (_) => null,
      data: (r) => r,
    );
    if (overview == null || overview.code.isEmpty) {
      return const SizedBox.shrink();
    }
    final code = overview.code;

    return Padding(
      padding: HomeGaps.sidePad,
      child: Pressable(
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: AstroPalette.romance,
            ),
            boxShadow: [
              BoxShadow(
                color: AstroPalette.romance[1].withValues(alpha: 0.35),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              const Positioned.fill(
                child: CustomPaint(painter: HeartsPainter()),
              ),
              Positioned(
                right: -30,
                bottom: -40,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.10),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Refer & Earn',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Share with friends and earn free consultation minutes!',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  code,
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 2,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                InkWell(
                                  onTap: () => Share.share(
                                    'Try TalkAcharya! Use my code $code for free minutes.',
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.3,
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Icon(
                                      Icons.share_rounded,
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    _FloatingGift(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Animated gently floating gift icon (bobs up and down 4px).
class _FloatingGift extends StatefulWidget {
  @override
  State<_FloatingGift> createState() => _FloatingGiftState();
}

class _FloatingGiftState extends State<_FloatingGift>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.maybeDisableAnimationsOf(context) ?? false) {
      return _icon();
    }
    return AnimatedBuilder(
      animation: _c,
      builder: (context, child) {
        final t = Curves.easeInOut.transform(_c.value);
        return Transform.translate(offset: Offset(0, -4 * t), child: child);
      },
      child: _icon(),
    );
  }

  Widget _icon() {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.2),
        border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
      ),
      child: const Icon(
        Icons.card_giftcard_rounded,
        size: 30,
        color: Colors.white,
      ),
    );
  }
}
