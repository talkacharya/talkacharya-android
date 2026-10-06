part of '../consultation_kundali_page.dart';

class _SadeSatiTab extends StatefulWidget {
  const _SadeSatiTab();
  @override
  State<_SadeSatiTab> createState() => _SadeSatiTabState();
}

class _SadeSatiTabState extends State<_SadeSatiTab> {
  @override
  void initState() {
    super.initState();
    context.read<KundaliCubit>()
      ..loadSadeSati()
      ..loadAvTransit()
      ..loadMuhurta()
      ..loadVarshphal();
  }

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    String range(String a, String b) => '$a → $b';
    return BlocBuilder<KundaliCubit, KundaliState>(
      builder: (context, state) => _Slice<SadeSatiCalendar>(
        slice: state.sadeSati,
        onRetry: () => context.read<KundaliCubit>().loadSadeSati(),
        builder: (cal) => ListView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
          children: [
            Text(
              'Dated Saturn windows from the natal Moon (${cal.natalMoonSign}). '
              'Same view the client sees.',
              style: TextStyle(fontSize: 11.5, color: muted),
            ),
            const SizedBox(height: 10),
            if (cal.summary.isNotEmpty)
              KundaliCard(
                child: Text(
                  cal.summary,
                  style: const TextStyle(fontSize: 12, height: 1.4),
                ),
              ),
            for (final period in cal.sadeSatiPeriods)
              KundaliCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sade Sati · ${period.signs.join(" → ")}'
                      '${period.running ? "  · running" : ""}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12.5,
                      ),
                    ),
                    Text(
                      range(period.start, period.end),
                      style: TextStyle(fontSize: 10.5, color: muted),
                    ),
                    const SizedBox(height: 4),
                    for (final ph in period.phases)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 3),
                        child: Text(
                          '· ${ph.phase} (${range(ph.start, ph.end)}) — '
                          '${ph.summary}',
                          style: TextStyle(
                            fontSize: 10.5,
                            height: 1.35,
                            color: muted,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            for (final d in cal.dhaiyaPeriods)
              KundaliCard(
                child: Text(
                  'Dhaiya · ${d.phase} (${range(d.start, d.end)})'
                  '${d.running ? "  · running" : ""} — ${d.summary}',
                  style: const TextStyle(fontSize: 11, height: 1.4),
                ),
              ),
            const _VarshphalBlock(),
            const _AvTransitBlock(),
            const _MuhurtaBlock(),
          ],
        ),
      ),
    );
  }
}

class _VarshphalBlock extends StatelessWidget {
  const _VarshphalBlock();

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    return BlocBuilder<KundaliCubit, KundaliState>(
      buildWhen: (a, b) => a.varshphal != b.varshphal,
      builder: (context, state) {
        final v = state.varshphal.value;
        if (v == null) return const SizedBox.shrink();
        return KundaliCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Varshphal — age ${v.age} (${v.starts} → ${v.ends})',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'Varsha Lagna ${v.varshaLagna} · Muntha ${v.munthaSign} H${v.munthaHouse} · '
                'year lord ${v.yearLord} (H${v.yearLordHouse}, ${v.yearLordDignity})',
                style: TextStyle(fontSize: 10.5, height: 1.35, color: muted),
              ),
              if (v.summary.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  v.summary,
                  style: const TextStyle(fontSize: 10.5, height: 1.4),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _MuhurtaBlock extends StatelessWidget {
  const _MuhurtaBlock();

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    return BlocBuilder<KundaliCubit, KundaliState>(
      buildWhen: (a, b) => a.muhurta != b.muhurta,
      builder: (context, state) {
        final d = state.muhurta.value;
        if (d == null || !d.available) return const SizedBox.shrink();
        return KundaliCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Today's timing — ${d.weekday} (${d.dayLord}), "
                '${d.sunrise}/${d.sunset}',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
              if (d.summary.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  d.summary,
                  style: const TextStyle(fontSize: 11, height: 1.4),
                ),
              ],
              const SizedBox(height: 4),
              for (final w in d.bestWindows)
                Text(
                  '· ${w.summary}',
                  style: TextStyle(fontSize: 10.5, height: 1.35, color: muted),
                ),
              if (d.abhijit != null)
                Text(
                  '· ${d.abhijit!.summary}',
                  style: TextStyle(fontSize: 10.5, height: 1.35, color: muted),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _AvTransitBlock extends StatelessWidget {
  const _AvTransitBlock();

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    return BlocBuilder<KundaliCubit, KundaliState>(
      buildWhen: (a, b) => a.avTransit != b.avTransit,
      builder: (context, state) {
        final r = state.avTransit.value;
        if (r == null) return const SizedBox.shrink();
        return KundaliCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ashtakavarga transit reading',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
              ),
              const SizedBox(height: 6),
              for (final row in r.transits)
                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    '· ${row.planet} ${row.sign} H${row.houseFromLagna} — '
                    '${row.bindus}/8${row.retrograde ? " R" : ""} · ${row.tone}',
                    style: TextStyle(
                      fontSize: 10.5,
                      height: 1.35,
                      color: muted,
                    ),
                  ),
                ),
              for (final u in r.upcomingIngresses)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    '→ ${u.summary}',
                    style: TextStyle(
                      fontSize: 10.5,
                      height: 1.35,
                      color: muted,
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
