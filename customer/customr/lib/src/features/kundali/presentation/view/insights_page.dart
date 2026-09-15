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
import 'yogas_doshas_page.dart' show yogaName;

/// Free D1 "insights" — a descriptive character & life sketch from the birth
/// chart (`/overview`). Tendencies, not a forecast. The paid predictions
/// product is separate.
class InsightsPage extends StatefulWidget {
  const InsightsPage({required this.profileId, super.key});
  final String profileId;

  @override
  State<InsightsPage> createState() => _InsightsPageState();
}

class _InsightsPageState extends State<InsightsPage> {
  @override
  void initState() {
    super.initState();
    context.read<KundaliCubit>().loadInsights();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    const hue = AstroPalette.love;
    return BlocBuilder<KundaliCubit, KundaliState>(
      buildWhen: (a, b) => a.insights != b.insights,
      builder: (context, state) {
        final cubit = context.read<KundaliCubit>();
        final report = state.insights.value;
        final ordered = report == null
            ? const <OverviewSection>[]
            : [
                for (final area in KundaliInsights.areaOrder)
                  ?report.byArea(area),
              ];
        final supportive = ordered.where((s) => s.tone == 'supportive').length;
        final challenging = ordered
            .where((s) => s.tone == 'challenging')
            .length;

        return KundaliScaffold(
          title: l.insightsTitle,
          eyebrow: l.kOvTitle,
          headline: l.insightsTitle,
          subheadline: l.kInHeroSub,
          hue: hue,
          heroTrailing: const KHeroGlyph(
            hue: hue,
            icon: Icons.psychology_rounded,
            size: 72,
          ),
          heroChips: ordered.isEmpty
              ? const []
              : [
                  KHeroChip(
                    icon: Icons.trending_up_rounded,
                    label: l.kInSupportiveCount(supportive),
                    color: AstroPalette.health.start,
                  ),
                  KHeroChip(
                    icon: Icons.trending_down_rounded,
                    label: l.kInChallengingCount(challenging),
                    color: AstroPalette.money.start,
                  ),
                ],
          onRefresh: () => cubit.loadInsights(force: true),
          animate: report != null,
          children: report == null
              ? [
                  SliceBuilder<OverviewReport>(
                    slice: state.insights,
                    onRetry: () => cubit.loadInsights(force: true),
                    skeleton: const KBodySkeleton(blocks: [90, 110, 110, 110]),
                    builder: (_, _) => const SizedBox.shrink(),
                  ),
                ]
              : [
                  Text(
                    l.insightsIntro,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: context.brand.inkMuted,
                      height: 1.45,
                    ),
                  ),
                  if (ordered.isNotEmpty)
                    KSection(
                      title: l.kInGlanceTitle,
                      hue: hue,
                      padTop: 18,
                      child: Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          for (final s in ordered)
                            KToneChip(
                              insightsAreaTitle(l, s.area),
                              tone: _tone(s.tone),
                              hue: s.tone == 'mixed' ? AstroPalette.air : null,
                            ),
                        ],
                      ),
                    ),
                  KSection(
                    title: l.kInAreasTitle,
                    hue: AstroPalette.career,
                    child: Column(
                      children: [
                        for (var i = 0; i < ordered.length; i++)
                          _SectionCard(section: ordered[i], open: i == 0),
                      ],
                    ),
                  ),
                  KFootnote(
                    report.disclaimer.isNotEmpty
                        ? report.disclaimer
                        : l.insightsDisclaimer,
                  ),
                  KAskCta(title: l.insightsAskCta),
                ],
        );
      },
    );
  }
}

KTone _tone(String tone) => switch (tone) {
  'supportive' => KTone.good,
  'challenging' => KTone.caution,
  _ => KTone.neutral,
};

AstroHue _areaHue(String area) => switch (area) {
  'personality' || 'career' => AstroPalette.career,
  'appearance' || 'marriage' => AstroPalette.love,
  'mind_emotions' => AstroPalette.air,
  'wealth' || 'fortune' => AstroPalette.money,
  'education' => AstroPalette.water,
  'family' => AstroPalette.earth,
  'health' => AstroPalette.health,
  _ => AstroPalette.fire,
};

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.section, this.open = false});
  final OverviewSection section;
  final bool open;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final hue = _areaHue(section.area);
    final factors = section.readingFactors
        .map((f) => _factorLine(l, f))
        .where((t) => t.isNotEmpty)
        .toList();
    final toneLabel = switch (section.tone) {
      'supportive' => l.insightsToneSupportive,
      'challenging' => l.insightsToneChallenging,
      'mixed' => l.insightsToneMixed,
      _ => l.insightsToneBalanced,
    };

    return KExpandable(
      initiallyOpen: open,
      header: Row(
        children: [
          HueIcon(
            hue: hue,
            icon: KundaliInsights.icon(section.area),
            size: 42,
            iconSize: 21,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  insightsAreaTitle(l, section.area),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Flexible(
                      child: KToneChip(
                        toneLabel,
                        tone: _tone(section.tone),
                        hue: section.tone == 'mixed' ? AstroPalette.air : null,
                      ),
                    ),
                    if (!section.isMixed) ...[
                      const SizedBox(width: 10),
                      _StrengthMeter(level: section.strength),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (section.summary.isNotEmpty)
            Text(
              section.summary,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
            ),
          if (factors.isNotEmpty)
            KNoteBox(
              title: l.insightsWhatItReadsFrom,
              icon: Icons.manage_search_rounded,
              hue: hue,
              lines: factors,
            ),
        ],
      ),
    );
  }
}

