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
import 'kundali_routes.dart';

class YogasDoshasPage extends StatefulWidget {
  const YogasDoshasPage({required this.profileId, super.key});
  final String profileId;

  @override
  State<YogasDoshasPage> createState() => _YogasDoshasPageState();
}

class _YogasDoshasPageState extends State<YogasDoshasPage> {
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l.kundaliYogasDoshasTitle),
          bottom: TabBar(
            tabs: [
              Tab(text: l.kundaliTabDoshas),
              Tab(text: l.kundaliTabYogas),
            ],
          ),
        ),
        body: const TabBarView(children: [_DoshasTab(), _YogasTab()]),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────── doshas

class _DoshasTab extends StatelessWidget {
  const _DoshasTab();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return BlocBuilder<KundaliCubit, KundaliState>(
      buildWhen: (a, b) => a.doshas != b.doshas,
      builder: (context, state) => SliceBuilder<DoshaReport>(
        slice: state.doshas,
        onRetry: () => context.read<KundaliCubit>().loadDoshas(force: true),
        builder: (context, report) {
          final present = report.present;
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
            children: [
              Text(
                l.doshaIntro,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 14),
              if (present.isEmpty)
                KCard(
                  tint: true,
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        color: context.brand.online,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          l.doshaAllClear,
                          style: const TextStyle(fontSize: 13, height: 1.4),
                        ),
                      ),
                    ],
                  ),
                )
              else
                for (final d in present) ...[
                  _DoshaCard(dosha: d),
                  const SizedBox(height: 10),
                ],
              const SizedBox(height: 6),
              _ClearList(doshas: report.clear),
              const SizedBox(height: 16),
              Text(
                report.disclaimer.isNotEmpty
                    ? report.disclaimer
                    : l.doshaDisclaimer,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () =>
                    context.push(KundaliRoutes.remedies(_profileIdOf(context))),
                icon: const Icon(Icons.spa_outlined, size: 18),
                label: Text(l.doshaSeeRemedies),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
              ),
              const SizedBox(height: 10),
              AskAstrologerBar(
                label: l.doshaAskCta,
                onTap: () => context.go(Routes.astrologers),
              ),
            ],
          );
        },
      ),
    );
  }
}

String _profileIdOf(BuildContext context) =>
    context.read<KundaliCubit>().profileId;

class _DoshaCard extends StatelessWidget {
  const _DoshaCard({required this.dosha});
  final Dosha dosha;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final sev = dosha.displaySeverity;
    final cancelled = dosha.present && (dosha.isCancelled || sev == 0);

