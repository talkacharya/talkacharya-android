import 'package:customr/src/core/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/router/routes.dart';
import '../../../../../core/theme/astro_palette.dart';
import '../../../../../core/theme/brand_colors.dart';
import '../../../../../shared/widgets/pressable.dart';
import '../../../data/models/recharge_pack.dart';
import '../../cubit/home_cubit.dart';
import 'home_shared.dart';

/// Recharge denominations as small money-coloured cards; the badged pack is
/// filled and lifted so it's the obvious pick.
class RechargePacksStrip extends StatelessWidget {
  const RechargePacksStrip({super.key});

  @override
  Widget build(BuildContext context) {
    final packs = context.select((HomeCubit c) => c.state.packs);
    final items = packs.value ?? const <RechargePack>[];
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: context.l10n.homeRechargeWalletTitle,
          hue: AstroPalette.money,
          onSeeAll: () => context.push(Routes.wallet),
          seeAllLabel: 'All plans',
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(
              HomeGaps.side,
              10,
              HomeGaps.side,
              12,
            ),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (context, i) =>
                Pressable(child: _PackCard(pack: items[i])),
          ),
        ),
      ],
    );
  }
}

class _PackCard extends StatelessWidget {
  const _PackCard({required this.pack});
  final RechargePack pack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = context.brand;
    final popular = pack.badge != null && pack.badge!.isNotEmpty;
    const hue = AstroPalette.money;
    final fg = popular ? Colors.white : brand.ink;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: hue.start.withValues(alpha: popular ? 0.4 : 0.12),
                blurRadius: popular ? 16 : 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Material(
            borderRadius: BorderRadius.circular(18),
            clipBehavior: Clip.antiAlias,
            color: theme.colorScheme.surface,
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: popular
                    ? hue.linear()
                    : LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [hue.tint(0.14), theme.colorScheme.surface],
                      ),
                border: popular ? null : Border.all(color: hue.tint(0.3)),
              ),
              child: InkWell(
                onTap: () => context.push(Routes.wallet, extra: pack.amount),
                child: SizedBox(
                  width: 96,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '₹${pack.amount}',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: fg,
                          letterSpacing: -0.4,
                        ),
                      ),
                      if (pack.hasBonus)
                        Text(
                          '+₹${pack.bonus} bonus',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: popular ? Colors.white : brand.online,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        if (popular)
          Positioned(
            top: -9,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  gradient: AstroPalette.love.linear(),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: theme.colorScheme.surface,
                    width: 1.5,
                  ),
                ),
                child: Text(
                  pack.badge!.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
