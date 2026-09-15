import 'package:astro_kundali/astro_kundali.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/astro_palette.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../../shared/widgets/hue_widgets.dart';
import '../cubit/kundali_cubit.dart';
import '../kundali_terms.dart';
import '../widgets/k_chart.dart';
import '../widgets/kundali_ui.dart';
import 'kundali_routes.dart';

/// Doshas (afflictions, each with severity, reasons and what reduces it) and
/// yogas (beneficial combinations) — two faces switched from the hero.
class YogasDoshasPage extends StatefulWidget {
  const YogasDoshasPage({required this.profileId, super.key});
  final String profileId;

  @override
  State<YogasDoshasPage> createState() => _YogasDoshasPageState();
}

class _YogasDoshasPageState extends State<YogasDoshasPage> {
  int _tab = 0; // 0 doshas · 1 yogas

  @override
  void initState() {
    super.initState();
    context.read<KundaliCubit>()
      ..loadDoshas()
      ..loadYogas()
      ..loadOverview();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return BlocBuilder<KundaliCubit, KundaliState>(
      builder: (context, state) {
        final cubit = context.read<KundaliCubit>();
        final doshas = state.doshas.value;
        final yogas = state.yogas.value;
        final hue = _tab == 0 ? AstroPalette.fire : AstroPalette.money;
        final presentCount = doshas?.present.length ?? 0;

        final List<Widget> body;
        if (_tab == 0) {
          body = doshas == null
              ? [
                  SliceBuilder<DoshaReport>(
                    slice: state.doshas,
                    onRetry: () => cubit.loadDoshas(force: true),
                    skeleton: const KBodySkeleton(blocks: [120, 160, 70]),
                    builder: (_, _) => const SizedBox.shrink(),
                  ),
                ]
              : _doshaBody(context, doshas);
        } else {
          body = yogas == null
              ? [
                  SliceBuilder<List<Yoga>>(
                    slice: state.yogas,
                    onRetry: () => cubit.loadYogas(force: true),
                    skeleton: const KBodySkeleton(blocks: [110, 110, 110]),
                    builder: (_, _) => const SizedBox.shrink(),
                  ),
                ]
              : _yogaBody(context, yogas);
        }

        return KundaliScaffold(
          key: ValueKey('yd-$_tab'),
          title: l.kundaliYogasDoshasTitle,
          eyebrow: l.kOvTitle,
          headline: l.kundaliYogasDoshasTitle,
          subheadline: _tab == 0 ? l.kYdDoshaHeroSub : l.kYdYogaHeroSub,
          hue: hue,
          heroTrailing: KHeroGlyph(
            hue: hue,
            icon: _tab == 0
                ? Icons.shield_moon_rounded
                : Icons.auto_awesome_rounded,
            size: 72,
          ),
          heroChips: [
            if (doshas != null)
              KHeroChip(
                icon: presentCount == 0
                    ? Icons.verified_rounded
                    : Icons.local_fire_department_rounded,
                label: l.kYdDoshaCount(presentCount),
                color: presentCount == 0
                    ? AstroPalette.health.start
                    : AstroPalette.fire.start,
              ),
            if (yogas != null)
              KHeroChip(
                icon: Icons.auto_awesome_rounded,
                label: l.kYdYogaCount(yogas.length),
                color: AstroPalette.money.start,
              ),
          ],
          heroBottom: Align(
            alignment: Alignment.centerLeft,
            child: KDarkSegment(
              labels: [l.kundaliTabDoshas, l.kundaliTabYogas],
              selected: _tab,
              onSelect: (i) => setState(() => _tab = i),
            ),
          ),
          onRefresh: () async {
            await Future.wait([
              cubit.loadDoshas(force: true),
              cubit.loadYogas(force: true),
            ]);
          },
          children: body,
        );
      },
    );
  }

