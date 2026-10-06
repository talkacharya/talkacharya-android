part of '../consultation_kundali_page.dart';

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
