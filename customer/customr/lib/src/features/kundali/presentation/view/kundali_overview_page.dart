import 'package:astro_kundali/astro_kundali.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/astro_palette.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../../core/util/async_value.dart';
import '../../../../shared/widgets/hue_widgets.dart';
import '../../../../shared/widgets/language_quick_button.dart';
import '../../../../shared/widgets/skeleton.dart';
import '../../../birthprofiles/data/models/birth_profile.dart';
import '../../../birthprofiles/presentation/bloc/birth_profiles_cubit.dart';
import '../../../home/data/models/zodiac.dart';
import '../cubit/kundali_cubit.dart';
import '../kundali_terms.dart';
import '../widgets/k_chart.dart';
import '../widgets/kundali_pdf_sheet.dart';
import '../widgets/kundali_ui.dart';
import '../widgets/sade_sati_card.dart';
import 'house_detail_sheet.dart';
import 'kundali_routes.dart';
import 'widgets/birth_details_sheet.dart';
import 'yogas_doshas_page.dart' show yogaName;

/// The kundali hub: who this chart is for, the chart itself, what's running
/// now, the headline facts, and a map of everything else to explore.
class KundaliOverviewPage extends StatefulWidget {
  const KundaliOverviewPage({required this.profileId, super.key});
  final String profileId;

  @override
  State<KundaliOverviewPage> createState() => _KundaliOverviewPageState();
}

class _KundaliOverviewPageState extends State<KundaliOverviewPage> {
  bool _sharing = false;

  @override
  void initState() {
    super.initState();
    context.read<KundaliCubit>()
      ..loadOverview()
      ..loadNavamsa()
      ..loadDasha()
      ..loadTransits();
    context.read<BirthProfilesCubit>().load();
  }

  BirthProfile? _profileFrom(BirthProfilesState s) {
    for (final p in s.profiles) {
      if (p.id == widget.profileId) return p;
    }
    return null;
  }

  String _name(AppLocalizations l, BirthProfile? p) =>
      p?.displayName ?? l.kOvTitle;