  List<Widget> _doshaBody(BuildContext context, DoshaReport report) {
    final l = context.l10n;
    final present = report.present;
    return [
      Text(
        l.doshaIntro,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: context.brand.inkMuted,
          height: 1.45,
        ),
      ),
      const SizedBox(height: 14),
      if (present.isEmpty)
        KHueCard(
          hue: AstroPalette.health,
          child: Row(
            children: [
              const HueIcon(
                hue: AstroPalette.health,
                icon: Icons.verified_rounded,
                size: 40,
                iconSize: 22,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l.doshaAllClear,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(height: 1.45),
                ),
              ),
            ],
          ),
        )
      else
        for (final d in present) _DoshaCard(dosha: d),
      if (report.clear.isNotEmpty)
        KSection(
          title: l.doshaClearSectionTitle,
          hue: AstroPalette.health,
          child: KSurface(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            child: Column(
              children: [
                for (var i = 0; i < report.clear.length; i++) ...[
                  if (i > 0) Divider(height: 1, color: context.brand.hairline),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          size: 18,
                          color: AstroPalette.health.end,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            doshaName(l, report.clear[i]),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        KToneChip(l.kYdClear, tone: KTone.good),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      KFootnote(
        report.disclaimer.isNotEmpty ? report.disclaimer : l.doshaDisclaimer,
      ),
      const SizedBox(height: 16),
      KNavRow(
        icon: Icons.spa_rounded,
        hue: AstroPalette.health,
        title: l.doshaSeeRemedies,
        subtitle: l.kYdRemediesSub,
        onTap: () => context.push(KundaliRoutes.remedies(widget.profileId)),
      ),
      KAskCta(title: l.doshaAskCta),
    ];
  }

  List<Widget> _yogaBody(BuildContext context, List<Yoga> yogas) {
    final l = context.l10n;
    return [
      Text(
        l.yogaIntro,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: context.brand.inkMuted,
          height: 1.45,
        ),
      ),
      const SizedBox(height: 14),
      if (yogas.isEmpty)
        KSurface(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l.yogaNoneTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                l.yogaNoneBody,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(height: 1.45),
              ),
            ],
          ),
        )
      else
        for (final (i, y) in yogas.indexed) _YogaCard(yoga: y, index: i),
      KAskCta(title: l.kundaliTalkToAstrologer, body: l.kundaliHowItPlaysOut),
    ];
  }
}

