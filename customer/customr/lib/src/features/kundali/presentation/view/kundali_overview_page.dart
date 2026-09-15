import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:astro_kundali/astro_kundali.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../../core/util/async_value.dart';
import '../../../../shared/widgets/language_quick_button.dart';
import '../../../birthprofiles/data/models/birth_profile.dart';
import '../../../birthprofiles/presentation/bloc/birth_profiles_cubit.dart';
import '../cubit/kundali_cubit.dart';
import '../kundali_terms.dart';
import '../widgets/kundali_pdf_sheet.dart';
import '../widgets/kundali_ui.dart';
import '../widgets/sade_sati_card.dart';
import 'kundali_routes.dart';
import 'widgets/birth_details_sheet.dart';
import 'yogas_doshas_page.dart' show yogaName;

class KundaliOverviewPage extends StatefulWidget {
  const KundaliOverviewPage({required this.profileId, super.key});
  final String profileId;

  @override
  State<KundaliOverviewPage> createState() => _KundaliOverviewPageState();
}

class _KundaliOverviewPageState extends State<KundaliOverviewPage> {
  bool _sharing = false;

  String _name(AppLocalizations l) => _profile?.displayName ?? l.kOvTitle;

  /// Share goes straight to the full report in the default style; the PDF
  /// button opens the sheet with the choices.
  Future<void> _share() async {
    if (_sharing) return;
    final l = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _sharing = true);
    try {
      await shareKundaliPdf(profileId: widget.profileId, name: _name(l));
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
  void initState() {
    super.initState();
    final c = context.read<KundaliCubit>();
    c
      ..loadOverview()
      ..loadDasha()
      ..loadTransits();
    context.read<BirthProfilesCubit>().load();
  }

  BirthProfile? get _profile {
    final list = context.read<BirthProfilesCubit>().state.profiles;
    for (final p in list) {
      if (p.id == widget.profileId) return p;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final profile = _profile;
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          profile == null ? l.kOvTitle : l.kOvTitleNamed(profile.displayName),
        ),
        actions: [
          const LanguageQuickButton(),
          IconButton(
            tooltip: l.kOvDownloadPdf,
            onPressed: () => showKundaliPdfSheet(
              context,
              profileId: widget.profileId,
              name: _name(l),
            ),
            icon: const Icon(Icons.picture_as_pdf_outlined),
          ),
          IconButton(
            tooltip: l.kOvShare,
            onPressed: _sharing ? null : _share,
            icon: _sharing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.ios_share_rounded),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => context.read<KundaliCubit>().refresh(),
        child: BlocBuilder<KundaliCubit, KundaliState>(
          builder: (context, state) {
            return SliceBuilder<Kundali>(
              slice: state.overview,
              onRetry: () =>
                  context.read<KundaliCubit>().loadOverview(force: true),
              builder: (context, k) => ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
                children: [
                  _IdentityStrip(kundali: k, profile: profile),
                  const SizedBox(height: 14),
                  _ChartCard(kundali: k, profileId: widget.profileId),
                  const SizedBox(height: 14),
                  _CurrentPeriodCard(
                    dasha: state.dasha,
                    profileId: widget.profileId,
                  ),
                  const SizedBox(height: 14),
                  _SadeSatiSlot(
                    transits: state.transits,
                    profileId: widget.profileId,
                  ),
                  const SizedBox(height: 18),
                  KLabel(context.l10n.kOvAtAGlance),
                  const SizedBox(height: 8),
                  _GlanceGrid(kundali: k),
                  const SizedBox(height: 16),
                  _ExploreList(profileId: widget.profileId),
                  const SizedBox(height: 16),
                  AskAstrologerBar(onTap: () => context.go(Routes.astrologers)),
                  const SizedBox(height: 36),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _IdentityStrip extends StatelessWidget {
  const _IdentityStrip({required this.kundali, this.profile});
  final Kundali kundali;
  final BirthProfile? profile;

  Future<void> _editBirthProfile(BuildContext context) async {
    final p = profile;
    if (p == null) return;
    final cubit = context.read<KundaliCubit>();
    final changed = await context.push<BirthProfile>(
      Routes.birthProfileEdit(p.id),
    );
    // A saved edit re-keys the chart cache — pull a fresh kundali.
    if (changed != null) await cubit.refresh();
  }

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final theme = Theme.of(context);
    final l = context.l10n;
    return KCard(
      tint: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.kOvMoonSignLabel,
            style: theme.textTheme.labelSmall?.copyWith(
              color: brand.onTint,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            kundali.moonSign.isEmpty
                ? '—'
                : KTerms.signName(l, kundali.moonSign),
            style: theme.textTheme.headlineMedium?.copyWith(
              color: brand.onTint,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              MetaChip(l.kOvLagnaChip(KTerms.signName(l, kundali.lagnaSign))),
              if (kundali.nakshatra.isNotEmpty)
                MetaChip(
                  l.kOvNakshatraChip(
                    KTerms.nakshatraName(l, kundali.nakshatra),
                  ),
                ),
              if (kundali.nakshatraPada > 0)
                MetaChip(l.birthDetailsPada(kundali.nakshatraPada)),
              if (kundali.timeAssumed)
                MetaChip(l.kOvTimeApprox, color: brand.onTint),
            ],
          ),
          if (profile != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.cake_outlined, size: 14, color: brand.onTint),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    [
                      profile!.birthDate,
                      if ((profile!.birthTime ?? '').isNotEmpty)
                        profile!.birthTime!.substring(0, 5),
                      if (profile!.birthPlaceName.isNotEmpty)
                        profile!.birthPlaceName,
                    ].join(' · '),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: brand.onTint,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => _editBirthProfile(context),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.edit_outlined,
                          size: 14,
                          color: brand.onTint,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          l.kOvEdit,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: brand.onTint,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => showBirthDetailsSheet(
                context,
                kundali: kundali,
                profile: profile,
              ),
              icon: const Icon(Icons.article_outlined, size: 17),
              label: Text(context.l10n.birthDetailsCta),
              style: OutlinedButton.styleFrom(
                foregroundColor: brand.onTint,
                side: BorderSide(color: brand.onTint.withValues(alpha: 0.4)),
                minimumSize: const Size.fromHeight(42),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({required this.kundali, required this.profileId});
  final Kundali kundali;
  final String profileId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final retrograde = {
      for (final p in kundali.planets)
        if (p.retrograde) p.name,
    };
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF312152), Color(0xFF1B122C)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                context.l10n.kOvLagnaChart,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '· ${context.l10n.kOvD1Rasi}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 320),
              child: kundali.houses.isEmpty
                  ? const AspectRatio(aspectRatio: 1)
                  : NatalChart(
                      houses: kundali.houses,
                      retrograde: retrograde,
                      fillColor: Colors.transparent,
                      lineColor: Colors.white.withValues(alpha: 0.28),
                      numberColor: Colors.white.withValues(alpha: 0.5),
                      textColor: Colors.white,
                    ),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () => context.push(KundaliRoutes.chart(profileId)),
              label: Text(context.l10n.kOvOpenFullChart),
              icon: const Icon(Icons.chevron_right_rounded, size: 20),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFFACC15), // Goldish color
                padding: const EdgeInsets.symmetric(horizontal: 4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CurrentPeriodCard extends StatelessWidget {
  const _CurrentPeriodCard({required this.dasha, required this.profileId});
  final AsyncValue<DashaTimeline> dasha;
  final String profileId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = context.l10n;
    return KCard(
      child: dasha.when(
        loading: () => const SizedBox(
          height: 60,
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (_) => Text(l.kOvDashaUnavailable),
        data: (d) {
          final span = d.currentSpan;
          final progress = span?.progress(DateTime.now()) ?? 0;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              KLabel(l.kOvDashaRunning),
              const SizedBox(height: 6),
              Text(
                l.kOvMahadasha(KTerms.planetName(l, d.currentMaha)),
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 2),
              Text(
                l.kOvSubPeriods(
                  KTerms.planetName(l, d.currentAntar),
                  KTerms.planetName(l, d.currentPratyantar),
                ),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(99),
                child: LinearProgressIndicator(value: progress, minHeight: 7),
              ),
              if (span != null) ...[
                const SizedBox(height: 6),
                Text(
                  l.kOvDashaProgress(
                    _yr(span.start),
                    _yr(span.end),
                    '${(progress * 100).round()}',
                  ),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
              const SizedBox(height: 12),
              Text(
                KTerms.dashaTone(context.l10n, d.currentMaha),
                style: const TextStyle(fontSize: 13.5, height: 1.45),
              ),
              const SizedBox(height: 6),
              TextButton(
                onPressed: () => context.push(KundaliRoutes.dasha(profileId)),
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: Text(l.kOvSeeTimeline),
              ),
            ],
          );
        },
      ),
    );
  }

  static String _yr(DateTime d) => '${d.year}';
}

class _SadeSatiSlot extends StatelessWidget {
  const _SadeSatiSlot({required this.transits, required this.profileId});
  final AsyncValue<Transits> transits;
  final String profileId;

  @override
  Widget build(BuildContext context) {
    return transits.when(
      loading: () => const SizedBox.shrink(),
      error: (_) => const SizedBox.shrink(),
      data: (t) => SadeSatiCard(
        transits: t,
        onTap: () => context.push(KundaliRoutes.transits(profileId)),
      ),
    );
  }
}

class _GlanceGrid extends StatelessWidget {
  const _GlanceGrid({required this.kundali});
  final Kundali kundali;

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
      _GlanceTile(
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
        positive: !md.isManglik,
      ),
      _GlanceTile(
        label: l.kOvYogas,
        value: l.kOvYogasFound('${kundali.yogas.length}'),
        sub: kundali.yogas
            .take(2)
            .map((y) => yogaName(l, y.key, y.name))
            .join(', '),
      ),
      _GlanceTile(
        label: l.kOvNakshatra,
        value: kundali.nakshatra.isEmpty
            ? '—'
            : KTerms.nakshatraName(l, kundali.nakshatra),
        sub: KTerms.nakshatra(l, kundali.nakshatra),
      ),
      _GlanceTile(
        label: l.kOvLagnaLord,
        value: KTerms.planetName(l, lagnaLord?.name ?? lagnaLordName),
        sub: lagnaLord == null
            ? ''
            : l.kLagnaLordIn(KTerms.nthHouse(l, lagnaLord.house)),
      ),
    ];
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.55,
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

class _GlanceTile extends StatelessWidget {
  const _GlanceTile({
    required this.label,
    required this.value,
    required this.sub,
    this.positive,
  });
  final String label;
  final String value;
  final String sub;
  final bool? positive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = context.brand;
    return KCard(
      padding: const EdgeInsets.all(13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Row(
            children: [
              if (positive != null)
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: Icon(
                    positive! ? Icons.check_circle_rounded : Icons.info_rounded,
                    size: 15,
                    color: positive! ? brand.online : brand.live,
                  ),
                ),
              Flexible(
                child: Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          Text(
            sub,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExploreList extends StatelessWidget {
  const _ExploreList({required this.profileId});
  final String profileId;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final items = <(IconData, String, String, String)>[
      (
        Icons.mood_rounded,
        l.kOvExMood,
        l.kOvExMoodSub,
        KundaliRoutes.mood(profileId),
      ),
      (
        Icons.auto_stories_outlined,
        l.kOvExInsights,
        l.kOvExInsightsSub,
        KundaliRoutes.insights(profileId),
      ),
      (
        Icons.insights_rounded,
        l.kOvExForecast,
        l.kOvExForecastSub,
        '/predictions',
      ),
      (
        Icons.brightness_5_rounded,
        l.kOvExPlanets,
        l.kOvExPlanetsSub,
        KundaliRoutes.planets(profileId),
      ),
      (
        Icons.timeline_rounded,
        l.kOvExDasha,
        l.kOvExDashaSub,
        KundaliRoutes.dasha(profileId),
      ),
      (
        Icons.calendar_month_rounded,
        l.kOvExVarshphal,
        l.kOvExVarshphalSub,
        KundaliRoutes.varshphal(profileId),
      ),
      (
        Icons.auto_awesome_rounded,
        l.kOvExYogas,
        l.kOvExYogasSub,
        KundaliRoutes.yogas(profileId),
      ),
      (
        Icons.spa_outlined,
        l.kOvExRemedies,
        l.kOvExRemediesSub,
        KundaliRoutes.remedies(profileId),
      ),
      (
        Icons.diamond_outlined,
        l.kOvExUpaya,
        l.kOvExUpayaSub,
        KundaliRoutes.jyotishUpaya(profileId),
      ),
      (
        Icons.menu_book_rounded,
        l.kOvExLalKitab,
        l.kOvExLalKitabSub,
        KundaliRoutes.lalKitab(profileId),
      ),
      (
        Icons.public_rounded,
        l.kOvExTransits,
        l.kOvExTransitsSub,
        KundaliRoutes.transits(profileId),
      ),
      (
        Icons.brightness_3_rounded,
        l.kOvExSadeSati,
        l.kOvExSadeSatiSub,
        KundaliRoutes.sadeSati(profileId),
      ),
      (
        Icons.schedule_rounded,
        l.kOvExMuhurta,
        l.kOvExMuhurtaSub,
        KundaliRoutes.muhurta(profileId),
      ),
      (
        Icons.grid_view_rounded,
        l.kOvExHouses,
        l.kOvExHousesSub,
        KundaliRoutes.houses(profileId),
      ),
      (
        Icons.pin_rounded,
        l.kOvExNumerology,
        l.kOvExNumerologySub,
        KundaliRoutes.numerology(profileId),
      ),
      (
        Icons.insights_rounded,
        l.kOvExAdvanced,
        l.kOvExAdvancedSub,
        KundaliRoutes.advanced(profileId),
      ),
    ];
    return KCard(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++)
            Column(
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                  leading: CircleAvatar(
                    radius: 18,
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primaryContainer,
                    child: Icon(
                      items[i].$1,
                      size: 18,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  title: Text(
                    items[i].$2,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(items[i].$3),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => context.push(items[i].$4),
                ),
                if (i != items.length - 1) const Divider(height: 1),
              ],
            ),
        ],
      ),
    );
  }
}
