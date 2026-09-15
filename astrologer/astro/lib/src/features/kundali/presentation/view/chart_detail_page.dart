import 'package:astro_kundali/astro_kundali.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/util/async_value.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../data/kundali_repository.dart';
import '../cubit/kundali_cubit.dart';

/// One chart in full, reached from the "All charts" picker. Creates its own
/// [KundaliCubit] for the consultation (charts cache per type).
class ChartDetailPage extends StatelessWidget {
  const ChartDetailPage({
    required this.consultationId,
    required this.type,
    super.key,
  });
  final String consultationId;
  final String type;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          KundaliCubit(
              repo: getIt<KundaliRepository>(),
              consultationId: consultationId,
            )
            ..loadChartTypes()
            ..loadChart(type),
      child: _View(initialType: type),
    );
  }
}

class _View extends StatefulWidget {
  const _View({required this.initialType});
  final String initialType;

  @override
  State<_View> createState() => _ViewState();
}

class _ViewState extends State<_View> {
  ChartStyle _style = ChartStyle.north;
  late String _type = widget.initialType;

  void _select(String type) {
    if (type == _type) return;
    setState(() => _type = type);
    context.read<KundaliCubit>().loadChart(type);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KundaliCubit, KundaliState>(
      builder: (context, state) {
        final menu = state.chartTypes.value ?? const <ChartTypeInfo>[];
        final info = menu.firstWhere(
          (c) => c.type == _type,
          orElse: () =>
              ChartTypeInfo(type: _type, name: chartShortLabel(_type)),
        );
        final slice =
            state.charts[_type] ?? const AsyncValue<VargaChart>.idle();

        return Scaffold(
          appBar: AppBar(
            title: Text(info.name),
            actions: [
              if (menu.isNotEmpty)
                IconButton(
                  tooltip: 'All charts',
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
              ),
              const SizedBox(height: 12),
              if (slice.value != null) ...[
                ChartDetails(vc: slice.value!, fallbackTitle: info.name),
                const SizedBox(height: 14),
                PlanetTable(vc: slice.value!),
              ] else if (slice.status == AsyncStatus.error)
                ErrorView(
                  message: slice.error ?? 'Could not load this chart',
                  onRetry: () => context.read<KundaliCubit>().loadChart(
                    _type,
                    force: true,
                  ),
                ),
              const SizedBox(height: 14),
              const ChartLegend(),
            ],
          ),
        );
      },
    );
  }
}