/// 3-step strength bar; green when strong, amber when strained.
class _StrengthMeter extends StatelessWidget {
  const _StrengthMeter({required this.level});
  final int level;

  @override
  Widget build(BuildContext context) {
    final hue = switch (level) {
      >= 3 => AstroPalette.health,
      2 => AstroPalette.money,
      _ => AstroPalette.fire,
    };
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < 3; i++)
          Container(
            width: 14,
            height: 6,
            margin: const EdgeInsets.only(right: 3),
            decoration: BoxDecoration(
              gradient: i < level ? hue.linear() : null,
              color: i < level ? null : context.brand.hairline,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
      ],
    );
  }
}

/// One localised "what this reads from" line for a factor. Falls back to the
/// package's English [KundaliInsights.factorText] for keys not yet localised.
String _factorLine(AppLocalizations l, OverviewFactor f) {
  String nth(int n) => KTerms.nthHouse(l, n);
  String strength(int s) => switch (s) {
    >= 3 => l.ovStrengthStrong,
    2 => l.ovStrengthSteady,
    1 => l.ovStrengthStrain,
    0 => l.ovStrengthWeak,
    _ => '',
  };
  switch (f.key) {
    case 'overview.factor.lagna_sign':
      return l.ovfLagnaSign(f.sign);
    case 'overview.factor.lagna_lord':
      final dig = f.dignity.isEmpty
          ? ''
          : ' (${KTerms.dignity(l, f.dignity).toLowerCase()})';
      return l.ovfLagnaLord(f.planet, nth(f.inHouse), dig);
    case 'overview.factor.house_lord':
      return l.ovfHouseLord(
        KTerms.ordinal(l, f.house),
        f.planet,
        nth(f.inHouse),
      );
    case 'overview.factor.house_strength':
      return l.ovfHouseStrength(
        KTerms.ordinal(l, f.house),
        strength(f.strength),
      );
    case 'overview.factor.moon_sign':
      return l.ovfMoonSign(f.sign);
    case 'overview.factor.moon_house':
      return l.ovfMoonHouse(nth(f.house));
    case 'overview.factor.moon_nakshatra':
      return l.ovfMoonNakshatra(f.nakshatra) +
          (f.pada > 0 ? ' · ${l.ovfPada(f.pada)}' : '');
    case 'overview.factor.moon_dignity':
      return l.ovfMoonDignity(KTerms.dignity(l, f.dignity).toLowerCase());
    case 'overview.factor.sun_sign':
      return l.ovfSunSign(f.sign);
    case 'overview.factor.seventh_sign':
      return l.ovfSeventhSign(f.sign);
    case 'overview.factor.planet_in_house':
      return l.ovfPlanetInHouse(f.planet, nth(f.house));
    case 'overview.factor.planet_with_moon':
      return l.ovfPlanetWithMoon(f.planet);
    case 'overview.factor.appearance_influence':
      return f.occupant
          ? l.ovfAppearanceIn(f.planet)
          : l.ovfAppearanceAspect(f.planet);
    case 'overview.factor.malefic_on_lagna':
      return l.ovfMaleficOnLagna(f.planet);
    case 'overview.factor.karaka':
      return l.ovfKaraka(_role(l, f.role), f.planet);
    case 'overview.factor.yoga':
      return l.ovfYoga(yogaName(l, f.refKey, f.name));
    case 'overview.factor.dosha':
      final sev = f.netSeverity > 0 ? ' (${strength(f.netSeverity)})' : '';
      return l.ovfDosha(f.name) + sev;
    default:
      return KundaliInsights.factorText(f);
  }
}

String _role(AppLocalizations l, String role) => switch (role) {
  'spouse' => l.ovRoleSpouse,
  'darakaraka' => l.ovRoleDarakaraka,
  'wealth' => l.ovRoleWealth,
  'intellect' => l.ovRoleIntellect,
  'wisdom' => l.ovRoleWisdom,
  'fortune' => l.ovRoleFortune,
  'father' => l.ovRoleFather,
  'mother' => l.ovRoleMother,
  _ => l.ovRoleGeneric,
};

/// Engine `area` → localised section title; falls back to the package's
/// English title.
String insightsAreaTitle(AppLocalizations l, String area) => switch (area) {
  'personality' => l.insightsAreaPersonality,
  'appearance' => l.insightsAreaAppearance,
  'mind_emotions' => l.insightsAreaMind,
  'career' => l.insightsAreaCareer,
  'wealth' => l.insightsAreaWealth,
  'education' => l.insightsAreaEducation,
  'marriage' => l.insightsAreaMarriage,
  'family' => l.insightsAreaFamily,
  'health' => l.insightsAreaHealth,
  'fortune' => l.insightsAreaFortune,
  'strengths_challenges' => l.insightsAreaStrengths,
  _ => KundaliInsights.title(area),
};
