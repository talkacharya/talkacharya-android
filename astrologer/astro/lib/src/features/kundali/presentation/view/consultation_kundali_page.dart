import 'package:astro_kundali/astro_kundali.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/util/async_value.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../data/kundali_repository.dart';
import '../cubit/kundali_cubit.dart';

/// The client's full kundali during a consultation — charts + planets + dasha
/// + yogas + bhava + advanced strengths. All read consultation-scoped from the
/// birth profile the customer shared.
class ConsultationKundaliPage extends StatelessWidget {
  const ConsultationKundaliPage({
    required this.consultationId,
    this.clientName,
    super.key,
  });
  final String consultationId;
  final String? clientName;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => KundaliCubit(
        repo: getIt<KundaliRepository>(),
        consultationId: consultationId,
      )..loadOverview(),
      child: _View(consultationId: consultationId, clientName: clientName),
    );
  }
}

const _essentials = <String>[
  'd1',
  'moon',
  'd9',
  'd10',
  'd7',
  'bhava_chalit',
  'transit',
];

class _View extends StatelessWidget {
  const _View({required this.consultationId, this.clientName});
  final String consultationId;
  final String? clientName;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 11,
      child: Scaffold(
        appBar: AppBar(
          title: Text(clientName == null ? 'Kundali' : "$clientName's kundali"),
          bottom: const TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(text: 'Charts'),
              Tab(text: 'Planets'),
              Tab(text: 'Dasha'),
              Tab(text: 'Yogas'),
              Tab(text: 'Doshas'),
              Tab(text: 'Overview'),
              Tab(text: 'Remedies'),
              Tab(text: 'Bhava'),
              Tab(text: 'Gochar'),
              Tab(text: 'Numbers'),
              Tab(text: 'Advanced'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _ChartsTab(consultationId: consultationId),
            const _PlanetsTab(),
            const _DashaTab(),
            const _YogasTab(),
            const _DoshasTab(),
            const _OverviewTab(),
            const _RemediesTab(),
            const _BhavaTab(),
            const _SadeSatiTab(),
            const _NumerologyTab(),
            const _AdvancedTab(),
          ],
        ),
      ),
    );
  }
}

/// Renders one [AsyncValue] slice: spinner while first loading, [ErrorView] on
/// failure with nothing cached, else the data.
class _Slice<T> extends StatelessWidget {
  const _Slice({
    required this.slice,
    required this.onRetry,
    required this.builder,
  });
  final AsyncValue<T> slice;
  final VoidCallback onRetry;
  final Widget Function(T value) builder;

  @override
  Widget build(BuildContext context) => slice.when(
    idle: () => const Center(child: CircularProgressIndicator()),
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (m) => ErrorView(message: m, onRetry: onRetry),
    data: builder,
  );
}

// --- Charts -----------------------------------------------------------------

class _ChartsTab extends StatefulWidget {
  const _ChartsTab({required this.consultationId});
  final String consultationId;

  @override
  State<_ChartsTab> createState() => _ChartsTabState();
}

