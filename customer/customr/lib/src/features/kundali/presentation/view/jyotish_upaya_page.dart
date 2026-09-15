import 'package:astro_kundali/astro_kundali.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/routes.dart';
import '../cubit/kundali_cubit.dart';
import '../kundali_terms.dart';
import '../widgets/kundali_ui.dart';

/// Jyotish upaya (`/jyotish-upaya`) — the per-planet remedy table. Colour, day,
/// deity, mantra and charity are free to adopt; gemstone and rudraksha lines are
/// ALWAYS shown behind a "confirm with an astrologer first" gate.
class JyotishUpayaPage extends StatefulWidget {
  const JyotishUpayaPage({required this.profileId, super.key});
  final String profileId;

  @override
  State<JyotishUpayaPage> createState() => _JyotishUpayaPageState();
}

class _JyotishUpayaPageState extends State<JyotishUpayaPage> {
  @override
  void initState() {
    super.initState();
    context.read<KundaliCubit>().loadJyotishUpaya();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.upayaTitle)),
      body: BlocBuilder<KundaliCubit, KundaliState>(
        buildWhen: (a, b) => a.jyotishUpaya != b.jyotishUpaya,
        builder: (context, state) => SliceBuilder<JyotishUpayaReport>(
          slice: state.jyotishUpaya,
          onRetry: () => context.read<KundaliCubit>().loadJyotishUpaya(),
          builder: (context, r) {
            final theme = Theme.of(context);
            final ordered = [
              ...r.planets.where((p) => p.priority),
              ...r.planets.where((p) => p.isStrengthen && !p.priority),
              ...r.planets.where((p) => !p.isStrengthen && !p.priority),
            ];
            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
              children: [
                Text(
                  l.upayaIntro(r.lagnaSign),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                _LagnaCard(report: r),
                const SizedBox(height: 10),
                if (r.gateNotice.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(11),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFBEBD8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.info_outline_rounded,
                          size: 17,
                          color: Color(0xFF8A5316),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            r.gateNotice,
                            style: const TextStyle(
                              fontSize: 11.5,
                              height: 1.4,
                              color: Color(0xFF8A5316),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                for (final p in ordered) ...[
                  _PlanetCard(planet: p),
                  const SizedBox(height: 10),
                ],
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

class _LagnaCard extends StatelessWidget {
  const _LagnaCard({required this.report});
  final JyotishUpayaReport report;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    Widget kv(String k, String v) => Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: RichText(
        text: TextSpan(
          style: theme.textTheme.bodySmall?.copyWith(fontSize: 12.5),
          children: [
            TextSpan(
              text: '$k  ',
              style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
            ),
            TextSpan(text: v),
          ],
        ),
      ),
    );
    return KCard(
      tint: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.upayaLagnaFavourable,
            style: theme.textTheme.titleMedium?.copyWith(fontSize: 14),
          ),
          const SizedBox(height: 8),
          kv(l.upayaColours, report.lagnaColours.join(', ')),
          kv(l.upayaDirection, report.lagnaDirection),
          kv(l.upayaDay, report.lagnaDay),
          kv(l.upayaDeity, report.lagnaDeity),
          if (report.summary.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              report.summary,
              style: const TextStyle(fontSize: 12.5, height: 1.45),
            ),
          ],
        ],
      ),
    );
  }
}

class _PlanetCard extends StatelessWidget {
  const _PlanetCard({required this.planet});
  final UpayaPlanet planet;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final (roleLabel, roleColor) = switch (planet.role) {
      'strengthen' => (l.upayaStrengthen, const Color(0xFF2C6B45)),
      'pacify' => (l.upayaPacify, const Color(0xFFB0691F)),
      'mixed' => (l.upayaMixed, const Color(0xFF3F4E86)),
      _ => (l.upayaNeutral, theme.colorScheme.onSurfaceVariant),
    };
    return KCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  KTerms.planetName(context.l10n, planet.planet),
                  style: theme.textTheme.titleMedium?.copyWith(fontSize: 14),
                ),
              ),
              if (planet.priority)
                Container(
                  margin: const EdgeInsets.only(right: 6),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDDF0E4),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    l.upayaPriority,
                    style: const TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF2C6B45),
                    ),
                  ),
                ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: roleColor.withValues(alpha: 0.13),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  roleLabel,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: roleColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            planet.summary,
            style: const TextStyle(fontSize: 12.5, height: 1.45),
          ),
          const SizedBox(height: 8),
          Text(
            l.upayaFreeMeasures,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            '${l.upayaColours}: ${planet.colours.join(", ")}  ·  '
            '${l.upayaDirection}: ${planet.direction}',
            style: const TextStyle(fontSize: 12, height: 1.4),
          ),
          Text(
            '${l.upayaMantra}: ${planet.mantra}',
            style: const TextStyle(fontSize: 12, height: 1.4),
          ),
          Text(
            '${l.upayaCharity}: ${planet.charity}',
            style: const TextStyle(fontSize: 12, height: 1.4),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFFBEBD8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${l.upayaGemstone}: ${planet.gemstone}'
                  '${planet.gemstoneSubstitute.isNotEmpty && planet.gemstoneSubstitute != "-" ? " (${l.kUpOr(planet.gemstoneSubstitute)})" : ""}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF8A5316),
                  ),
                ),
                if (planet.gemstoneMetal.isNotEmpty)
                  Text(
                    '${planet.gemstoneMetal} · ${l.kUpFinger(planet.gemstoneFinger)} · ${planet.gemstoneStartDay}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF8A5316),
                    ),
                  ),
                if (planet.rudrakshaMukhi.isNotEmpty)
                  Text(
                    '${l.upayaRudraksha}: ${planet.rudrakshaMukhi}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF8A5316),
                    ),
                  ),
                const SizedBox(height: 4),
                InkWell(
                  onTap: () => context.go(Routes.astrologers),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.verified_user_outlined,
                        size: 14,
                        color: Color(0xFF8A5316),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        l.upayaGatedCta,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF8A5316),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
