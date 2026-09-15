import 'package:astro_kundali/astro_kundali.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/brand_colors.dart';
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
    return Scaffold(
      appBar: AppBar(title: Text(l.insightsTitle)),
      body: BlocBuilder<KundaliCubit, KundaliState>(
        buildWhen: (a, b) => a.insights != b.insights,
        builder: (context, state) => SliceBuilder<OverviewReport>(
          slice: state.insights,
          onRetry: () => context.read<KundaliCubit>().loadInsights(force: true),
          builder: (context, report) {
            final ordered = [
              for (final area in KundaliInsights.areaOrder)
                ?report.byArea(area),
            ];
            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
              children: [
                Text(
                  l.insightsIntro,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 14),
                for (final s in ordered) ...[
                  _SectionCard(section: s),
                  const SizedBox(height: 10),
                ],
                const SizedBox(height: 6),
                Text(
                  report.disclaimer.isNotEmpty
                      ? report.disclaimer
                      : l.insightsDisclaimer,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                AskAstrologerBar(
                  label: l.insightsAskCta,
                  onTap: () => context.go(Routes.astrologers),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.section});
  final OverviewSection section;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final factors = section.readingFactors
        .map((f) => _factorLine(l, f))
        .where((t) => t.isNotEmpty)
        .toList();

    return KCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                KundaliInsights.icon(section.area),
                size: 19,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  insightsAreaTitle(l, section.area),
                  style: theme.textTheme.titleMedium?.copyWith(fontSize: 15),
                ),
              ),
              _ToneChip(tone: section.tone, strength: section.strength),
            ],
          ),
          if (!section.isMixed) ...[
            const SizedBox(height: 10),
            _StrengthMeter(level: section.strength),
          ],
          if (section.summary.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              section.summary,
              style: const TextStyle(fontSize: 13, height: 1.5),
            ),
          ],
          if (factors.isNotEmpty) ...[
            const SizedBox(height: 6),
            Theme(
              data: theme.copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                tilePadding: EdgeInsets.zero,
                childrenPadding: const EdgeInsets.only(bottom: 4),
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                title: Text(
                  l.insightsWhatItReadsFrom,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                children: [
                  for (final line in factors)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: Text(
                        '·  $line',
                        style: const TextStyle(fontSize: 12.5, height: 1.4),
                      ),
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

class _ToneChip extends StatelessWidget {
  const _ToneChip({required this.tone, required this.strength});
  final String tone;
  final int strength;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final (label, bg, fg) = switch (tone) {
      'supportive' => (
        l.insightsToneSupportive,
        const Color(0xFFDDF0E4),
        const Color(0xFF2C6B45),
      ),
      'challenging' => (
        l.insightsToneChallenging,
        const Color(0xFFFBEBD8),
        const Color(0xFFB0691F),
      ),
      'mixed' => (
        l.insightsToneMixed,
        const Color(0xFFE4E8F5),
        const Color(0xFF3F4E86),
      ),
      _ => (
        l.insightsToneBalanced,
        const Color(0xFFECECEF),
        const Color(0xFF5B5B62),
      ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w800,
          color: fg,
        ),
      ),
    );
  }
}

class _StrengthMeter extends StatelessWidget {
  const _StrengthMeter({required this.level});
  final int level;

  @override
  Widget build(BuildContext context) {
    final on = switch (level) {
      >= 3 => const Color(0xFF2C6B45),
      2 => const Color(0xFFC7A94A),
      _ => const Color(0xFFB0691F),
    };
    return Row(
      children: [
        for (var i = 0; i < 3; i++) ...[
          Expanded(
            child: Container(
              height: 5,
              decoration: BoxDecoration(
                color: i < level ? on : context.brand.hairline,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          if (i < 2) const SizedBox(width: 5),
        ],
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
