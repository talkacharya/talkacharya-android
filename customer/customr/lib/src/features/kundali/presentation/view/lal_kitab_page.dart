import 'package:astro_kundali/astro_kundali.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/l10n.dart';
import '../cubit/kundali_cubit.dart';
import '../widgets/kundali_ui.dart';

/// Lal Kitab (`/lal-kitab`) — the inherited debts (rin) in the chart and their
/// signature totka remedies. Simple, free household acts — never gemstones.
class LalKitabPage extends StatefulWidget {
  const LalKitabPage({required this.profileId, super.key});
  final String profileId;

  @override
  State<LalKitabPage> createState() => _LalKitabPageState();
}

class _LalKitabPageState extends State<LalKitabPage> {
  @override
  void initState() {
    super.initState();
    context.read<KundaliCubit>().loadLalKitab();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.lalKitabTitle)),
      body: BlocBuilder<KundaliCubit, KundaliState>(
        buildWhen: (a, b) => a.lalKitab != b.lalKitab,
        builder: (context, state) => SliceBuilder<LalKitabReport>(
          slice: state.lalKitab,
          onRetry: () => context.read<KundaliCubit>().loadLalKitab(),
          builder: (context, r) {
            final theme = Theme.of(context);
            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
              children: [
                Text(
                  l.lalKitabIntro,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                if (r.summary.isNotEmpty)
                  KCard(
                    tint: true,
                    child: Text(
                      r.summary,
                      style: const TextStyle(fontSize: 13, height: 1.45),
                    ),
                  ),
                const SizedBox(height: 12),
                Text(
                  l.lalKitabActiveDebts,
                  style: theme.textTheme.titleMedium?.copyWith(fontSize: 14),
                ),
                const SizedBox(height: 8),
                if (r.activeRins.isEmpty)
                  KCard(
                    child: Text(
                      l.lalKitabNoDebts,
                      style: const TextStyle(fontSize: 12.5, height: 1.4),
                    ),
                  )
                else
                  for (final rin in r.activeRins) ...[
                    _RinCard(rin: rin),
                    const SizedBox(height: 10),
                  ],
                if (r.mandaPlanets.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    l.lalKitabWeakPlanets,
                    style: theme.textTheme.titleMedium?.copyWith(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  for (final m in r.mandaPlanets) ...[
                    _MandaCard(manda: m),
                    const SizedBox(height: 8),
                  ],
                ],
                const SizedBox(height: 12),
                Text(
                  r.disclaimer,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _RinCard extends StatelessWidget {
  const _RinCard({required this.rin});
  final LalKitabRin rin;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return KCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            rin.name,
            style: theme.textTheme.titleMedium?.copyWith(fontSize: 14),
          ),
          if (rin.reasons.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              l.lalKitabWhyFlagged,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 3),
            for (final why in rin.reasons)
              Text(
                '·  $why',
                style: const TextStyle(fontSize: 12, height: 1.4),
              ),
          ],
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.lalKitabRemedy,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  rin.remedy,
                  style: const TextStyle(fontSize: 12.5, height: 1.45),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MandaCard extends StatelessWidget {
  const _MandaCard({required this.manda});
  final LalKitabManda manda;

  @override
  Widget build(BuildContext context) {
    return KCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            manda.summary,
            style: const TextStyle(fontSize: 12.5, height: 1.45),
          ),
          const SizedBox(height: 5),
          Text(
            manda.remedy,
            style: TextStyle(
              fontSize: 12,
              height: 1.4,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
