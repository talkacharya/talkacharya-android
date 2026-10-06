part of '../consultation_kundali_page.dart';

class _DoshasTab extends StatefulWidget {
  const _DoshasTab();
  @override
  State<_DoshasTab> createState() => _DoshasTabState();
}

class _DoshasTabState extends State<_DoshasTab> {
  @override
  void initState() {
    super.initState();
    context.read<KundaliCubit>().loadDoshas();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KundaliCubit, KundaliState>(
      builder: (context, state) => _Slice<DoshaReport>(
        slice: state.doshas,
        onRetry: () => context.read<KundaliCubit>().loadDoshas(),
        builder: (report) => ListView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
          children: [
            Text(
              '${report.count} present of ${report.doshas.length} checked · '
              'structural only, cancellations flagged.',
              style: TextStyle(
                fontSize: 11.5,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            for (final d in [...report.present, ...report.clear])
              _DoshaRow(dosha: d),
          ],
        ),
      ),
    );
  }
}

class _DoshaRow extends StatelessWidget {
  const _DoshaRow({required this.dosha});
  final Dosha dosha;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    final sev = dosha.displaySeverity;
    final (chipText, chipColor) = !dosha.present
        ? ('clear', const Color(0xFF1E7A3C))
        : dosha.isCancelled || sev == 0
        ? ('cancelled', muted)
        : sev >= 3
        ? ('strong', const Color(0xFFB23A28))
        : sev == 2
        ? ('moderate', const Color(0xFFB0691F))
        : ('mild', const Color(0xFF8A7A32));

    return Opacity(
      opacity: dosha.present ? 1 : 0.6,
      child: KundaliCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    dosha.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13.5,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: chipColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    chipText,
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                      color: chipColor,
                    ),
                  ),
                ),
              ],
            ),
            if (dosha.present) ...[
              if (dosha.kaalSarpaType.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  '${dosha.kaalSarpaType}${dosha.partial ? " · partial" : ""}',
                  style: TextStyle(fontSize: 11.5, color: muted),
                ),
              ],
              const SizedBox(height: 6),
              for (final r in dosha.reasons)
                Text(
                  '· ${r.text}',
                  style: const TextStyle(fontSize: 12, height: 1.35),
                ),
              if (dosha.cancellations.isNotEmpty) ...[
                const SizedBox(height: 6),
                for (final c in dosha.cancellations)
                  Text(
                    '${c.applies ? "✓" : "✗"} ${c.text}',
                    style: TextStyle(
                      fontSize: 11.5,
                      height: 1.35,
                      color: c.applies ? const Color(0xFF1E7A3C) : muted,
                    ),
                  ),
              ],
            ] else if (dosha.summary.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                dosha.summary,
                style: TextStyle(fontSize: 11.5, color: muted),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