class _ChartsTabState extends State<_ChartsTab>
    with AutomaticKeepAliveClientMixin {
  final _pc = PageController();
  int _page = 0;
  ChartStyle _style = ChartStyle.north;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<KundaliCubit>()..loadChartTypes();
    for (final t in _essentials) {
      cubit.loadChart(t);
    }
  }

  @override
  void dispose() {
    _pc.dispose();
    super.dispose();
  }

  void _openPicker(List<ChartTypeInfo> menu) {
    showChartPicker(
      context,
      menu: menu,
      selected: _essentials[_page],
      onPick: (t) {
        Navigator.of(context).pop();
        context.push(
          '/consultations/${widget.consultationId}/kundali/chart/$t',
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final wheelH = MediaQuery.sizeOf(context).width - 20;

    return BlocBuilder<KundaliCubit, KundaliState>(
      builder: (context, state) {
        final menu = state.chartTypes.value ?? const <ChartTypeInfo>[];
        final currentType = _essentials[_page];
        final current =
            state.charts[currentType] ?? const AsyncValue<VargaChart>.idle();

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
          children: [
            SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _essentials.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, i) {
                  final on = i == _page;
                  final scheme = Theme.of(context).colorScheme;
                  return ChoiceChip(
                    label: Text(chartShortLabel(_essentials[i])),
                    selected: on,
                    showCheckmark: false,
                    labelStyle: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: on ? scheme.onPrimary : scheme.onSurfaceVariant,
                    ),
                    selectedColor: scheme.primary,
                    onSelected: (_) => _pc.animateToPage(
                      i,
                      duration: const Duration(milliseconds: 240),
                      curve: Curves.easeOut,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            ChartStyleToggle(
              style: _style,
              onChanged: (s) => setState(() => _style = s),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: wheelH,
              child: PageView.builder(
                controller: _pc,
                itemCount: _essentials.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (context, i) {
                  final t = _essentials[i];
                  final slice =
                      state.charts[t] ?? const AsyncValue<VargaChart>.idle();
                  return ChartWheel(
                    chart: slice.value,
                    error: slice.status == AsyncStatus.error
                        ? slice.error
                        : null,
                    style: _style,
                    onRetry: () =>
                        context.read<KundaliCubit>().loadChart(t, force: true),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            if (current.value != null) ...[
              ChartDetails(
                vc: current.value!,
                fallbackTitle: chartShortLabel(currentType),
              ),
              const SizedBox(height: 14),
              PlanetTable(vc: current.value!),
            ] else if (current.status == AsyncStatus.error)
              ChartBanner(
                icon: Icons.error_outline_rounded,
                text: current.error ?? 'Could not load this chart',
              ),
            const SizedBox(height: 14),
            FilledButton.tonalIcon(
              onPressed: menu.isEmpty ? null : () => _openPicker(menu),
              icon: const Icon(Icons.grid_view_rounded, size: 18),
              label: const Text('All charts — D1 to D60'),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
            ),
            const SizedBox(height: 16),
            const ChartLegend(),
          ],
        );
      },
    );
  }
}

// --- Planets --------------------------------------------------------------

class _PlanetsTab extends StatefulWidget {
  const _PlanetsTab();
  @override
  State<_PlanetsTab> createState() => _PlanetsTabState();
}

class _PlanetsTabState extends State<_PlanetsTab> {
  @override
  void initState() {
    super.initState();
    context.read<KundaliCubit>().loadOverview();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KundaliCubit, KundaliState>(
      builder: (context, state) => _Slice<Kundali>(
        slice: state.overview,
        onRetry: () => context.read<KundaliCubit>().loadOverview(),
        builder: (k) {
          final scheme = Theme.of(context).colorScheme;
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  KundaliChip('Lagna · ${k.lagnaSign}'),
                  KundaliChip('Moon · ${k.moonSign}'),
                  KundaliChip('Sun · ${k.sunSign}'),
                  if (k.nakshatra.isNotEmpty)
                    KundaliChip('Nakshatra · ${k.nakshatra}'),
                ],
              ),
              const SizedBox(height: 14),
              KundaliCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                child: Column(
                  children: [
                    for (final p in k.planets) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 9),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 78,
                              child: Row(
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: planetColor(p.name),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    p.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12.5,
                                    ),
                                  ),
                                  if (p.retrograde)
                                    const Text(
                                      ' ℞',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '${p.sign}  ${p.degree.toStringAsFixed(1)}°',
                                style: const TextStyle(fontSize: 12.5),
                              ),
                            ),
                            SizedBox(
                              width: 42,
                              child: Text(
                                'H${p.house}',
                                textAlign: TextAlign.end,
                                style: const TextStyle(fontSize: 12.5),
                              ),
                            ),
                            SizedBox(
                              width: 74,
                              child: Text(
                                p.dignity,
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  fontSize: 11,
                                  color:
                                      p.dignity == 'exalted' ||
                                          p.dignity == 'own' ||
                                          p.dignity == 'moolatrikona'
                                      ? scheme.primary
                                      : p.dignity == 'debilitated'
                                      ? scheme.error
                                      : scheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (p != k.planets.last)
                        Divider(height: 1, color: scheme.outlineVariant),
                    ],
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// --- Dasha ---------------------------------------------------------------

class _DashaTab extends StatefulWidget {
  const _DashaTab();
  @override
  State<_DashaTab> createState() => _DashaTabState();
}

class _DashaTabState extends State<_DashaTab> {
  @override
  void initState() {
    super.initState();
    context.read<KundaliCubit>()
      ..loadDasha()
      ..loadDashaNarrative();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KundaliCubit, KundaliState>(
      builder: (context, state) => _Slice<DashaTimeline>(
        slice: state.dasha,
        onRetry: () => context.read<KundaliCubit>().loadDasha(),
        builder: (d) {
          final now = DateTime.now();
          final narrative = state.dashaNarrative.value;
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  KundaliChip('Running · ${d.currentMaha} / ${d.currentAntar}'),
                  if (d.balanceLord.isNotEmpty)
                    KundaliChip(
                      'Balance · ${d.balanceLord} '
                      '${d.balanceYears.toStringAsFixed(1)}y',
                    ),
                ],
              ),
              const SizedBox(height: 12),
              for (final maha in d.periods)
                KundaliCard(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  child: ExpansionTile(
                    tilePadding: EdgeInsets.zero,
                    childrenPadding: const EdgeInsets.only(bottom: 8),
                    initiallyExpanded: maha.contains(now),
                    title: Text(
                      '${maha.lord}  ·  ${_y(maha.start)}–${_y(maha.end)}',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13.5,
                        color: maha.contains(now)
                            ? Theme.of(context).colorScheme.primary
                            : null,
                      ),
                    ),
                    children: [
                      if ((narrative?.mahaFor(maha.lord)?.summary ?? '')
                          .isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Text(
                            narrative!.mahaFor(maha.lord)!.summary,
                            style: const TextStyle(fontSize: 11.5, height: 1.4),
                          ),
                        ),
                      for (final antar in maha.children)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  antar.lord,
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: antar.contains(now)
                                        ? FontWeight.w700
                                        : FontWeight.w400,
                                  ),
                                ),
                              ),
                              Text(
                                '${_d(antar.start)} – ${_d(antar.end)}',
                                style: const TextStyle(fontSize: 11.5),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  String _y(DateTime d) => '${d.year}';
  String _d(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
}

// --- Yogas -------------------------------------------------------------

class _YogasTab extends StatefulWidget {
  const _YogasTab();
  @override
  State<_YogasTab> createState() => _YogasTabState();
}

class _YogasTabState extends State<_YogasTab> {
  @override
  void initState() {
    super.initState();
    context.read<KundaliCubit>().loadYogas();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KundaliCubit, KundaliState>(
      builder: (context, state) => _Slice<List<Yoga>>(
        slice: state.yogas,
        onRetry: () => context.read<KundaliCubit>().loadYogas(),
        builder: (yogas) {
          if (yogas.isEmpty) {
            return const Center(child: Text('No notable yogas found.'));
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
            children: [
              for (final y in yogas)
                KundaliCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              y.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13.5,
                              ),
                            ),
                          ),
                          if (y.type.isNotEmpty) KundaliChip(y.type),
                        ],
                      ),
                      if (y.planets.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          y.planets.join(' · '),
                          style: TextStyle(
                            fontSize: 11.5,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                      if (y.description.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          y.description,
                          style: const TextStyle(fontSize: 12.5, height: 1.4),
                        ),
                      ],
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

// --- Doshas ----------------------------------------------------------

class _DoshasTab extends StatefulWidget {
  const _DoshasTab();
  @override
  State<_DoshasTab> createState() => _DoshasTabState();
}

class _DoshasTabState extends State<_DoshasTab> {
  @override
  void initState() {
    super.initState();
    context.read<KundaliCubit>().loadDoshas();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KundaliCubit, KundaliState>(
      builder: (context, state) => _Slice<DoshaReport>(
        slice: state.doshas,
        onRetry: () => context.read<KundaliCubit>().loadDoshas(),
        builder: (report) => ListView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
          children: [
            Text(
              '${report.count} present of ${report.doshas.length} checked · '
              'structural only, cancellations flagged.',
              style: TextStyle(
                fontSize: 11.5,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            for (final d in [...report.present, ...report.clear])
              _DoshaRow(dosha: d),
          ],
        ),
      ),
    );
  }
}

class _DoshaRow extends StatelessWidget {
  const _DoshaRow({required this.dosha});
  final Dosha dosha;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    final sev = dosha.displaySeverity;
    final (chipText, chipColor) = !dosha.present
        ? ('clear', const Color(0xFF1E7A3C))
        : dosha.isCancelled || sev == 0
        ? ('cancelled', muted)
        : sev >= 3
        ? ('strong', const Color(0xFFB23A28))
        : sev == 2
        ? ('moderate', const Color(0xFFB0691F))
        : ('mild', const Color(0xFF8A7A32));

    return Opacity(
      opacity: dosha.present ? 1 : 0.6,
      child: KundaliCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    dosha.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13.5,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: chipColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    chipText,
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                      color: chipColor,
                    ),
                  ),
                ),
              ],
            ),
            if (dosha.present) ...[
              if (dosha.kaalSarpaType.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  '${dosha.kaalSarpaType}${dosha.partial ? " · partial" : ""}',
                  style: TextStyle(fontSize: 11.5, color: muted),
                ),
              ],
              const SizedBox(height: 6),
              for (final r in dosha.reasons)
                Text(
                  '· ${r.text}',
                  style: const TextStyle(fontSize: 12, height: 1.35),
                ),
              if (dosha.cancellations.isNotEmpty) ...[
                const SizedBox(height: 6),
                for (final c in dosha.cancellations)
                  Text(
                    '${c.applies ? "✓" : "✗"} ${c.text}',
                    style: TextStyle(
                      fontSize: 11.5,
                      height: 1.35,
                      color: c.applies ? const Color(0xFF1E7A3C) : muted,
                    ),
                  ),
              ],
            ] else if (dosha.summary.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                dosha.summary,
                style: TextStyle(fontSize: 11.5, color: muted),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// --- Overview (free D1 "phala" sketch) -------------------------------

class _OverviewTab extends StatefulWidget {
  const _OverviewTab();
  @override
  State<_OverviewTab> createState() => _OverviewTabState();
}

class _OverviewTabState extends State<_OverviewTab> {
  @override
  void initState() {
    super.initState();
    context.read<KundaliCubit>().loadInsights();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KundaliCubit, KundaliState>(
      builder: (context, state) => _Slice<OverviewReport>(
        slice: state.insights,
        onRetry: () => context.read<KundaliCubit>().loadInsights(),
        builder: (report) {
          final ordered = [
            for (final area in KundaliInsights.areaOrder)
              ?report.byArea(area),
          ];
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
            children: [
              Text(
                'Descriptive D1 read — the free "at a glance" the client also '
                'sees. Tendencies, not a forecast.',
                style: TextStyle(
                  fontSize: 11.5,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              for (final s in ordered) _OverviewSectionRow(section: s),
              if (report.disclaimer.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  report.disclaimer,
                  style: TextStyle(
                    fontSize: 10.5,
                    height: 1.35,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _OverviewSectionRow extends StatelessWidget {
  const _OverviewSectionRow({required this.section});
  final OverviewSection section;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    final (chipText, chipColor) = switch (section.tone) {
      'supportive' => ('supportive', const Color(0xFF1E7A3C)),
      'challenging' => ('needs care', const Color(0xFFB0691F)),
      'mixed' => ('mixed', const Color(0xFF3F4E86)),
      _ => ('balanced', muted),
    };
    final factors = section.readingFactors
        .map(KundaliInsights.factorText)
        .where((t) => t.isNotEmpty)
        .toList();

    return KundaliCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(KundaliInsights.icon(section.area), size: 15, color: muted),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  KundaliInsights.title(section.area),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13.5,
                  ),
                ),
              ),
              Text(
                '${section.strength}/3',
                style: TextStyle(fontSize: 10.5, color: muted),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: chipColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  chipText,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: chipColor,
                  ),
                ),
              ),
            ],
          ),
          if (section.summary.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              section.summary,
              style: const TextStyle(fontSize: 12, height: 1.4),
            ),
          ],
          if (factors.isNotEmpty) ...[
            const SizedBox(height: 6),
            for (final line in factors)
              Text(
                '· $line',
                style: TextStyle(fontSize: 11, height: 1.35, color: muted),
              ),
          ],
        ],
      ),
    );
  }
}

// --- Sade Sati ----------------------------------------------------

class _SadeSatiTab extends StatefulWidget {
  const _SadeSatiTab();
  @override
  State<_SadeSatiTab> createState() => _SadeSatiTabState();
}

class _SadeSatiTabState extends State<_SadeSatiTab> {
  @override
  void initState() {
    super.initState();
    context.read<KundaliCubit>()
      ..loadSadeSati()
      ..loadAvTransit()
      ..loadMuhurta()
      ..loadVarshphal();
  }

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    String range(String a, String b) => '$a → $b';
    return BlocBuilder<KundaliCubit, KundaliState>(
      builder: (context, state) => _Slice<SadeSatiCalendar>(
        slice: state.sadeSati,
        onRetry: () => context.read<KundaliCubit>().loadSadeSati(),
        builder: (cal) => ListView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
          children: [
            Text(
              'Dated Saturn windows from the natal Moon (${cal.natalMoonSign}). '
              'Same view the client sees.',
              style: TextStyle(fontSize: 11.5, color: muted),
            ),
            const SizedBox(height: 10),
            if (cal.summary.isNotEmpty)
              KundaliCard(
                child: Text(
                  cal.summary,
                  style: const TextStyle(fontSize: 12, height: 1.4),
                ),
              ),
            for (final period in cal.sadeSatiPeriods)
              KundaliCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sade Sati · ${period.signs.join(" → ")}'
                      '${period.running ? "  · running" : ""}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12.5,
                      ),
                    ),
                    Text(
                      range(period.start, period.end),
                      style: TextStyle(fontSize: 10.5, color: muted),
                    ),
                    const SizedBox(height: 4),
                    for (final ph in period.phases)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 3),
                        child: Text(
                          '· ${ph.phase} (${range(ph.start, ph.end)}) — '
                          '${ph.summary}',
                          style: TextStyle(
                            fontSize: 10.5,
                            height: 1.35,
                            color: muted,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            for (final d in cal.dhaiyaPeriods)
              KundaliCard(
                child: Text(
                  'Dhaiya · ${d.phase} (${range(d.start, d.end)})'
                  '${d.running ? "  · running" : ""} — ${d.summary}',
                  style: const TextStyle(fontSize: 11, height: 1.4),
                ),
              ),
            const _VarshphalBlock(),
            const _AvTransitBlock(),
            const _MuhurtaBlock(),
          ],
        ),
      ),
    );
  }
}

class _VarshphalBlock extends StatelessWidget {
  const _VarshphalBlock();

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    return BlocBuilder<KundaliCubit, KundaliState>(
      buildWhen: (a, b) => a.varshphal != b.varshphal,
      builder: (context, state) {
        final v = state.varshphal.value;
        if (v == null) return const SizedBox.shrink();
        return KundaliCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Varshphal — age ${v.age} (${v.starts} → ${v.ends})',
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
              ),
              const SizedBox(height: 3),
              Text(
                'Varsha Lagna ${v.varshaLagna} · Muntha ${v.munthaSign} H${v.munthaHouse} · '
                'year lord ${v.yearLord} (H${v.yearLordHouse}, ${v.yearLordDignity})',
                style: TextStyle(fontSize: 10.5, height: 1.35, color: muted),
              ),
              if (v.summary.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  v.summary,
                  style: const TextStyle(fontSize: 10.5, height: 1.4),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _MuhurtaBlock extends StatelessWidget {
  const _MuhurtaBlock();

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    return BlocBuilder<KundaliCubit, KundaliState>(
      buildWhen: (a, b) => a.muhurta != b.muhurta,
      builder: (context, state) {
        final d = state.muhurta.value;
        if (d == null || !d.available) return const SizedBox.shrink();
        return KundaliCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Today's timing — ${d.weekday} (${d.dayLord}), "
                '${d.sunrise}/${d.sunset}',
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
              ),
              if (d.summary.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  d.summary,
                  style: const TextStyle(fontSize: 11, height: 1.4),
                ),
              ],
              const SizedBox(height: 4),
              for (final w in d.bestWindows)
                Text(
                  '· ${w.summary}',
                  style: TextStyle(fontSize: 10.5, height: 1.35, color: muted),
                ),
              if (d.abhijit != null)
                Text(
                  '· ${d.abhijit!.summary}',
                  style: TextStyle(fontSize: 10.5, height: 1.35, color: muted),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _AvTransitBlock extends StatelessWidget {
  const _AvTransitBlock();

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    return BlocBuilder<KundaliCubit, KundaliState>(
      buildWhen: (a, b) => a.avTransit != b.avTransit,
      builder: (context, state) {
        final r = state.avTransit.value;
        if (r == null) return const SizedBox.shrink();
        return KundaliCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ashtakavarga transit reading',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
              ),
              const SizedBox(height: 6),
              for (final row in r.transits)
                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    '· ${row.planet} ${row.sign} H${row.houseFromLagna} — '
                    '${row.bindus}/8${row.retrograde ? " R" : ""} · ${row.tone}',
                    style: TextStyle(fontSize: 10.5, height: 1.35, color: muted),
                  ),
                ),
              for (final u in r.upcomingIngresses)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    '→ ${u.summary}',
                    style: TextStyle(fontSize: 10.5, height: 1.35, color: muted),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

// --- Numerology ----------------------------------------------------

class _NumerologyTab extends StatefulWidget {
  const _NumerologyTab();
  @override
  State<_NumerologyTab> createState() => _NumerologyTabState();
}

class _NumerologyTabState extends State<_NumerologyTab> {
  @override
  void initState() {
    super.initState();
    context.read<KundaliCubit>().loadNumerology();
  }

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    return BlocBuilder<KundaliCubit, KundaliState>(
      builder: (context, state) => _Slice<NumerologyReport>(
        slice: state.numerology,
        onRetry: () => context.read<KundaliCubit>().loadNumerology(),
        builder: (report) => ListView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
          children: [
            Text(
              'DOB numerology + Lo Shu grid — the same view the client sees. '
              'Traditional; gemstones are gated.',
              style: TextStyle(fontSize: 11.5, color: muted),
            ),
            const SizedBox(height: 12),
            for (final n in report.numbers)
              KundaliCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${n.kind[0].toUpperCase()}${n.kind.substring(1)} · '
                      '${n.value}  (${n.planet})',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                    if (n.summary.isNotEmpty) ...[
                      const SizedBox(height: 5),
                      Text(
                        n.summary,
                        style: const TextStyle(fontSize: 12, height: 1.4),
                      ),
                    ],
                    const SizedBox(height: 5),
                    Text(
                      'Friendly ${n.friendly.join(", ")} · clashing '
                      '${n.unfriendly.join(", ")} · days ${n.days.join(", ")} · '
                      'colours ${n.colours.join(", ")}',
                      style: TextStyle(fontSize: 10.5, height: 1.35, color: muted),
                    ),
                    if (n.gemstone.isNotEmpty)
                      Text(
                        'Gemstone (gated): ${n.gemstone} — ${n.gemstoneNote}',
                        style: const TextStyle(
                          fontSize: 10.5,
                          height: 1.35,
                          color: Color(0xFFB0691F),
                        ),
                      ),
                  ],
                ),
              ),
            if (report.combination.isNotEmpty)
              KundaliCard(
                child: Text(
                  report.combination,
                  style: const TextStyle(fontSize: 12, height: 1.4),
                ),
              ),
            KundaliCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Lo Shu birth grid',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      for (final line
                          in report.loShu.lines.where(
                            (x) => x.status != 'partial',
                          ))
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color:
                                (line.status == 'strength'
                                        ? const Color(0xFF1E7A3C)
                                        : const Color(0xFFB0691F))
                                    .withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            '${line.status == "strength" ? "✓" : "–"} ${line.name}',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: line.status == 'strength'
                                  ? const Color(0xFF1E7A3C)
                                  : const Color(0xFFB0691F),
                            ),
                          ),
                        ),
                    ],
                  ),
                  if (report.loShu.summary.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      report.loShu.summary,
                      style: TextStyle(fontSize: 11, height: 1.4, color: muted),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Remedies -------------------------------------------------------

class _RemediesTab extends StatefulWidget {
  const _RemediesTab();
  @override
  State<_RemediesTab> createState() => _RemediesTabState();
}

class _RemediesTabState extends State<_RemediesTab> {
  @override
  void initState() {
    super.initState();
    context.read<KundaliCubit>()
      ..loadRemedies()
      ..loadJyotishUpaya()
      ..loadLalKitab();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KundaliCubit, KundaliState>(
      builder: (context, state) => _Slice<RemedyReport>(
        slice: state.remedies,
        onRetry: () => context.read<KundaliCubit>().loadRemedies(),
        builder: (report) => ListView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
          children: [
            Text(
              '${report.count} remedies matched to this chart\'s doshas, weak '
              'planets, dasha and afflicted houses. Gemstone / yantra / rudraksha '
              'entries are flagged — confirm before advising them.',
              style: TextStyle(
                fontSize: 11.5,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            for (final group in report.groups) ...[
              Text(
                RemedyCategoryInfo.label(group.category).toUpperCase(),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 6),
              for (final r in group.items) _RemedyRow(remedy: r),
              const SizedBox(height: 10),
            ],
            const _UpayaBlock(),
            const _LalKitabBlock(),
          ],
        ),
      ),
    );
  }
}

class _LalKitabBlock extends StatelessWidget {
  const _LalKitabBlock();

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    return BlocBuilder<KundaliCubit, KundaliState>(
      buildWhen: (a, b) => a.lalKitab != b.lalKitab,
      builder: (context, state) {
        final r = state.lalKitab.value;
        if (r == null) return const SizedBox.shrink();
        return KundaliCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Lal Kitab — rin & totke',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
              ),
              if (r.summary.isNotEmpty) ...[
                const SizedBox(height: 3),
                Text(
                  r.summary,
                  style: TextStyle(fontSize: 10.5, height: 1.35, color: muted),
                ),
              ],
              const SizedBox(height: 5),
              for (final rin in r.activeRins)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    '· ${rin.name}\n  ${rin.remedy}',
                    style: const TextStyle(fontSize: 10.5, height: 1.4),
                  ),
                ),
              for (final m in r.mandaPlanets)
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text(
                    '· ${m.summary} — ${m.remedy}',
                    style: TextStyle(fontSize: 10.5, height: 1.35, color: muted),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _UpayaBlock extends StatelessWidget {
  const _UpayaBlock();

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    return BlocBuilder<KundaliCubit, KundaliState>(
      buildWhen: (a, b) => a.jyotishUpaya != b.jyotishUpaya,
      builder: (context, state) {
        final r = state.jyotishUpaya.value;
        if (r == null) return const SizedBox.shrink();
        return KundaliCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Upaya table — ${r.lagnaSign} lagna (${r.lagnaLord})',
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
              ),
              const SizedBox(height: 2),
              Text(
                'Support: ${r.strengthen.join(", ")} · Pacify: ${r.pacify.join(", ")}'
                '${r.priorityPlanets.isNotEmpty ? " · Priority: ${r.priorityPlanets.join(", ")}" : ""}',
                style: TextStyle(fontSize: 10.5, height: 1.35, color: muted),
              ),
              const SizedBox(height: 6),
              for (final p in r.planets)
                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    '· ${p.planet} (${p.role}) — ${p.mantra}; gem ${p.gemstone} '
                    '(gated), rudraksha ${p.rudrakshaMukhi} (gated)',
                    style: TextStyle(fontSize: 10.5, height: 1.35, color: muted),
                  ),
                ),
              const SizedBox(height: 4),
              Text(
                r.gateNotice,
                style: const TextStyle(
                  fontSize: 10,
                  height: 1.35,
                  color: Color(0xFFB0691F),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _RemedyRow extends StatelessWidget {
  const _RemedyRow({required this.remedy});
  final Remedy remedy;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    return KundaliCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  remedy.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
              if (remedy.gated)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFB0691F).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text(
                    'confirm first',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFFB0691F),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(remedy.body, style: const TextStyle(fontSize: 12, height: 1.4)),
          if (remedy.caution.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              '⚠ ${remedy.caution}',
              style: const TextStyle(
                fontSize: 11,
                height: 1.35,
                color: Color(0xFFB0691F),
              ),
            ),
          ],
          const SizedBox(height: 2),
          Text(
            '${remedy.triggerType}:${remedy.triggerValue} · ${remedy.source}',
            style: TextStyle(fontSize: 10, color: muted),
          ),
        ],
      ),
    );
  }
}

// --- Bhava -----------------------------------------------------------

class _BhavaTab extends StatefulWidget {
  const _BhavaTab();
  @override
  State<_BhavaTab> createState() => _BhavaTabState();
}

class _BhavaTabState extends State<_BhavaTab> {
  @override
  void initState() {
    super.initState();
    context.read<KundaliCubit>().loadBhava();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KundaliCubit, KundaliState>(
      builder: (context, state) => _Slice<List<BhavaHouse>>(
        slice: state.bhava,
        onRetry: () => context.read<KundaliCubit>().loadBhava(),
        builder: (houses) {
          final scheme = Theme.of(context).colorScheme;
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
            children: [
              for (final h in houses)
                KundaliCard(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 13,
                            backgroundColor: scheme.primaryContainer,
                            child: Text(
                              '${h.house}',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: scheme.onPrimaryContainer,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${h.sign}  ·  lord ${h.lord}'
                            '${h.lordSign.isNotEmpty ? " in ${h.lordSign} (H${h.lordHouse})" : ""}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Occupants: ${h.occupants.isEmpty ? "—" : h.occupants.join(", ")}'
                        '${h.aspectedBy.isEmpty ? "" : "    Aspected by: ${h.aspectedBy.join(", ")}"}'
                        '${h.karaka.isNotEmpty ? "    Karaka: ${h.karaka}" : ""}',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                      if (h.beneficCount > 0 || h.maleficCount > 0)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            '+${h.beneficCount} benefic   −${h.maleficCount} malefic',
                            style: const TextStyle(fontSize: 11),
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

// --- Advanced (ashtakavarga + shadbala + KP + Jaimini) ------------------

class _AdvancedTab extends StatefulWidget {
  const _AdvancedTab();
  @override
  State<_AdvancedTab> createState() => _AdvancedTabState();
}

class _AdvancedTabState extends State<_AdvancedTab> {
  @override
  void initState() {
    super.initState();
    context.read<KundaliCubit>()
      ..loadAshtakavarga()
      ..loadShadbala()
      ..loadKp()
      ..loadJaimini();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return BlocBuilder<KundaliCubit, KundaliState>(
      builder: (context, state) {
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
          children: [
            const KundaliLabel('Sarvashtakavarga (bindus by house)'),
            const SizedBox(height: 8),
            _Slice<Ashtakavarga>(
              slice: state.ashtakavarga,
              onRetry: () => context.read<KundaliCubit>().loadAshtakavarga(),
              builder: (a) => KundaliCard(
                child: Wrap(
                  spacing: 10,
                  runSpacing: 8,
                  children: [
                    for (var h = 1; h <= 12; h++)
                      Column(
                        children: [
                          Text(
                            '${a.sarvaByHouse['$h'] ?? 0}',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: (a.sarvaByHouse['$h'] ?? 0) >= 30
                                  ? scheme.primary
                                  : (a.sarvaByHouse['$h'] ?? 0) <= 25
                                  ? scheme.error
                                  : null,
                            ),
                          ),
                          Text('H$h', style: const TextStyle(fontSize: 10)),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            const KundaliLabel('Shadbala (rupa / required)'),
            const SizedBox(height: 8),
            _Slice<Shadbala>(
              slice: state.shadbala,
              onRetry: () => context.read<KundaliCubit>().loadShadbala(),
              builder: (s) => KundaliCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                child: Column(
                  children: [
                    for (final p in s.planets)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 72,
                              child: Text(
                                p.name,
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Expanded(
                              child: LinearProgressIndicator(
                                value: p.ratio.clamp(0, 2) / 2,
                                minHeight: 6,
                                backgroundColor: scheme.surfaceContainerHighest,
                                color: p.isStrong
                                    ? scheme.primary
                                    : scheme.error,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '${p.totalRupa.toStringAsFixed(1)} / '
                              '${p.requiredRupa.toStringAsFixed(1)}',
                              style: const TextStyle(fontSize: 11.5),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            const KundaliLabel('KP significators'),
            const SizedBox(height: 8),
            _Slice<Map<String, dynamic>>(
              slice: state.kp,
              onRetry: () => context.read<KundaliCubit>().loadKp(),
              builder: (kp) => KundaliCard(child: _KeyValues(kp)),
            ),
            const SizedBox(height: 18),
            const KundaliLabel('Jaimini (karakas, arudhas)'),
            const SizedBox(height: 8),
            _Slice<Map<String, dynamic>>(
              slice: state.jaimini,
              onRetry: () => context.read<KundaliCubit>().loadJaimini(),
              builder: (j) => KundaliCard(child: _KeyValues(j)),
            ),
          ],
        );
      },
    );
  }
}

/// Flattens a small map into `key: value` rows (one level; nested maps/lists
/// are shown compactly). Used for the KP / Jaimini raw sections.
class _KeyValues extends StatelessWidget {
  const _KeyValues(this.data);
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    String fmt(Object? v) {
      if (v is Map) {
        return v.entries.map((e) => '${e.key}: ${e.value}').join(', ');
      }
      if (v is List) return v.join(', ');
      return '$v';
    }

    final entries = data.entries.where((e) => e.key != 'engine').toList();
    if (entries.isEmpty) {
      return const Text('No data', style: TextStyle(fontSize: 12.5));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final e in entries)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 110,
                  child: Text(
                    e.key.replaceAll('_', ' '),
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    fmt(e.value),
                    style: const TextStyle(fontSize: 11.5),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
