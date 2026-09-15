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

/// Varshphal (`/varshphal`) — the Tajika annual / solar-return chart for the
/// current year: Varsha Lagna, Muntha, year lord and the Tajika aspect.
class VarshphalPage extends StatefulWidget {
  const VarshphalPage({required this.profileId, super.key});
  final String profileId;

  @override
  State<VarshphalPage> createState() => _VarshphalPageState();
}

class _VarshphalPageState extends State<VarshphalPage> {
  @override
  void initState() {
    super.initState();
    context.read<KundaliCubit>().loadVarshphal();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return BlocBuilder<KundaliCubit, KundaliState>(
      buildWhen: (a, b) => a.varshphal != b.varshphal,
      builder: (context, state) {
        final cubit = context.read<KundaliCubit>();
        final v = state.varshphal.value;
        final hue = kSignHue(v?.varshaLagna ?? '');
        return KundaliScaffold(
          title: l.varshphalTitle,
          eyebrow: l.varshphalTitle,
          headline: v == null || v.year == 0
              ? l.varshphalTitle
              : l.kVpHeadline('${v.year}'),
          subheadline: v == null ? null : l.varshphalWindow(v.starts, v.ends),
          hue: hue,
          heroTrailing: KHeroGlyph(
            hue: hue,
            icon: Icons.cake_rounded,
            size: 72,
          ),
          heroChips: v == null
              ? const []
              : [
                  if (v.varshaLagna.isNotEmpty)
                    KHeroChip(
                      icon: Icons.north_east_rounded,
                      label:
                          '${l.varshphalLagna} · ${KTerms.signName(l, v.varshaLagna)}',
                    ),
                  if (v.yearLord.isNotEmpty)
                    KHeroChip(
                      icon: Icons.workspace_premium_rounded,
                      label:
                          '${l.varshphalYearLord} · ${KTerms.planetName(l, v.yearLord)}',
                      color: kPlanetHue(v.yearLord).start,
                    ),
                ],
          onRefresh: () => cubit.loadVarshphal(force: true),
          animate: v != null,
          children: v == null
              ? [
                  SliceBuilder<Varshphal>(
                    slice: state.varshphal,
                    onRetry: () => cubit.loadVarshphal(force: true),
                    skeleton: const KBodySkeleton(blocks: [120, 220, 260]),
                    builder: (_, _) => const SizedBox.shrink(),
                  ),
                ]
              : [
                  Text(
                    l.varshphalIntro(KTerms.ordinal(l, v.age)),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: context.brand.inkMuted,
                      height: 1.45,
                    ),
                  ),
                  if (v.summary.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    ReadingCard(body: v.summary, hue: hue),
                  ],
                  KSection(
                    title: l.kVpMarkersTitle,
                    hue: hue,
                    child: _Markers(v: v),
                  ),
                  if (v.tajikaSummary.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _TajikaCard(v: v),
                  ],
                  if (v.planets.isNotEmpty)
                    KSection(
                      title: l.varshphalChart,
                      hue: AstroPalette.air,
                      child: _AnnualPlanets(planets: v.planets),
                    ),
                  if (v.disclaimer.isNotEmpty) KFootnote(v.disclaimer),
                  const KAskCta(),
                ],
        );
      },
    );
  }
}

class _Markers extends StatelessWidget {
  const _Markers({required this.v});
  final Varshphal v;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final munthaHue = kSignHue(v.munthaSign);
    final lordHue = kPlanetHue(v.yearLord);
    return Column(
      children: [
        KHueCard(
          hue: munthaHue,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  HueIcon(
                    hue: munthaHue,
                    icon: Icons.my_location_rounded,
                    size: 40,
                    iconSize: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        KLabel(l.varshphalMuntha),
                        Text(
                          KTerms.signName(l, v.munthaSign),
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (v.munthaHouse > 0)
                    KPill(KTerms.nthHouse(l, v.munthaHouse), hue: munthaHue),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                l.varshphalMunthaLine(
                  KTerms.nthHouse(l, v.munthaHouse),
                  v.munthaTheme,
                ),
                style: theme.textTheme.bodyMedium?.copyWith(height: 1.45),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        KHueCard(
          hue: lordHue,
          child: Row(
            children: [
              PlanetBadge(v.yearLord, size: 44),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    KLabel(l.varshphalYearLord),
                    Text(
                      KTerms.planetName(l, v.yearLord),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        if (v.yearLordHouse > 0)
                          KPill(
                            KTerms.nthHouse(l, v.yearLordHouse),
                            hue: lordHue,
                          ),
                        if (v.yearLordDignity.isNotEmpty)
                          KToneChip(
                            KTerms.dignity(l, v.yearLordDignity),
                            tone: kDignityTone(v.yearLordDignity),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TajikaCard extends StatelessWidget {
  const _TajikaCard({required this.v});
  final Varshphal v;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final (label, tone) = switch (v.tajikaYoga) {
      'ithasala' => (l.kVpIthasala, KTone.good),
      'ishrafa' => (l.kVpIshrafa, KTone.caution),
      _ => ('', KTone.neutral),
    };
    return KSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const KIconBox(
                icon: Icons.compare_arrows_rounded,
                hue: AstroPalette.love,
                size: 32,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  l.kVpTajikaTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              if (label.isNotEmpty) KToneChip(label, tone: tone),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            v.tajikaSummary,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(height: 1.45),
          ),
        ],
      ),
    );
  }
}

class _AnnualPlanets extends StatelessWidget {
  const _AnnualPlanets({required this.planets});
  final List<VarshphalPlanet> planets;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    return KSurface(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      child: Column(
        children: [
          for (var i = 0; i < planets.length; i++) ...[
            if (i > 0) Divider(height: 1, color: brand.hairline),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  PlanetBadge(planets[i].name, size: 34),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          KTerms.planetName(l, planets[i].name) +
                              (planets[i].retrograde ? '  ℞' : ''),
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          KTerms.signName(l, planets[i].sign),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: brand.inkMuted,
                          ),
                        ),
                        if (planets[i].dignity.isNotEmpty &&
                            kDignityTone(planets[i].dignity) !=
                                KTone.neutral) ...[
                          const SizedBox(height: 4),
                          KToneChip(
                            KTerms.dignityShort(l, planets[i].dignity),
                            tone: kDignityTone(planets[i].dignity),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (planets[i].house > 0)
                    KPill(
                      KTerms.nthHouse(l, planets[i].house),
                      hue: kPlanetHue(planets[i].name),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