  /// Share goes straight to the full report in the default style; the PDF
  /// button opens the sheet with the choices.
  Future<void> _share(BirthProfile? profile) async {
    if (_sharing) return;
    final l = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _sharing = true);
    try {
      await shareKundaliPdf(
        profileId: widget.profileId,
        name: _name(l, profile),
      );
    } catch (e) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text(kundaliPdfError(context, e))),
        );
      }
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final profile = context.select(
      (BirthProfilesCubit c) => _profileFrom(c.state),
    );
    return BlocBuilder<KundaliCubit, KundaliState>(
      builder: (context, state) {
        final cubit = context.read<KundaliCubit>();
        final k = state.overview.value;
        final lagna = k?.lagnaSign ?? '';
        final moon = k?.moonSign ?? '';
        final hue = kSignHue(lagna.isNotEmpty ? lagna : moon);

        final actions = <Widget>[
          const LanguageQuickButton(),
          IconButton(
            tooltip: l.kOvDownloadPdf,
            onPressed: () => showKundaliPdfSheet(
              context,
              profileId: widget.profileId,
              name: _name(l, profile),
            ),
            icon: const Icon(Icons.picture_as_pdf_outlined),
          ),
          IconButton(
            tooltip: l.kOvShare,
            onPressed: _sharing ? null : () => _share(profile),
            icon: _sharing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.ios_share_rounded),
          ),
        ];

        return KundaliScaffold(
          title: profile == null
              ? l.kOvTitle
              : l.kOvTitleNamed(profile.displayName),
          eyebrow: l.kOvEyebrow,
          headline: _name(l, profile),
          subheadline: profile == null ? null : _birthLine(context, profile),
          hue: hue,
          actions: actions,
          heroTrailing: moon.isEmpty ? null : _MoonGlyph(sign: moon, hue: hue),
          heroChips: k == null
              ? const []
              : [
                  KHeroChip(
                    icon: Icons.north_east_rounded,
                    label: l.kOvLagnaChip(KTerms.signName(l, lagna)),
                    color: kSignHue(lagna).start,
                  ),
                  KHeroChip(
                    icon: Icons.nightlight_round,
                    label: l.kOvMoonChip(KTerms.signName(l, moon)),
                    color: kSignHue(moon).start,
                  ),
                  if (k.nakshatra.isNotEmpty)
                    KHeroChip(
                      icon: Icons.auto_awesome_rounded,
                      label: k.nakshatraPada > 0
                          ? '${KTerms.nakshatraName(l, k.nakshatra)} · ${l.birthDetailsPada(k.nakshatraPada)}'
                          : KTerms.nakshatraName(l, k.nakshatra),
                    ),
                  if (k.timeAssumed)
                    KHeroChip(
                      icon: Icons.schedule_rounded,
                      label: l.kOvTimeApprox,
                    ),
                ],
          onRefresh: cubit.refresh,
          animate: k != null,
          children: k == null
              ? [
                  if (state.overview.isError)
                    _OverviewError(
                      onRetry: () => cubit.loadOverview(force: true),
                    )
                  else
                    const _OverviewSkeleton(),
                ]
              : [
                  _ChartPanel(
                    kundali: k,
                    navamsa: state.navamsa,
                    profileId: widget.profileId,
                  ),
                  _BirthDetailsRow(kundali: k, profile: profile),
                  _RunningDasha(
                    dasha: state.dasha,
                    profileId: widget.profileId,
                  ),
                  if (state.transits.value != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: SadeSatiCard(
                        transits: state.transits.value!,
                        onTap: () => context.push(
                          KundaliRoutes.transits(widget.profileId),
                        ),
                      ),
                    ),
                  KSection(
                    title: l.kOvAtAGlance,
                    hue: AstroPalette.money,
                    child: _GlanceGrid(kundali: k, profileId: widget.profileId),
                  ),
                  _Explore(profileId: widget.profileId),
                  const KAskCta(),
                ],
        );
      },
    );
  }

  static String _birthLine(BuildContext context, BirthProfile p) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    final date = DateTime.tryParse(p.birthDate);
    final time = (p.birthTime ?? '').length >= 5
        ? p.birthTime!.substring(0, 5)
        : '';
    DateTime? clock;
    if (date != null && time.isNotEmpty) {
      final hm = time.split(':');
      clock = DateTime(
        date.year,
        date.month,
        date.day,
        int.tryParse(hm[0]) ?? 0,
        int.tryParse(hm[1]) ?? 0,
      );
    }
    return [
      if (date != null) DateFormat('d MMM yyyy', locale).format(date),
      if (clock != null) DateFormat.jm(locale).format(clock),
      if (p.birthPlaceName.isNotEmpty) p.birthPlaceName.split(',').first,
    ].join(' · ');
  }
}

// --- hero glyph ---------------------------------------------------------------

class _MoonGlyph extends StatelessWidget {
  const _MoonGlyph({required this.sign, required this.hue});
  final String sign;
  final AstroHue hue;

  @override
  Widget build(BuildContext context) {
    final z = ZodiacSign.forProfileSign(sign.toLowerCase());
    return Container(
      width: 84,
      height: 84,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: SweepGradient(colors: [hue.start, hue.end, hue.start]),
        boxShadow: [
          BoxShadow(color: hue.start.withValues(alpha: 0.5), blurRadius: 28),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: context.brand.cosmicStart,
        ),
        padding: const EdgeInsets.all(12),
        child: z == null
            ? Icon(Icons.nightlight_round, color: hue.start, size: 36)
            : SvgPicture.asset(z.svgPath),
      ),
    );
  }
}

// --- chart ------------------------------------------------------------------------

