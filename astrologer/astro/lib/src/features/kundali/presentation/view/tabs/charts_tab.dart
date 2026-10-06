part of '../consultation_kundali_page.dart';

class _ChartsTab extends StatefulWidget {
  const _ChartsTab({required this.consultationId, this.standalone = false});
  final String consultationId;
  final bool standalone;

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
          widget.standalone
              ? '/client-charts/${widget.consultationId}/kundali/chart/$t'
              : '/consultations/${widget.consultationId}/kundali/chart/$t',
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final wheelH = MediaQuery.sizeOf(context).width - 20;
    final kt = KT.of(context);

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
                    label: Text(kt.chartShortLabel(_essentials[i])),
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
                fallbackTitle: kt.chartShortLabel(currentType),
              ),
              const SizedBox(height: 14),
              PlanetTable(vc: current.value!),
            ] else if (current.status == AsyncStatus.error)
              ChartBanner(
                icon: Icons.error_outline_rounded,
                text: current.error ?? kt.loadFailed,
              ),
            const SizedBox(height: 14),
            FilledButton.tonalIcon(
              onPressed: menu.isEmpty ? null : () => _openPicker(menu),
              icon: const Icon(Icons.grid_view_rounded, size: 18),
              label: Text(kt.allCharts),
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
