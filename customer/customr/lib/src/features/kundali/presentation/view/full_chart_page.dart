import 'package:astro_kundali/astro_kundali.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/astro_palette.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../../core/util/async_value.dart';
import '../../../../shared/widgets/language_quick_button.dart';
import '../cubit/kundali_cubit.dart';
import '../widgets/k_chart.dart';
import '../widgets/kundali_ui.dart';
import 'house_detail_sheet.dart';
import 'kundali_routes.dart';

/// The birth-chart screen. Swipe (or tap a chip in the hero) between the charts
/// people ask about most — all pre-fetched, so there's no reload. "All charts"
/// opens the full D1–D60 menu.
class FullChartPage extends StatefulWidget {
  const FullChartPage({required this.profileId, this.initialHouse, super.key});
  final String profileId;
  final int? initialHouse;

  /// The essentials, in reading order: Lagna, Moon, then the vargas people ask
  /// about, then Bhava Chalit and the live transit.
  static const essentials = <String>[
    'd1',
    'moon',
    'd9',
    'd10',
    'd7',
    'bhava_chalit',
    'transit',
  ];

  @override
  State<FullChartPage> createState() => _FullChartPageState();
}

class _FullChartPageState extends State<FullChartPage> {
  final _pc = PageController();
  int _page = 0;
  ChartStyle _style = ChartStyle.north;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<KundaliCubit>()
      ..loadOverview()
      ..loadChartTypes();
    for (final t in FullChartPage.essentials) {
      cubit.loadChart(t);
    }
    if (widget.initialHouse != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final k = context.read<KundaliCubit>().state.overview.value;
        if (k != null && mounted) {
          showHouseDetailSheet(
            context,
            kundali: k,
            house: widget.initialHouse!,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _pc.dispose();
    super.dispose();
  }

  void _goTo(int i) {
    setState(() => _page = i);
    _pc.animateToPage(
      i,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  void _openPicker(List<ChartTypeInfo> menu) {
    showKChartPicker(
      context,
      menu: menu,
      selected: FullChartPage.essentials[_page],
      onPick: (t) {
        Navigator.of(context).pop();
        context.push(KundaliRoutes.chartDetail(widget.profileId, t));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final s = KundaliStrings.of(context);

    return BlocBuilder<KundaliCubit, KundaliState>(
      builder: (context, state) {
        final menu = state.chartTypes.value ?? const <ChartTypeInfo>[];
        final type = FullChartPage.essentials[_page];
        final slice = state.charts[type] ?? const AsyncValue<VargaChart>.idle();
        final vc = slice.value;
        final lagna = state.overview.value?.lagnaSign ?? vc?.ascendantSign;
        final hue = kSignHue(lagna ?? '');
        final title = vc == null
            ? s.chartShortLabel(type)
            : s.chartName(
                type,
                vc.name.isEmpty ? s.chartShortLabel(type) : vc.name,
              );
        final signifies = vc == null
            ? null
            : s.chartSignifies(type, vc.signifies);

        return KundaliScaffold(
          title: l.kFcTitle,
          eyebrow: l.kFcTitle,
          headline: title,
          subheadline: (signifies ?? '').isEmpty ? null : signifies,
          hue: hue,
          animate: false,
          actions: [
            const LanguageQuickButton(),
            IconButton(
              tooltip: l.kFcAllChartsTooltip,
              icon: const Icon(Icons.grid_view_rounded),
              onPressed: menu.isEmpty ? null : () => _openPicker(menu),
            ),
          ],
          heroBottom: KDarkChipRail(
            labels: [
              for (final t in FullChartPage.essentials) s.chartShortLabel(t),
            ],
            selected: _page,
            onSelect: _goTo,
          ),
          children: [
            _Carousel(
              controller: _pc,
              state: state,
              style: _style,
              hue: hue,
              onPage: (i) => setState(() => _page = i),
              onStyle: (st) => setState(() => _style = st),
              page: _page,
            ),
            const SizedBox(height: 12),
            if (vc != null) ...[
              KChartFacts(vc: vc, fallbackTitle: s.chartShortLabel(type)),
              KSection(
                title: vc.isTransit ? l.kFcTransitingGrahas : l.kFcPlanets,
                hue: AstroPalette.money,
                child: KPlanetList(vc: vc),
              ),
            ],
            KSection(
              title: l.kFcExploreMore,
              hue: AstroPalette.career,
              child: Column(
                children: [
                  if (state.overview.value != null)
                    KNavRow(
                      icon: Icons.grid_view_rounded,
                      hue: kSignHue(state.overview.value!.lagnaSign),
                      title: l.kFcAllHouses,
                      subtitle: l.kFcAllHousesSub,
                      onTap: () => context.push(
                        KundaliRoutes.chartDetail(widget.profileId, 'd1'),
                      ),
                    ),
                  const SizedBox(height: 8),
                  KNavRow(
                    icon: Icons.layers_rounded,
                    hue: AstroPalette.air,
                    title: l.kFcAllCharts,
                    subtitle: l.kFcAllChartsSub,
                    onTap: menu.isEmpty ? () {} : () => _openPicker(menu),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const KChartLegend(),
          ],
        );
      },
    );
  }
}

class _Carousel extends StatelessWidget {
  const _Carousel({
    required this.controller,
    required this.state,
    required this.style,
    required this.hue,
    required this.page,
    required this.onPage,
    required this.onStyle,
  });

  final PageController controller;
  final KundaliState state;
  final ChartStyle style;
  final AstroHue hue;
  final int page;
  final ValueChanged<int> onPage;
  final ValueChanged<ChartStyle> onStyle;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final width = MediaQuery.sizeOf(context).width - 32;
    return KCosmicPanel(
      hue: hue,
      padding: const EdgeInsets.fromLTRB(0, 14, 0, 12),
      child: Column(
        children: [
          SizedBox(
            height: width - 28,
            child: PageView.builder(
              controller: controller,
              itemCount: FullChartPage.essentials.length,
              onPageChanged: onPage,
              itemBuilder: (context, i) {
                final t = FullChartPage.essentials[i];
                final slice =
                    state.charts[t] ?? const AsyncValue<VargaChart>.idle();
                final vc = slice.value;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: _chart(context, t, slice, vc),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 6,
              children: [
                KDarkSegment(
                  labels: [l.kChNorthIndian, l.kChSouthIndian],
                  selected: style == ChartStyle.north ? 0 : 1,
                  onSelect: (i) =>
                      onStyle(i == 0 ? ChartStyle.north : ChartStyle.south),
                ),
                _Dots(
                  count: FullChartPage.essentials.length,
                  active: page,
                  color: brand.glowAccent,
                ),
              ],
            ),
          ),
          if (FullChartPage.essentials[page] == 'd1') ...[
            const SizedBox(height: 8),
            Text(
              l.kOvTapHouseHint,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(color: brand.onCosmicMuted),
            ),
          ],
        ],
      ),
    );
  }

  Widget _chart(
    BuildContext context,
    String type,
    AsyncValue<VargaChart> slice,
    VargaChart? vc,
  ) {
    final brand = context.brand;
    if (vc != null && vc.houses.isNotEmpty) {
      return Center(
        child: NatalChart(
          houses: vc.houses,
          style: style,
          retrograde: {
            for (final p in vc.planets)
              if (p.retrograde) p.name,
          },
          fillColor: Colors.white.withValues(alpha: 0.03),
          lineColor: Colors.white.withValues(alpha: 0.26),
          numberColor: Colors.white.withValues(alpha: 0.5),
          textColor: Colors.white,
          onHouseTap: type == 'd1'
              ? (h) {
                  final k = state.overview.value;
                  if (k != null) {
                    showHouseDetailSheet(context, kundali: k, house: h);
                  }
                }
              : null,
        ),
      );
    }
    if (slice.isError) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_rounded, color: brand.onCosmicMuted, size: 32),
            const SizedBox(height: 8),
            Text(
              context.l10n.kFcLoadError,
              textAlign: TextAlign.center,
              style: TextStyle(color: brand.onCosmicMuted),
            ),
            TextButton(
              onPressed: () =>
                  context.read<KundaliCubit>().loadChart(type, force: true),
              style: TextButton.styleFrom(foregroundColor: brand.glowAccent),
              child: Text(context.l10n.commonRetry),
            ),
          ],
        ),
      );
    }
    return Center(child: CircularProgressIndicator(color: brand.onCosmicMuted));
  }
}

class _Dots extends StatelessWidget {
  const _Dots({required this.count, required this.active, required this.color});
  final int count;
  final int active;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < count; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 2.5),
            width: i == active ? 16 : 6,
            height: 6,
            decoration: BoxDecoration(
              color: i == active ? color : Colors.white.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
      ],
    );
  }
}