class _ChartPanel extends StatefulWidget {
  const _ChartPanel({
    required this.kundali,
    required this.navamsa,
    required this.profileId,
  });

  final Kundali kundali;
  final AsyncValue<List<ChartHouse>> navamsa;
  final String profileId;

  @override
  State<_ChartPanel> createState() => _ChartPanelState();
}

class _ChartPanelState extends State<_ChartPanel> {
  bool _d9 = false;
  ChartStyle _style = ChartStyle.north;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    final strings = KundaliStrings.of(context);
    final k = widget.kundali;
    final houses = _d9 ? (widget.navamsa.value ?? const []) : k.houses;
    final retro = {
      for (final p in k.planets)
        if (p.retrograde) p.name,
    };

    return KCosmicPanel(
      hue: kSignHue(k.lagnaSign),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  _d9 ? strings.chartShortLabel('d9') : l.kOvLagnaChart,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: brand.onCosmic,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              KDarkSegment(
                labels: [l.kOvD1Rasi, strings.chartShortLabel('d9')],
                selected: _d9 ? 1 : 0,
                onSelect: (i) => setState(() => _d9 = i == 1),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 330),
              child: houses.isEmpty
                  ? AspectRatio(
                      aspectRatio: 1,
                      child: Center(
                        child: widget.navamsa.isError
                            ? Text(
                                l.kFcLoadError,
                                style: TextStyle(color: brand.onCosmicMuted),
                              )
                            : CircularProgressIndicator(
                                color: brand.onCosmicMuted,
                              ),
                      ),
                    )
                  : NatalChart(
                      houses: houses,
                      style: _style,
                      retrograde: _d9 ? const {} : retro,
                      fillColor: Colors.white.withValues(alpha: 0.03),
                      lineColor: Colors.white.withValues(alpha: 0.26),
                      numberColor: Colors.white.withValues(alpha: 0.5),
                      textColor: Colors.white,
                      onHouseTap: _d9
                          ? null
                          : (h) => showHouseDetailSheet(
                              context,
                              kundali: k,
                              house: h,
                            ),
                    ),
            ),
          ),
          const SizedBox(height: 10),
          // Wraps onto two lines on narrow phones / long translations.
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 4,
            children: [
              KDarkSegment(
                labels: [l.kChNorthIndian, l.kChSouthIndian],
                selected: _style == ChartStyle.north ? 0 : 1,
                onSelect: (i) => setState(
                  () => _style = i == 0 ? ChartStyle.north : ChartStyle.south,
                ),
              ),
              TextButton.icon(
                onPressed: () =>
                    context.push(KundaliRoutes.chart(widget.profileId)),
                icon: const Icon(Icons.open_in_full_rounded, size: 17),
                label: Text(l.kOvOpenFullChart),
                style: TextButton.styleFrom(
                  foregroundColor: brand.glowAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                ),
              ),
            ],
          ),
          if (!_d9)
            Text(
              l.kOvTapHouseHint,
              textAlign: TextAlign.center,
              style: theme.textTheme.labelSmall?.copyWith(
                color: brand.onCosmicMuted,
              ),
            ),
        ],
      ),
    );
  }
}

// --- birth details ----------------------------------------------------------------

