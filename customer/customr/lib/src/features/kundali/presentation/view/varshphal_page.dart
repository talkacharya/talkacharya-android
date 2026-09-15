import 'package:astro_kundali/astro_kundali.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/l10n.dart';
import '../cubit/kundali_cubit.dart';
import '../kundali_terms.dart';
import '../widgets/kundali_ui.dart';

/// Varshphal (`/varshphal`) — the Tajika annual / solar-return chart for the
/// current year: Varsha Lagna, Muntha, year lord and the Tajika aspect.
class VarshphalPage extends StatefulWidget {
  const VarshphalPage({required this.profileId, super.key});
  final String profileId;

  @override
  State<VarshphalPage> createState() => _VarshphalPageState();
}

class _VarshphalPageState extends State<VarshphalPage> {
  @override
  void initState() {
    super.initState();
    context.read<KundaliCubit>().loadVarshphal();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.varshphalTitle)),
      body: BlocBuilder<KundaliCubit, KundaliState>(
        buildWhen: (a, b) => a.varshphal != b.varshphal,
        builder: (context, state) => SliceBuilder<Varshphal>(
          slice: state.varshphal,
          onRetry: () => context.read<KundaliCubit>().loadVarshphal(),
          builder: (context, v) {
            final theme = Theme.of(context);
            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
              children: [
                Text(
                  l.varshphalIntro(KTerms.ordinal(l, v.age)),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l.varshphalWindow(v.starts, v.ends),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 14),
                if (v.summary.isNotEmpty)
                  KCard(
                    tint: true,
                    child: Text(
                      v.summary,
                      style: const TextStyle(fontSize: 13, height: 1.5),
                    ),
                  ),
                const SizedBox(height: 10),
                KCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _row(
                        context,
                        l.varshphalLagna,
                        KTerms.signName(l, v.varshaLagna),
                      ),
                      _row(
                        context,
                        l.varshphalMuntha,
                        '${KTerms.signName(l, v.munthaSign)} (${KTerms.nthHouse(l, v.munthaHouse)})',
                      ),
                      _row(
                        context,
                        l.varshphalYearLord,
                        '${KTerms.planetName(l, v.yearLord)} · ${KTerms.nthHouse(l, v.yearLordHouse)}'
                        '${v.yearLordDignity.isNotEmpty ? " · ${KTerms.dignity(l, v.yearLordDignity)}" : ""}',
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l.varshphalMunthaLine(
                          KTerms.nthHouse(l, v.munthaHouse),
                          v.munthaTheme,
                        ),
                        style: const TextStyle(fontSize: 12.5, height: 1.45),
                      ),
                      if (v.tajikaSummary.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          v.tajikaSummary,
                          style: TextStyle(
                            fontSize: 12.5,
                            height: 1.45,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                KCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l.varshphalChart,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 6),
                      for (final p in v.planets)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 3),
                          child: Text(
                            '${KTerms.planetName(l, p.name)}  ·  '
                            '${KTerms.signName(l, p.sign)}  ·  '
                            '${KTerms.nthHouse(l, p.house)}'
                            '${p.retrograde ? "  ·  ℞" : ""}'
                            '${p.dignity.isNotEmpty ? "  ·  ${KTerms.dignity(l, p.dignity)}" : ""}',
                            style: const TextStyle(fontSize: 12, height: 1.4),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  v.disclaimer,
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

  Widget _row(BuildContext context, String k, String value) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: RichText(
        text: TextSpan(
          style: theme.textTheme.bodySmall?.copyWith(fontSize: 13),
          children: [
            TextSpan(
              text: '$k  ',
              style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
