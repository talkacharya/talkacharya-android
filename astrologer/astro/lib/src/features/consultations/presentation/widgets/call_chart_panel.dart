import 'package:astro_kundali/astro_kundali.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/util/async_value.dart';
import '../../../kundali/presentation/cubit/kundali_cubit.dart';


/// The customer's chart, over a live video call.
///
/// On a video consultation the astrologer had nowhere to put the chart: they
/// either talked from memory or left the call to look at it. Nothing else in
/// this product is as specific to what the job actually is — a reading is two
/// people looking at the same diagram.
///
/// It sits over the video rather than beside it because a phone has no room
/// for both, and the face matters less than the chart while the chart is up.
class CallChartPanel extends StatefulWidget {
  const CallChartPanel({required this.consultationId, super.key});

  final String consultationId;

  @override
  State<CallChartPanel> createState() => _CallChartPanelState();
}

class _CallChartPanelState extends State<CallChartPanel> {
  static const _types = ['d1', 'd9'];

  bool _open = false;
  int _index = 0;
  ChartStyle _style = ChartStyle.north;
  bool _loaded = false;

  void _toggle() {
    setState(() => _open = !_open);
    if (_open && !_loaded) {
      _loaded = true;
      final cubit = context.read<KundaliCubit>();
      for (final t in _types) {
        cubit.loadChart(t);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_open)
          Flexible(
            child: _Sheet(
              types: _types,
              index: _index,
              style: _style,
              onIndex: (i) => setState(() => _index = i),
              onStyle: (s) => setState(() => _style = s),
              onClose: _toggle,
            ),
          ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(top: 8, right: 4),
            child: FilledButton.tonalIcon(
              onPressed: _toggle,
              icon: Icon(
                _open ? Icons.close_rounded : Icons.auto_awesome_rounded,
                size: 18,
              ),
              label: Text(_open ? l.callHideChart : l.callShowChart),
              style: FilledButton.styleFrom(
                visualDensity: VisualDensity.compact,
                backgroundColor: Colors.black.withValues(alpha: 0.45),
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Sheet extends StatelessWidget {
  const _Sheet({
    required this.types,
    required this.index,
    required this.style,
    required this.onIndex,
    required this.onStyle,
    required this.onClose,
  });

  final List<String> types;
  final int index;
  final ChartStyle style;
  final ValueChanged<int> onIndex;
  final ValueChanged<ChartStyle> onStyle;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KundaliCubit, KundaliState>(
      builder: (context, state) {
        final type = types[index];
        final slice = state.charts[type] ?? const AsyncValue<VargaChart>.idle();
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
          decoration: BoxDecoration(
            // Dark and opaque: a chart half-showing the video behind it is
            // unreadable, and this is the thing being read.
            color: Colors.black.withValues(alpha: 0.88),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  for (var i = 0; i < types.length; i++) ...[
                    ChoiceChip(
                      label: Text(chartShortLabel(types[i])),
                      selected: i == index,
                      showCheckmark: false,
                      visualDensity: VisualDensity.compact,
                      labelStyle: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: i == index ? Colors.black : Colors.white70,
                      ),
                      selectedColor: Colors.white,
                      backgroundColor: Colors.white12,
                      side: BorderSide.none,
                      onSelected: (_) => onIndex(i),
                    ),
                    const SizedBox(width: 6),
                  ],
                  const Spacer(),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(
                      Icons.swap_horiz_rounded,
                      size: 18,
                      color: Colors.white70,
                    ),
                    tooltip: style == ChartStyle.north
                        ? const KundaliStrings().southIndian
                        : const KundaliStrings().northIndian,
                    onPressed: () => onStyle(
                      style == ChartStyle.north
                          ? ChartStyle.south
                          : ChartStyle.north,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Flexible(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: ChartWheel(
                    chart: slice.value,
                    loading: slice.status == AsyncStatus.loading,
                    error: slice.status == AsyncStatus.error
                        ? slice.error
                        : null,
                    style: style,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