class _BirthDetailsRow extends StatelessWidget {
  const _BirthDetailsRow({required this.kundali, required this.profile});
  final Kundali kundali;
  final BirthProfile? profile;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = profile;
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        children: [
          Expanded(
            child: KNavRow(
              icon: Icons.article_rounded,
              hue: AstroPalette.air,
              title: l.birthDetailsCta,
              subtitle: l.kOvBirthDetailsSub,
              onTap: () =>
                  showBirthDetailsSheet(context, kundali: kundali, profile: p),
            ),
          ),
          if (p != null) ...[
            const SizedBox(width: 10),
            KSurface(
              radius: 18,
              padding: const EdgeInsets.all(14),
              onTap: () async {
                final cubit = context.read<KundaliCubit>();
                final changed = await context.push<BirthProfile>(
                  Routes.birthProfileEdit(p.id),
                );
                // A saved edit re-keys the chart cache — pull a fresh kundali.
                if (changed != null) await cubit.refresh();
              },
              child: Column(
                children: [
                  Icon(
                    Icons.edit_rounded,
                    size: 20,
                    color: AstroPalette.career.end,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l.kOvEdit,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w800,
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

// --- running dasha ------------------------------------------------------------------

class _RunningDasha extends StatelessWidget {
  const _RunningDasha({required this.dasha, required this.profileId});
  final AsyncValue<DashaTimeline> dasha;
  final String profileId;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final d = dasha.value;
    return KSection(
      title: l.kOvDashaRunning,
      hue: AstroPalette.career,
      trailing: TextButton(
        onPressed: () => context.push(KundaliRoutes.dasha(profileId)),
        child: Text(l.kOvSeeTimeline),
      ),
      child: d == null
          ? (dasha.isError
                ? KSurface(child: Text(l.kOvDashaUnavailable))
                : const AppShimmer(child: SkeletonBox(height: 150, radius: 20)))
          : Builder(
              builder: (context) {
                final span = d.currentSpan;
                final progress = span?.progress(DateTime.now()) ?? 0;
                final hue = kPlanetHue(d.currentMaha);
                return KHueCard(
                  hue: hue,
                  onTap: () => context.push(KundaliRoutes.dasha(profileId)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          PlanetBadge(d.currentMaha, size: 48),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l.kOvMahadasha(
                                    KTerms.planetName(l, d.currentMaha),
                                  ),
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  l.kOvSubPeriods(
                                    KTerms.planetName(l, d.currentAntar),
                                    KTerms.planetName(l, d.currentPratyantar),
                                  ),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: context.brand.inkMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(99),
                        child: Stack(
                          children: [
                            Container(height: 8, color: hue.tint(0.15)),
                            FractionallySizedBox(
                              widthFactor: progress.clamp(0.0, 1.0),
                              child: Container(
                                height: 8,
                                decoration: BoxDecoration(
                                  gradient: hue.linear(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (span != null) ...[
                        const SizedBox(height: 6),
                        Text(
                          l.kOvDashaProgress(
                            '${span.start.year}',
                            '${span.end.year}',
                            '${(progress * 100).round()}',
                          ),
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: context.brand.inkMuted,
                          ),
                        ),
                      ],
                      const SizedBox(height: 10),
                      Text(
                        KTerms.dashaTone(l, d.currentMaha),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

// --- at a glance -------------------------------------------------------------------

class _GlanceGrid extends StatelessWidget {
  const _GlanceGrid({required this.kundali, required this.profileId});
  final Kundali kundali;
  final String profileId;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final md = kundali.mangalDosha;
    final lagnaLordName = _signLord(kundali.lagnaSign);
    final lagnaLord = kundali.planet(lagnaLordName);
    String ref(String r) => switch (r) {
      'lagna' => l.kOvRefLagna,
      'moon' => KTerms.planetName(l, 'Moon'),
      'venus' => KTerms.planetName(l, 'Venus'),
      _ => r,
    };
    final mangalRefs = md.from.map(ref).join(', ');

    final tiles = <Widget>[
      KStatTile(
        icon: md.isManglik
            ? Icons.local_fire_department_rounded
            : Icons.verified_rounded,
        hue: md.isManglik ? AstroPalette.fire : AstroPalette.health,
        label: l.kOvMangalDosha,
        value: md.isManglik ? l.kOvManglik : l.kOvNotManglik,
        sub: switch (md.status) {
          'manglik' => switch (md.severityLabel) {
            'mild' => l.kOvMangalLevelFrom(l.doshaSeverityMild, mangalRefs),
            'moderate' => l.kOvMangalLevelFrom(
              l.doshaSeverityModerate,
              mangalRefs,
            ),
            'strong' => l.kOvMangalLevelFrom(l.doshaSeverityStrong, mangalRefs),
            _ => l.kOvMangalFrom(mangalRefs),
          },
          'cancelled' => l.kOvMangalCancelled,
          _ => l.kOvMarsClear,
        },
        onTap: () => context.push(KundaliRoutes.yogas(profileId)),
      ),
      KStatTile(
        icon: Icons.auto_awesome_rounded,
        hue: AstroPalette.money,
        label: l.kOvYogas,
        value: l.kOvYogasFound('${kundali.yogas.length}'),
        sub: kundali.yogas
            .take(2)
            .map((y) => yogaName(l, y.key, y.name))
            .join(', '),
        onTap: () => context.push(KundaliRoutes.yogas(profileId)),
      ),
      KStatTile(
        icon: Icons.stars_rounded,
        hue: AstroPalette.career,
        label: l.kOvNakshatra,
        value: kundali.nakshatra.isEmpty
            ? '—'
            : KTerms.nakshatraName(l, kundali.nakshatra),
        sub: KTerms.nakshatra(l, kundali.nakshatra),
        onTap: () => context.push(KundaliRoutes.planets(profileId)),
      ),
      KStatTile(
        icon: Icons.person_pin_rounded,
        hue: kPlanetHue(lagnaLord?.name ?? lagnaLordName),
        label: l.kOvLagnaLord,
        value: KTerms.planetName(l, lagnaLord?.name ?? lagnaLordName),
        sub: lagnaLord == null
            ? ''
            : l.kLagnaLordIn(KTerms.nthHouse(l, lagnaLord.house)),
        onTap: () => context.push(KundaliRoutes.houses(profileId)),
      ),
    ];
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.18,
      children: tiles,
    );
  }

  static String _signLord(String sign) =>
      const {
        'Aries': 'Mars',
        'Taurus': 'Venus',
        'Gemini': 'Mercury',
        'Cancer': 'Moon',
        'Leo': 'Sun',
        'Virgo': 'Mercury',
        'Libra': 'Venus',
        'Scorpio': 'Mars',
        'Sagittarius': 'Jupiter',
        'Capricorn': 'Saturn',
        'Aquarius': 'Saturn',
        'Pisces': 'Jupiter',
      }[sign] ??
      '';
}

// --- explore -----------------------------------------------------------------------

class _Explore extends StatelessWidget {
  const _Explore({required this.profileId});
  final String profileId;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final id = profileId;
    final groups =
        <
          (String, AstroHue, List<(IconData, AstroHue, String, String, String)>)
        >[
          (
            l.kOvGroupCharts,
            AstroPalette.career,
            [
              (
                Icons.brightness_5_rounded,
                AstroPalette.money,
                l.kOvExPlanets,
                l.kOvExPlanetsSub,
                KundaliRoutes.planets(id),
              ),
              (
                Icons.grid_view_rounded,
                AstroPalette.air,
                l.kOvExHouses,
                l.kOvExHousesSub,
                KundaliRoutes.houses(id),
              ),
              (
                Icons.auto_awesome_rounded,
                AstroPalette.love,
                l.kOvExYogas,
                l.kOvExYogasSub,
                KundaliRoutes.yogas(id),
              ),
              (
                Icons.insights_rounded,
                AstroPalette.career,
                l.kOvExAdvanced,
                l.kOvExAdvancedSub,
                KundaliRoutes.advanced(id),
              ),
            ],
          ),
          (
            l.kOvGroupTiming,
            AstroPalette.health,
            [
              (
                Icons.timeline_rounded,
                AstroPalette.career,
                l.kOvExDasha,
                l.kOvExDashaSub,
                KundaliRoutes.dasha(id),
              ),
              (
                Icons.public_rounded,
                AstroPalette.water,
                l.kOvExTransits,
                l.kOvExTransitsSub,
                KundaliRoutes.transits(id),
              ),
              (
                Icons.brightness_3_rounded,
                AstroPalette.air,
                l.kOvExSadeSati,
                l.kOvExSadeSatiSub,
                KundaliRoutes.sadeSati(id),
              ),
              (
                Icons.calendar_month_rounded,
                AstroPalette.fire,
                l.kOvExVarshphal,
                l.kOvExVarshphalSub,
                KundaliRoutes.varshphal(id),
              ),
              (
                Icons.schedule_rounded,
                AstroPalette.health,
                l.kOvExMuhurta,
                l.kOvExMuhurtaSub,
                KundaliRoutes.muhurta(id),
              ),
              (
                Icons.mood_rounded,
                AstroPalette.money,
                l.kOvExMood,
                l.kOvExMoodSub,
                KundaliRoutes.mood(id),
              ),
            ],
          ),
          (
            l.kOvGroupGuidance,
            AstroPalette.love,
            [
              (
                Icons.auto_stories_rounded,
                AstroPalette.career,
                l.kOvExInsights,
                l.kOvExInsightsSub,
                KundaliRoutes.insights(id),
              ),
              (
                Icons.query_stats_rounded,
                AstroPalette.love,
                l.kOvExForecast,
                l.kOvExForecastSub,
                '/predictions',
              ),
              (
                Icons.spa_rounded,
                AstroPalette.health,
                l.kOvExRemedies,
                l.kOvExRemediesSub,
                KundaliRoutes.remedies(id),
              ),
              (
                Icons.diamond_rounded,
                AstroPalette.air,
                l.kOvExUpaya,
                l.kOvExUpayaSub,
                KundaliRoutes.jyotishUpaya(id),
              ),
              (
                Icons.menu_book_rounded,
                AstroPalette.fire,
                l.kOvExLalKitab,
                l.kOvExLalKitabSub,
                KundaliRoutes.lalKitab(id),
              ),
              (
                Icons.pin_rounded,
                AstroPalette.money,
                l.kOvExNumerology,
                l.kOvExNumerologySub,
                KundaliRoutes.numerology(id),
              ),
            ],
          ),
        ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final (title, hue, items) in groups)
          KSection(
            title: title,
            hue: hue,
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.3,
              children: [
                for (final (icon, h, t, sub, route) in items)
                  KNavTile(
                    icon: icon,
                    hue: h,
                    title: t,
                    subtitle: sub,
                    onTap: () => context.push(route),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

// --- loading / error --------------------------------------------------------------

class _OverviewSkeleton extends StatelessWidget {
  const _OverviewSkeleton();

  @override
  Widget build(BuildContext context) {
    return const AppShimmer(
      child: Column(
        children: [
          AspectRatio(aspectRatio: 0.92, child: SkeletonBox(radius: 24)),
          SizedBox(height: 12),
          SkeletonBox(height: 64, radius: 18),
          SizedBox(height: 22),
          SkeletonBox(height: 150, radius: 20),
          SizedBox(height: 22),
          Row(
            children: [
              Expanded(child: SkeletonBox(height: 120, radius: 18)),
              SizedBox(width: 10),
              Expanded(child: SkeletonBox(height: 120, radius: 18)),
            ],
          ),
        ],
      ),
    );
  }
}

class _OverviewError extends StatelessWidget {
  const _OverviewError({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return KSurface(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const HueIcon(
            hue: AstroPalette.fire,
            icon: Icons.cloud_off_rounded,
            size: 52,
            iconSize: 26,
          ),
          const SizedBox(height: 12),
          Text(
            l.kOvLoadError,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            l.errNetwork,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: context.brand.inkMuted),
          ),
          const SizedBox(height: 14),
          FilledButton.tonalIcon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: Text(l.commonRetry),
          ),
        ],
      ),
    );
  }
}
