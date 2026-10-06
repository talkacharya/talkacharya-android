part of '../consultation_kundali_page.dart';

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
            return Center(child: Text(context.l10n.kundaliNoYogas));
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
