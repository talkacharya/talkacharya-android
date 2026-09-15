import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:astro_kundali/astro_kundali.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../../shared/widgets/skeleton.dart';
import '../cubit/kundali_cubit.dart';
import '../kundali_terms.dart';
import '../widgets/kundali_ui.dart';

class BhavaPage extends StatefulWidget {
  const BhavaPage({required this.profileId, super.key});
  final String profileId;

  @override
  State<BhavaPage> createState() => _BhavaPageState();
}

class _BhavaPageState extends State<BhavaPage> {
  @override
  void initState() {
    super.initState();
    context.read<KundaliCubit>().loadBhava();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.kBhavaTitle)),
      body: BlocBuilder<KundaliCubit, KundaliState>(
        builder: (context, state) => SliceBuilder<List<BhavaHouse>>(
          slice: state.bhava,
          onRetry: () => context.read<KundaliCubit>().loadBhava(),
          skeleton: const _BhavaSkeleton(),
          builder: (context, houses) {
            if (houses.isEmpty) {
              return const _BhavaEmpty();
            }
            final ordered = [...houses]
              ..sort((a, b) => a.house.compareTo(b.house));
            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
              children: [
                Text(
                  context.l10n.kBhavaIntro,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),
                for (final h in ordered) ...[
                  _BhavaCard(h: h),
                  const SizedBox(height: 10),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _BhavaCard extends StatelessWidget {
  const _BhavaCard({required this.h});
  final BhavaHouse h;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final brand = context.brand;
    final l = context.l10n;
    final tally = h.influenceTally;
    return KCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 15,
                backgroundColor: scheme.primaryContainer,
                child: Text(
                  '${h.house}',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    color: scheme.onPrimaryContainer,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _headline(context.l10n, h),
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      _subhead(context.l10n, h),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (tally != 0)
                Tooltip(
                  message: tally > 0
                      ? l.kBhavaMoreBenefic
                      : l.kBhavaMoreMalefic,
                  child: Icon(
                    tally > 0
                        ? Icons.trending_up_rounded
                        : Icons.trending_down_rounded,
                    size: 18,
                    color: tally > 0 ? brand.online : brand.live,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            _reading(context.l10n, h),
            style: const TextStyle(fontSize: 13, height: 1.45),
          ),
          if (_hasMeta(h)) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                if (h.occupants.isNotEmpty)
                  MetaChip(l.kBhavaOccupiedBy(_join(l, h.occupants))),
                if (h.aspectedBy.isNotEmpty)
                  MetaChip(l.kBhavaAspectedBy(_join(l, h.aspectedBy))),
                if (h.beneficCount > 0)
                  MetaChip(
                    l.kBhavaBeneficCount(h.beneficCount),
                    color: brand.online,
                  ),
                if (h.maleficCount > 0)
                  MetaChip(
                    l.kBhavaMaleficCount(h.maleficCount),
                    color: brand.live,
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  static bool _hasMeta(BhavaHouse h) =>
      h.occupants.isNotEmpty ||
      h.aspectedBy.isNotEmpty ||
      h.beneficCount > 0 ||
      h.maleficCount > 0;

  static String _join(AppLocalizations l, List<String> planets) =>
      KTerms.displayNames(l, planets);

  static String _headline(AppLocalizations l, BhavaHouse h) {
    final name = KTerms.house(l, h.house);
    return h.sign.isEmpty
        ? name
        : l.kHouseTitleWithSign(KTerms.signName(l, h.sign), name);
  }

  static String _subhead(AppLocalizations l, BhavaHouse h) {
    final parts = <String>[];
    final lord = KTerms.planetName(l, h.lord);
    if (h.karaka.isNotEmpty) {
      parts.add(l.kBhavaSubheadKaraka(KTerms.displayNameCsv(l, h.karaka)));
    }
    if (h.lord.isNotEmpty && h.lordHouse > 0) {
      parts.add(l.kBhavaSubheadLord(lord, KTerms.nthHouse(l, h.lordHouse)));
    } else if (h.lord.isNotEmpty) {
      parts.add(l.kBhavaSubheadLordOnly(lord));
    }
    return parts.join(' · ');
  }

  static String _reading(AppLocalizations l, BhavaHouse h) {
    final houseName = KTerms.house(l, h.house).toLowerCase();
    if (h.lord.isEmpty || h.lordHouse <= 0) {
      return l.kBhavaReadingGoverns(houseName);
    }
    final dignity = h.lordDignity.isEmpty
        ? ''
        : l.kBhavaReadingDignity(
            KTerms.dignity(l, h.lordDignity).toLowerCase(),
          );
    final occupants = h.occupants.isEmpty
        ? ''
        : l.kBhavaReadingOccupants(
            _join(l, h.occupants),
            h.occupants.map((p) => KTerms.planet(l, p)).join('; '),
          );
    return l.kBhavaReadingLord(
      KTerms.planetName(l, h.lord),
      KTerms.nthHouse(l, h.lordHouse),
      houseName,
      KTerms.house(l, h.lordHouse).toLowerCase(),
      dignity,
      occupants,
    );
  }
}

/// Shimmer placeholder shown while the 12 houses load.
class _BhavaSkeleton extends StatelessWidget {
  const _BhavaSkeleton();

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
        children: [
          const SkeletonBox(width: 240, height: 12),
          const SizedBox(height: 6),
          const SkeletonBox(width: 180, height: 12),
          const SizedBox(height: 16),
          for (var i = 0; i < 5; i++) ...[
            const _BhavaCardSkeleton(),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class _BhavaCardSkeleton extends StatelessWidget {
  const _BhavaCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return const KCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SkeletonBox(width: 30, height: 30, radius: 15),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonBox(width: 140, height: 13),
                    SizedBox(height: 6),
                    SkeletonBox(width: 200, height: 11),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          SkeletonBox(height: 11),
          SizedBox(height: 6),
          SkeletonBox(height: 11),
          SizedBox(height: 6),
          SkeletonBox(width: 220, height: 11),
        ],
      ),
    );
  }
}

class _BhavaEmpty extends StatelessWidget {
  const _BhavaEmpty();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.grid_view_rounded,
              size: 44,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 12),
            Text(
              context.l10n.kBhavaNeedsTime,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              context.l10n.kBhavaNeedsTimeBody,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
