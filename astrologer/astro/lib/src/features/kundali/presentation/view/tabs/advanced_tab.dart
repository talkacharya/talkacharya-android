part of '../consultation_kundali_page.dart';

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
    final kt = KT.of(context);
    return BlocBuilder<KundaliCubit, KundaliState>(
      builder: (context, state) {
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
          children: [
            KundaliLabel(kt.sarvashtakavarga),
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
                          Text(kt.h(h), style: const TextStyle(fontSize: 10)),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            KundaliLabel(kt.shadbala),
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
                                kt.term(p.name),
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
            KundaliLabel(kt.kp),
            const SizedBox(height: 8),
            _Slice<Map<String, dynamic>>(
              slice: state.kp,
              onRetry: () => context.read<KundaliCubit>().loadKp(),
              builder: (kp) => KundaliCard(child: _KeyValues(kp)),
            ),
            const SizedBox(height: 18),
            KundaliLabel(kt.jaimini),
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
    final kt = KT.of(context);

    final entries = data.entries.where((e) => e.key != 'engine').toList();
    if (entries.isEmpty) {
      return Text(
        kt.noData,
        style: const TextStyle(fontSize: 12.5),
      );
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
                    kt.fieldName(e.key),
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    kt.value(e.value),
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
