import 'package:astro_kundali/astro_kundali.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/util/async_value.dart';
import '../../../../shared/widgets/language_quick_button.dart';
import '../cubit/kundali_cubit.dart';
import '../widgets/kundali_ui.dart';
import 'house_detail_sheet.dart';
import 'kundali_routes.dart';

/// The birth-chart screen. A horizontal carousel of the charts customers ask
/// about most — swipe or tap a chip to glance between them, all pre-fetched so
/// there's no reload. "All charts" opens the full D1–D60 picker.
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
    _pc.animateToPage(
      i,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOut,
    );
  }

  void _openPicker(List<ChartTypeInfo> menu) {
    showChartPicker(
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
    final wheelH = MediaQuery.sizeOf(context).width - 20;
    final l = context.l10n;
    final s = KundaliStrings.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.kFcTitle),
        actions: const [LanguageQuickButton()],
      ),
      body: BlocBuilder<KundaliCubit, KundaliState>(
        builder: (context, state) {
          final menu = state.chartTypes.value ?? const <ChartTypeInfo>[];
          final currentType = FullChartPage.essentials[_page];
          final currentSlice =
              state.charts[currentType] ?? const AsyncValue<VargaChart>.idle();

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
            children: [
              _ChipRail(
                types: FullChartPage.essentials,
                selected: _page,
                onTap: _goTo,
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
                  itemCount: FullChartPage.essentials.length,
                  onPageChanged: (i) => setState(() => _page = i),
                  itemBuilder: (context, i) {
                    final t = FullChartPage.essentials[i];
                    final slice =
                        state.charts[t] ?? const AsyncValue<VargaChart>.idle();
                    return ChartWheel(
                      chart: slice.value,
                      error: slice.status == AsyncStatus.error
                          ? slice.error
                          : null,
                      style: _style,
                      onRetry: () => context.read<KundaliCubit>().loadChart(
                        t,
                        force: true,
                      ),
                      onHouseTap: t == 'd1'
                          ? (h) {
                              final k = state.overview.value;
                              if (k != null) {
                                showHouseDetailSheet(
                                  context,
                                  kundali: k,
                                  house: h,
                                );
                              }
                            }
                          : null,
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              _Dots(count: FullChartPage.essentials.length, active: _page),
              const SizedBox(height: 14),
              if (currentSlice.value != null) ...[
                ChartDetails(
                  vc: currentSlice.value!,
                  fallbackTitle: s.chartShortLabel(currentType),
                ),
                const SizedBox(height: 14),
                KLabel(
                  currentSlice.value!.isTransit
                      ? l.kFcTransitingGrahas
                      : l.kFcPlanets,
                ),
                const SizedBox(height: 8),
                PlanetTable(vc: currentSlice.value!),
              ] else if (currentSlice.isError)
                ChartBanner(
                  icon: Icons.error_outline_rounded,
                  text: currentSlice.error ?? l.kFcLoadError,
                ),
              if (currentType == 'd1') ...[
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => context.push(
                    KundaliRoutes.chartDetail(widget.profileId, 'd1'),
                  ),
                  icon: const Icon(Icons.view_list_rounded, size: 18),
                  label: Text(l.kFcAllHouses),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(46),
                  ),
                ),
              ],
              const SizedBox(height: 12),
              FilledButton.tonalIcon(
                onPressed: menu.isEmpty ? null : () => _openPicker(menu),
                icon: const Icon(Icons.grid_view_rounded, size: 18),
                label: Text(l.kFcAllCharts),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
              ),
              const SizedBox(height: 16),
              const ChartLegend(),
              const SizedBox(height: 36),
            ],
          );
        },
      ),
    );
  }
}

class _ChipRail extends StatelessWidget {
  const _ChipRail({
    required this.types,
    required this.selected,
    required this.onTap,
  });

  final List<String> types;
  final int selected;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: types.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final on = i == selected;
          return ChoiceChip(
            label: Text(KundaliStrings.of(context).chartShortLabel(types[i])),
            selected: on,
            showCheckmark: false,
            labelStyle: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: on ? scheme.onPrimary : scheme.onSurfaceVariant,
            ),
            selectedColor: scheme.primary,
            onSelected: (_) => onTap(i),
          );
        },
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  const _Dots({required this.count, required this.active});
  final int count;
  final int active;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < count; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: i == active ? 18 : 6,
            height: 6,
            decoration: BoxDecoration(
              color: i == active ? scheme.primary : scheme.outlineVariant,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
      ],
    );
  }
}
