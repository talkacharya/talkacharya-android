import 'package:astro_kundali/astro_kundali.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/astro_palette.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../../shared/widgets/hue_widgets.dart';
import '../cubit/kundali_cubit.dart';
import '../kundali_terms.dart';
import '../widgets/kundali_ui.dart';

/// The twelve houses (bhavas): each one's sign, lord, occupants and aspects,
/// and whether benefic or malefic influence dominates.
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
    final l = context.l10n;
    return BlocBuilder<KundaliCubit, KundaliState>(
      builder: (context, state) {
        final cubit = context.read<KundaliCubit>();
        final houses = state.bhava.value;
        final ordered = [...?houses]
          ..sort((a, b) => a.house.compareTo(b.house));
        final supported = ordered.where((h) => h.influenceTally > 0).length;
        final strained = ordered.where((h) => h.influenceTally < 0).length;
        final lagna = ordered.isEmpty ? '' : ordered.first.sign;

        return KundaliScaffold(
          title: l.kBhavaTitle,
          eyebrow: l.kOvTitle,
          headline: l.kBhavaTitle,
          subheadline: l.kBhavaHeroSub,
          hue: kSignHue(lagna),
          heroTrailing: KHeroGlyph(
            hue: kSignHue(lagna),
            icon: Icons.grid_view_rounded,
            size: 72,
          ),
          heroChips: ordered.isEmpty
              ? const []
              : [
                  KHeroChip(
                    icon: Icons.trending_up_rounded,
                    label: l.kBhavaSupportedCount(supported),
                    color: AstroPalette.health.start,
                  ),
                  KHeroChip(
                    icon: Icons.trending_down_rounded,
                    label: l.kBhavaStrainedCount(strained),
                    color: AstroPalette.fire.start,
                  ),
                ],
          onRefresh: () => cubit.loadBhava(force: true),
          animate: houses != null,
          children: houses == null
              ? [
                  SliceBuilder<List<BhavaHouse>>(
                    slice: state.bhava,
                    onRetry: () => cubit.loadBhava(force: true),
                    skeleton: const KBodySkeleton(blocks: [90, 90, 90, 90, 90]),
                    builder: (_, _) => const SizedBox.shrink(),
                  ),
                ]
              : ordered.isEmpty
              ? [const _BhavaEmpty()]
              : [
                  Text(
                    l.kBhavaIntro,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: context.brand.inkMuted,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 14),
                  for (final h in ordered)
                    _BhavaCard(h: h, initiallyOpen: h.house == 1),
                  const KAskCta(),
                ],
        );
      },
    );
  }
}

class _BhavaCard extends StatelessWidget {
  const _BhavaCard({required this.h, required this.initiallyOpen});
  final BhavaHouse h;
  final bool initiallyOpen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = context.l10n;
    final brand = context.brand;
    final hue = kSignHue(h.sign);
    final tally = h.influenceTally;

    return KExpandable(
      initiallyOpen: initiallyOpen,
      header: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: hue.linear(),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              '${h.house}',
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _headline(l, h),
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  _subhead(l, h),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: brand.inkMuted,
                  ),
                ),
                if (h.occupants.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 4,
                    children: [
                      for (final p in h.occupants) PlanetBadge(p, size: 22),
                    ],
                  ),
                ],
              ],
            ),
          ),
          if (tally != 0)
            Tooltip(
              message: tally > 0 ? l.kBhavaMoreBenefic : l.kBhavaMoreMalefic,
              child: HueIcon(
                hue: tally > 0 ? AstroPalette.health : AstroPalette.fire,
                icon: tally > 0
                    ? Icons.trending_up_rounded
                    : Icons.trending_down_rounded,
                size: 30,
                iconSize: 16,
              ),
            ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: hue.tint(0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              _reading(l, h),
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
            ),
          ),
          if (_hasMeta(h)) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                if (h.occupants.isNotEmpty)
                  KToneChip(
                    l.kBhavaOccupiedBy(_join(l, h.occupants)),
                    hue: AstroPalette.career,
                  ),
                if (h.aspectedBy.isNotEmpty)
                  KToneChip(
                    l.kBhavaAspectedBy(_join(l, h.aspectedBy)),
                    hue: AstroPalette.air,
                  ),
                if (h.beneficCount > 0)
                  KToneChip(
                    l.kBhavaBeneficCount(h.beneficCount),
                    tone: KTone.good,
                  ),
                if (h.maleficCount > 0)
                  KToneChip(
                    l.kBhavaMaleficCount(h.maleficCount),
                    tone: KTone.bad,
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

class _BhavaEmpty extends StatelessWidget {
  const _BhavaEmpty();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return KSurface(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const HueIcon(
            hue: AstroPalette.air,
            icon: Icons.schedule_rounded,
            size: 52,
            iconSize: 26,
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
              color: context.brand.inkMuted,
            ),
          ),
        ],
      ),
    );
  }
}