    return KCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  doshaName(l, dosha),
                  style: theme.textTheme.titleMedium?.copyWith(fontSize: 15),
                ),
              ),
              _StatusChip(cancelled: cancelled, severity: sev),
            ],
          ),
          if (!cancelled && sev > 0) ...[
            const SizedBox(height: 8),
            _SeverityMeter(level: sev),
          ],
          const SizedBox(height: 8),
          Text(
            doshaMeaning(l, dosha.key),
            style: const TextStyle(fontSize: 13, height: 1.45),
          ),
          if (dosha.key == 'kaal_sarpa' && dosha.kaalSarpaType.isNotEmpty) ...[
            const SizedBox(height: 8),
            MetaChip(
              '${dosha.kaalSarpaType}${dosha.partial ? " · ${l.kYdPartial}" : ""}',
            ),
          ],
          if (dosha.reasons.isNotEmpty) ...[
            const SizedBox(height: 12),
            _BulletBlock(
              title: l.doshaWhy,
              icon: Icons.adjust_rounded,
              lines: [for (final r in dosha.reasons) r.text],
            ),
          ],
          if (dosha.activeCancellations.isNotEmpty) ...[
            const SizedBox(height: 10),
            _BulletBlock(
              title: l.doshaWhatReduces,
              icon: Icons.shield_moon_outlined,
              accent: context.brand.online,
              lines: [for (final c in dosha.activeCancellations) c.text],
            ),
            const SizedBox(height: 6),
            Text(
              l.doshaReducedNote(dosha.activeCancellations.length),
              style: theme.textTheme.labelSmall?.copyWith(
                color: context.brand.online,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.cancelled, required this.severity});
  final bool cancelled;
  final int severity;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final (label, bg, fg) = cancelled
        ? (l.doshaCancelled, const Color(0xFFE9E9EC), const Color(0xFF5B5B62))
        : switch (severity) {
            >= 3 => (
              l.doshaSeverityStrong,
              const Color(0xFFF8DCD6),
              const Color(0xFFB23A28),
            ),
            2 => (
              l.doshaSeverityModerate,
              const Color(0xFFFBEBD8),
              const Color(0xFFB0691F),
            ),
            _ => (
              l.doshaSeverityMild,
              const Color(0xFFF3EEDD),
              const Color(0xFF8A7A32),
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

class _SeverityMeter extends StatelessWidget {
  const _SeverityMeter({required this.level});
  final int level;

  @override
  Widget build(BuildContext context) {
    final on = switch (level) {
      >= 3 => const Color(0xFFB23A28),
      2 => const Color(0xFFB0691F),
      _ => const Color(0xFFC7A94A),
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

class _BulletBlock extends StatelessWidget {
  const _BulletBlock({
    required this.title,
    required this.icon,
    required this.lines,
    this.accent,
  });
  final String title;
  final IconData icon;
  final List<String> lines;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = accent ?? theme.colorScheme.onSurfaceVariant;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: c),
            const SizedBox(width: 6),
            Text(
              title.toUpperCase(),
              style: theme.textTheme.labelSmall?.copyWith(
                color: c,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        for (final line in lines)
          Padding(
            padding: const EdgeInsets.only(bottom: 3),
            child: Text(
              '·  $line',
              style: const TextStyle(fontSize: 12.5, height: 1.4),
            ),
          ),
      ],
    );
  }
}

class _ClearList extends StatelessWidget {
  const _ClearList({required this.doshas});
  final List<Dosha> doshas;

  @override
  Widget build(BuildContext context) {
    if (doshas.isEmpty) return const SizedBox.shrink();
    final l = context.l10n;
    return Card(
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16),
          title: Text(
            l.doshaClearSectionTitle,
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          childrenPadding: const EdgeInsets.only(bottom: 8),
          children: [
            for (final d in doshas)
              ListTile(
                dense: true,
                visualDensity: VisualDensity.compact,
                leading: Icon(
                  Icons.check_circle_outline_rounded,
                  size: 18,
                  color: context.brand.online,
                ),
                title: Text(
                  doshaName(l, d),
                  style: const TextStyle(fontSize: 13),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────── yogas

class _YogasTab extends StatelessWidget {
  const _YogasTab();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return BlocBuilder<KundaliCubit, KundaliState>(
      buildWhen: (a, b) => a.yogas != b.yogas,
      builder: (context, state) => SliceBuilder<List<Yoga>>(
        slice: state.yogas,
        onRetry: () => context.read<KundaliCubit>().loadYogas(),
        builder: (context, yogas) => ListView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
          children: [
            Text(
              l.yogaIntro,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 14),
            if (yogas.isEmpty)
              KCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l.yogaNoneTitle,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l.yogaNoneBody,
                      style: const TextStyle(fontSize: 13, height: 1.4),
                    ),
                  ],
                ),
              )
            else
              for (final y in yogas) ...[
                _YogaCard(yoga: y),
                const SizedBox(height: 10),
              ],
            const SizedBox(height: 8),
            KCard(
              tint: true,
              child: Column(
                children: [
                  Text(
                    l.kundaliHowItPlaysOut,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  AskAstrologerBar(
                    label: l.kundaliTalkToAstrologer,
                    onTap: () => context.go(Routes.astrologers),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _YogaCard extends StatelessWidget {
  const _YogaCard({required this.yoga});
  final Yoga yoga;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = context.l10n;
    final meaning = yogaMeaning(l, yoga.key);
    return KCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            yogaName(l, yoga.key, yoga.name),
            style: theme.textTheme.titleMedium?.copyWith(fontSize: 15),
          ),
          if (yoga.planets.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              yoga.planets.map((p) => KTerms.displayName(l, p)).join(' · '),
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          if (meaning.isNotEmpty || yoga.description.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              meaning.isNotEmpty ? meaning : yoga.description,
              style: const TextStyle(fontSize: 13, height: 1.4),
            ),
          ],
        ],
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
