import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../core/router/routes.dart';
import '../../cubit/home_cubit.dart';
import 'home_shared.dart';

import 'package:talkacharya_ui/talkacharya_ui.dart';

/// One slim row: a gift badge, "Refer & Earn" with the code, and share.
/// Uses the [ReferralOverview] from [HomeCubit] state; hidden without a code.
class ReferEarnBanner extends StatelessWidget {
  const ReferEarnBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = context.brand;
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
    const hue = AstroPalette.love;

    return Padding(
      padding: HomeGaps.sidePad,
      child: Material(
        color: hue.tint(0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: hue.tint(0.22)),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => context.push(Routes.referrals),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 6, 10),
            child: Row(
              children: [
                const HueIcon(
                  hue: hue,
                  icon: Icons.card_giftcard_rounded,
                  size: 38,
                  iconSize: 19,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Refer & Earn',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        'Your code $code · friends get free minutes',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: brand.inkMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Share',
                  onPressed: () => Share.share(
                    'Try TalkAcharya! Use my code $code for free minutes.',
                  ),
                  icon: Icon(Icons.share_rounded, color: hue.end, size: 20),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
