import 'package:astro_kundali/astro_kundali.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/util/async_value.dart';
import '../../../../shared/widgets/language_quick_button.dart';
import '../cubit/kundali_cubit.dart';
import '../kundali_terms.dart';
import '../widgets/kundali_ui.dart';
import 'house_detail_sheet.dart';

/// One chart in full — reached from the "All charts" picker or a deep link
/// (`/kundali/:id/chart/:type`). The carousel handles the essentials.
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

        return Scaffold(
          appBar: AppBar(
            title: Text(s.chartName(info.type, info.name)),
            actions: [
              const LanguageQuickButton(),
              if (menu.isNotEmpty)
                IconButton(
                  tooltip: l.kFcAllChartsTooltip,
                  icon: const Icon(Icons.grid_view_rounded),
                  onPressed: () => showChartPicker(
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
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
            children: [
              ChartStyleToggle(
                style: _style,
                onChanged: (s) => setState(() => _style = s),
              ),
              const SizedBox(height: 14),
              ChartWheel(
                chart: slice.value,
                error: slice.status == AsyncStatus.error ? slice.error : null,
                style: _style,
                onRetry: () =>
                    context.read<KundaliCubit>().loadChart(_type, force: true),
                onHouseTap: _type == 'd1'
                    ? (h) {
                        final k = state.overview.value;
                        if (k != null) {
                          showHouseDetailSheet(context, kundali: k, house: h);
                        }
                      }
                    : null,
              ),
              const SizedBox(height: 12),
              if (slice.value != null) ...[
                ChartDetails(vc: slice.value!, fallbackTitle: info.name),
                const SizedBox(height: 14),
                KLabel(
                  slice.value!.isTransit ? l.kFcTransitingGrahas : l.kFcPlanets,
                ),
                const SizedBox(height: 8),
                PlanetTable(vc: slice.value!),
              ],
              const SizedBox(height: 14),
              const ChartLegend(),
              if (_type == 'd1' && state.overview.value != null) ...[
                const SizedBox(height: 14),
                KLabel(l.kFcTwelveHouses),
                const SizedBox(height: 8),
                _HousesList(kundali: state.overview.value!),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _HousesList extends StatelessWidget {
  const _HousesList({required this.kundali});
  final Kundali kundali;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l = context.l10n;
    final ordered = [...kundali.houses]
      ..sort((a, b) => a.house.compareTo(b.house));
    return KCard(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          for (var i = 0; i < ordered.length; i++)
            Column(
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                  leading: CircleAvatar(
                    radius: 16,
                    backgroundColor: scheme.primaryContainer,
                    child: Text(
                      '${ordered[i].house}',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        color: scheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  title: Text(
                    l.kHouseTitleWithSign(
                      KTerms.signName(l, ordered[i].sign),
                      KTerms.house(l, ordered[i].house),
                    ),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13.5,
                    ),
                  ),
                  subtitle: Text(
                    ordered[i].planets.isEmpty
                        ? l.kFcNoPlanets
                        : ordered[i].planets
                              .map((p) => KTerms.planetName(l, p))
                              .join(', '),
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => showHouseDetailSheet(
                    context,
                    kundali: kundali,
                    house: ordered[i].house,
                  ),
                ),
                if (i != ordered.length - 1) const Divider(height: 1),
              ],
            ),
        ],
      ),
    );
  }
}
