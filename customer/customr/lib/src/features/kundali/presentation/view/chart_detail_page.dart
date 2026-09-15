import 'package:astro_kundali/astro_kundali.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/astro_palette.dart';
import '../../../../core/util/async_value.dart';
import '../../../../shared/widgets/language_quick_button.dart';
import '../cubit/kundali_cubit.dart';
import '../widgets/k_chart.dart';
import '../widgets/kundali_ui.dart';
import 'house_detail_sheet.dart';

/// One chart in full — reached from the "All charts" menu or a deep link
/// (`/kundali/:id/chart/:type`). The carousel page handles the essentials.
class ChartDetailPage extends StatefulWidget {
  const ChartDetailPage({
    required this.profileId,
    required this.type,
    super.key,
  });
  final String profileId;
  final String type;

  @override
  State<ChartDetailPage> createState() => _ChartDetailPageState();
}

class _ChartDetailPageState extends State<ChartDetailPage> {
  ChartStyle _style = ChartStyle.north;
  late String _type = widget.type;

  @override
  void initState() {
    super.initState();
    context.read<KundaliCubit>()
      ..loadOverview()
      ..loadChartTypes()
      ..loadChart(_type);
  }

  void _select(String type) {
    if (type == _type) return;
    setState(() => _type = type);
    context.read<KundaliCubit>().loadChart(type);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final s = KundaliStrings.of(context);
    return BlocBuilder<KundaliCubit, KundaliState>(
      builder: (context, state) {
        final menu = state.chartTypes.value ?? const <ChartTypeInfo>[];
        final info = menu.firstWhere(
          (c) => c.type == _type,
          orElse: () =>
              ChartTypeInfo(type: _type, name: s.chartShortLabel(_type)),
        );
        final slice =
            state.charts[_type] ?? const AsyncValue<VargaChart>.idle();
        final vc = slice.value;
        final k = state.overview.value;
        final hue = kSignHue(vc?.ascendantSign ?? k?.lagnaSign ?? '');
        final signifies = s.chartSignifies(info.type, info.signifies);

        return KundaliScaffold(
          title: s.chartName(info.type, info.name),
          eyebrow: info.varga != null
              ? 'D${info.varga} · ${l.kFcTitle}'
              : l.kFcTitle,
          headline: s.chartName(info.type, info.name),
          subheadline: signifies.isEmpty ? null : signifies,
          hue: hue,
          actions: [
            const LanguageQuickButton(),
            if (menu.isNotEmpty)
              IconButton(
                tooltip: l.kFcAllChartsTooltip,
                icon: const Icon(Icons.grid_view_rounded),
                onPressed: () => showKChartPicker(
                  context,
                  menu: menu,
                  selected: _type,
                  onPick: (t) {
                    Navigator.of(context).pop();
                    _select(t);
                  },
                ),
              ),
          ],
          children: [
            KChartPanel(
              houses: vc?.houses ?? const [],
              style: _style,
              hue: hue,
              retrograde: {
                for (final p in vc?.planets ?? const <ChartPlacement>[])
                  if (p.retrograde) p.name,
              },
              error: slice.isError,
              onRetry: () =>
                  context.read<KundaliCubit>().loadChart(_type, force: true),
              onHouseTap: _type == 'd1' && k != null
                  ? (h) => showHouseDetailSheet(context, kundali: k, house: h)
                  : null,
              footer: Center(
                child: KDarkSegment(
                  labels: [l.kChNorthIndian, l.kChSouthIndian],
                  selected: _style == ChartStyle.north ? 0 : 1,
                  onSelect: (i) => setState(
                    () => _style = i == 0 ? ChartStyle.north : ChartStyle.south,
                  ),
                ),
              ),
            ),
            if (vc != null) ...[
              const SizedBox(height: 12),
              KChartFacts(vc: vc, fallbackTitle: info.name),
              KSection(
                title: vc.isTransit ? l.kFcTransitingGrahas : l.kFcPlanets,
                hue: AstroPalette.money,
                child: KPlanetList(vc: vc),
              ),
            ],
            if (_type == 'd1' && k != null)
              KSection(
                title: l.kFcTwelveHouses,
                subtitle: l.kOvTapHouseHint,
                hue: hue,
                child: KHouseGrid(
                  houses: k.houses,
                  onTap: (h) =>
                      showHouseDetailSheet(context, kundali: k, house: h),
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