class _DoshaCard extends StatelessWidget {
  const _DoshaCard({required this.dosha});
  final Dosha dosha;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final sev = dosha.displaySeverity;
    final cancelled = dosha.present && (dosha.isCancelled || sev == 0);
    final hue = cancelled
        ? AstroPalette.air
        : switch (sev) {
            >= 3 => AstroPalette.fire,
            2 => AstroPalette.money,
            _ => AstroPalette.earth,
          };
    final label = cancelled
        ? l.doshaCancelled
        : switch (sev) {
            >= 3 => l.doshaSeverityStrong,
            2 => l.doshaSeverityModerate,
            _ => l.doshaSeverityMild,
          };

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: KHueCard(
        hue: hue,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                HueIcon(
                  hue: hue,
                  icon: cancelled
                      ? Icons.shield_rounded
                      : Icons.local_fire_department_rounded,
                  size: 40,
                  iconSize: 21,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    doshaName(l, dosha),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                KToneChip(label, hue: hue),
              ],
            ),
            if (!cancelled && sev > 0) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  for (var i = 0; i < 3; i++) ...[
                    Expanded(
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          gradient: i < sev ? hue.linear() : null,
                          color: i < sev ? null : context.brand.hairline,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                    if (i < 2) const SizedBox(width: 5),
                  ],
                ],
              ),
            ],
            const SizedBox(height: 10),
            Text(
              doshaMeaning(l, dosha.key),
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
            ),
            if (dosha.planets.isNotEmpty) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 4,
                children: [
                  for (final p in dosha.planets) PlanetBadge(p, size: 24),
                ],
              ),
            ],
            if (dosha.key == 'kaal_sarpa' &&
                dosha.kaalSarpaType.isNotEmpty) ...[
              const SizedBox(height: 8),
              KToneChip(
                '${dosha.kaalSarpaType}${dosha.partial ? " · ${l.kYdPartial}" : ""}',
                hue: AstroPalette.career,
              ),
            ],
            if (dosha.reasons.isNotEmpty)
              _Bullets(
                title: l.doshaWhy,
                icon: Icons.adjust_rounded,
                hue: hue,
                lines: [for (final r in dosha.reasons) r.text],
              ),
            if (dosha.activeCancellations.isNotEmpty) ...[
              _Bullets(
                title: l.doshaWhatReduces,
                icon: Icons.shield_moon_rounded,
                hue: AstroPalette.health,
                lines: [for (final c in dosha.activeCancellations) c.text],
              ),
              const SizedBox(height: 6),
              Text(
                l.doshaReducedNote(dosha.activeCancellations.length),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: AstroPalette.health.end,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Bullets extends StatelessWidget {
  const _Bullets({
    required this.title,
    required this.icon,
    required this.hue,
    required this.lines,
  });

  final String title;
  final IconData icon;
  final AstroHue hue;
  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: hue.tint(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 15, color: hue.end),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: hue.end,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          for (final line in lines)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 7, right: 8),
                    child: Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        color: hue.end,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      line,
                      style: theme.textTheme.bodySmall?.copyWith(height: 1.45),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _YogaCard extends StatelessWidget {
  const _YogaCard({required this.yoga, required this.index});
  final Yoga yoga;
  final int index;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = context.l10n;
    final meaning = yogaMeaning(l, yoga.key);
    final hue = AstroPalette.at(index);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: KHueCard(
        hue: hue,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                HueIcon(
                  hue: hue,
                  icon: Icons.auto_awesome_rounded,
                  size: 38,
                  iconSize: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    yogaName(l, yoga.key, yoga.name),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            if (meaning.isNotEmpty || yoga.description.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                meaning.isNotEmpty ? meaning : yoga.description,
                style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
              ),
            ],
            if (yoga.planets.isNotEmpty) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  for (final p in yoga.planets) ...[
                    PlanetBadge(p, size: 24),
                    Text(
                      KTerms.displayName(l, p),
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: hue.end,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────── localisation

/// The engine's `key` maps to a localised name; falls back to the payload name.
String doshaName(AppLocalizations l, Dosha d) => switch (d.key) {
  'mangal' => l.doshaMangalName,
  'kaal_sarpa' => l.doshaKaalSarpaName,
  'pitra' => l.doshaPitraName,
  'gandmool' => l.doshaGandmoolName,
  'grahan' => l.doshaGrahanName,
  'shrapit' => l.doshaShrapitName,
  'guru_chandal' => l.doshaGuruChandalName,
  'angarak' => l.doshaAngarakName,
  'kemadruma' => l.doshaKemadrumaName,
  'daridra' => l.doshaDaridraName,
  _ => d.name,
};

String doshaMeaning(AppLocalizations l, String key) => switch (key) {
  'mangal' => l.doshaMangalMeaning,
  'kaal_sarpa' => l.doshaKaalSarpaMeaning,
  'pitra' => l.doshaPitraMeaning,
  'gandmool' => l.doshaGandmoolMeaning,
  'grahan' => l.doshaGrahanMeaning,
  'shrapit' => l.doshaShrapitMeaning,
  'guru_chandal' => l.doshaGuruChandalMeaning,
  'angarak' => l.doshaAngarakMeaning,
  'kemadruma' => l.doshaKemadrumaMeaning,
  'daridra' => l.doshaDaridraMeaning,
  _ => '',
};

/// The engine's yoga `key` (`yoga.*`) → localised name; falls back to
/// [fallback] (the payload name) for anything not yet translated.
String yogaName(AppLocalizations l, String key, [String fallback = '']) =>
    switch (key) {
      'yoga.gajakesari' => l.yogaGajakesariName,
      'yoga.budhaditya' => l.yogaBudhadityaName,
      'yoga.chandra_mangala' => l.yogaChandraMangalaName,
      'yoga.raja' => l.yogaRajaName,
      'yoga.dhana' || 'yoga.dhana.trikona' => l.yogaDhanaName,
      'yoga.neechabhanga' => l.yogaNeechabhangaName,
      'yoga.kaal_sarpa' => l.yogaKaalSarpaName,
      'yoga.adhi' => l.yogaAdhiName,
      'yoga.shakata' => l.yogaShakataName,
      'yoga.vish' => l.yogaVishName,
      'yoga.kahala' => l.yogaKahalaName,
      'yoga.pushkala' => l.yogaPushkalaName,
      'yoga.daridra' => l.yogaDaridraName,
      'yoga.amala' => l.yogaAmalaName,
      'yoga.saraswati' => l.yogaSaraswatiName,
      'yoga.lakshmi' => l.yogaLakshmiName,
      'yoga.mahapurusha.ruchaka' => l.yogaRuchakaName,
      'yoga.mahapurusha.bhadra' => l.yogaBhadraName,
      'yoga.mahapurusha.hamsa' => l.yogaHamsaName,
      'yoga.mahapurusha.malavya' => l.yogaMalavyaName,
      'yoga.mahapurusha.sasa' => l.yogaSasaName,
      'yoga.solar.ubhayachari' => l.yogaUbhayachariName,
      'yoga.solar.vesi' => l.yogaVesiName,
      'yoga.solar.vasi' => l.yogaVasiName,
      'yoga.kartari.shubha' => l.yogaShubhaKartariName,
      'yoga.kartari.papa' => l.yogaPapaKartariName,
      'yoga.lunar.durudhara' => l.yogaDurudharaName,
      'yoga.lunar.sunapha' => l.yogaSunaphaName,
      'yoga.lunar.anapha' => l.yogaAnaphaName,
      'yoga.lunar.kemadruma' => l.yogaKemadrumaYogaName,
      'yoga.vasumati' => l.yogaVasumatiName,
      'yoga.kalanidhi' => l.yogaKalanidhiName,
      'yoga.chamara' => l.yogaChamaraName,
      'yoga.shankha' => l.yogaShankhaName,
      'yoga.parvata' => l.yogaParvataName,
      'yoga.vipreet.harsha' => l.yogaHarshaName,
      'yoga.vipreet.sarala' => l.yogaSaralaName,
      'yoga.vipreet.vimala' => l.yogaVimalaName,
      'yoga.parivartana.maha' => l.yogaMahaParivartanaName,
      'yoga.parivartana.khala' => l.yogaKhalaParivartanaName,
      'yoga.parivartana.dainya' => l.yogaDainyaParivartanaName,
      _ => fallback,
    };

String yogaMeaning(AppLocalizations l, String key) => switch (key) {
  'yoga.gajakesari' => l.yogaGajakesariMeaning,
  'yoga.budhaditya' => l.yogaBudhadityaMeaning,
  'yoga.chandra_mangala' => l.yogaChandraMangalaMeaning,
  'yoga.raja' => l.yogaRajaMeaning,
  'yoga.dhana' || 'yoga.dhana.trikona' => l.yogaDhanaMeaning,
  'yoga.neechabhanga' => l.yogaNeechabhangaMeaning,
  'yoga.kaal_sarpa' => l.yogaKaalSarpaMeaning,
  'yoga.adhi' => l.yogaAdhiMeaning,
  'yoga.shakata' => l.yogaShakataMeaning,
  'yoga.vish' => l.yogaVishMeaning,
  'yoga.kahala' => l.yogaKahalaMeaning,
  'yoga.pushkala' => l.yogaPushkalaMeaning,
  'yoga.daridra' => l.yogaDaridraMeaning,
  'yoga.amala' => l.yogaAmalaMeaning,
  'yoga.saraswati' => l.yogaSaraswatiMeaning,
  'yoga.lakshmi' => l.yogaLakshmiMeaning,
  'yoga.mahapurusha.ruchaka' => l.yogaRuchakaMeaning,
  'yoga.mahapurusha.bhadra' => l.yogaBhadraMeaning,
  'yoga.mahapurusha.hamsa' => l.yogaHamsaMeaning,
  'yoga.mahapurusha.malavya' => l.yogaMalavyaMeaning,
  'yoga.mahapurusha.sasa' => l.yogaSasaMeaning,
  'yoga.solar.ubhayachari' => l.yogaUbhayachariMeaning,
  'yoga.solar.vesi' => l.yogaVesiMeaning,
  'yoga.solar.vasi' => l.yogaVasiMeaning,
  'yoga.kartari.shubha' => l.yogaShubhaKartariMeaning,
  'yoga.kartari.papa' => l.yogaPapaKartariMeaning,
  'yoga.lunar.durudhara' => l.yogaDurudharaMeaning,
  'yoga.lunar.sunapha' => l.yogaSunaphaMeaning,
  'yoga.lunar.anapha' => l.yogaAnaphaMeaning,
  'yoga.lunar.kemadruma' => l.yogaKemadrumaYogaMeaning,
  'yoga.vasumati' => l.yogaVasumatiMeaning,
  'yoga.kalanidhi' => l.yogaKalanidhiMeaning,
  'yoga.chamara' => l.yogaChamaraMeaning,
  'yoga.shankha' => l.yogaShankhaMeaning,
  'yoga.parvata' => l.yogaParvataMeaning,
  'yoga.vipreet.harsha' => l.yogaHarshaMeaning,
  'yoga.vipreet.sarala' => l.yogaSaralaMeaning,
  'yoga.vipreet.vimala' => l.yogaVimalaMeaning,
  'yoga.parivartana.maha' => l.yogaMahaParivartanaMeaning,
  'yoga.parivartana.khala' => l.yogaKhalaParivartanaMeaning,
  'yoga.parivartana.dainya' => l.yogaDainyaParivartanaMeaning,
  _ => '',
};
