import 'package:astro_kundali/astro_kundali.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/brand_colors.dart';
import '../cubit/kundali_cubit.dart';
import '../kundali_terms.dart';
import '../widgets/kundali_ui.dart';

/// Numerology + Lo Shu birth grid (`/numerology`). Traditional, descriptive —
/// tendencies, favourable days and colours, no dated prediction. Gemstones are
/// gated behind an astrologer, like every other remedy in the app.
class NumerologyPage extends StatefulWidget {
  const NumerologyPage({required this.profileId, super.key});
  final String profileId;

  @override
  State<NumerologyPage> createState() => _NumerologyPageState();
}

class _NumerologyPageState extends State<NumerologyPage> {
  @override
  void initState() {
    super.initState();
    context.read<KundaliCubit>().loadNumerology();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.numerologyTitle)),
      body: BlocBuilder<KundaliCubit, KundaliState>(
        buildWhen: (a, b) => a.numerology != b.numerology,
        builder: (context, state) => SliceBuilder<NumerologyReport>(
          slice: state.numerology,
          onRetry: () => context.read<KundaliCubit>().loadNumerology(),
          builder: (context, report) {
            final theme = Theme.of(context);
            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
              children: [
                Text(
                  l.numerologyIntro,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 14),
                for (final n in report.numbers) ...[
                  _NumberCard(number: n),
                  const SizedBox(height: 10),
                ],
                if (report.combination.isNotEmpty) ...[
                  KCard(
                    child: Text(
                      report.combination,
                      style: const TextStyle(fontSize: 13, height: 1.5),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
                _LoShuCard(grid: report.loShu),
                const SizedBox(height: 12),
                Text(
                  report.disclaimer,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                AskAstrologerBar(
                  label: l.numAskCta,
                  onTap: () => context.go(Routes.astrologers),
                ),
                const SizedBox(height: 36),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _NumberCard extends StatelessWidget {
  const _NumberCard({required this.number});
  final NumerologyNumber number;

  String _kindLabel(AppLocalizations l) => switch (number.kind) {
    'moolank' => l.numMoolank,
    'bhagyank' => l.numBhagyank,
    'naamank' => l.numNaamank,
    _ => number.kind,
  };

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return KCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${number.value}',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _kindLabel(l),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: 14,
                      ),
                    ),
                    if (number.planet.isNotEmpty)
                      Text(
                        l.numRuledBy(KTerms.planetName(l, number.planet)),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          if (number.summary.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              number.summary,
              style: const TextStyle(fontSize: 13, height: 1.5),
            ),
          ],
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              if (number.friendly.isNotEmpty)
                _MiniChip(
                  label: '${l.numFriendly}: ${number.friendly.join(", ")}',
                  tone: _ChipTone.good,
                ),
              if (number.unfriendly.isNotEmpty)
                _MiniChip(
                  label: '${l.numUnfriendly}: ${number.unfriendly.join(", ")}',
                  tone: _ChipTone.warn,
                ),
            ],
          ),
          const SizedBox(height: 8),
          _kv(context, l.numFavDays, number.days.join(', ')),
          _kv(context, l.numFavColours, number.colours.join(', ')),
          _kv(context, l.numDirection, number.direction),
          _kv(context, l.numDeity, number.deity),
          if (number.gemstone.isNotEmpty) ...[
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
                    '${l.numGemstone}: ${number.gemstone}',
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF8A5316),
                    ),
                  ),
                  if (number.gemstoneNote.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(
                      number.gemstoneNote,
                      style: const TextStyle(
                        fontSize: 11.5,
                        height: 1.35,
                        color: Color(0xFF8A5316),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _kv(BuildContext context, String k, String v) {
    if (v.trim().isEmpty) return const SizedBox.shrink();
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: RichText(
        text: TextSpan(
          style: theme.textTheme.bodySmall?.copyWith(
            fontSize: 12.5,
            height: 1.4,
          ),
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
  }
}

class _LoShuCard extends StatelessWidget {
  const _LoShuCard({required this.grid});
  final LoShuGrid grid;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return KCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.numLoShuTitle,
            style: theme.textTheme.titleMedium?.copyWith(fontSize: 15),
          ),
          const SizedBox(height: 12),
          Center(
            child: GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
              children: [
                for (final n in grid.layout)
                  _LoShuCell(n: n, count: grid.countOf(n)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (grid.missing.isNotEmpty)
            Text(
              l.numLoShuMissing(grid.missing.join(', ')),
              style: const TextStyle(fontSize: 12.5, height: 1.4),
            ),
          if (grid.repeated.isNotEmpty)
            Text(
              l.numLoShuRepeated(grid.repeated.join(', ')),
              style: const TextStyle(fontSize: 12.5, height: 1.4),
            ),
          const SizedBox(height: 10),
          for (final line in grid.lines.where(
            (x) => x.status != 'partial',
          )) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _MiniChip(
                    label: line.status == 'strength'
                        ? l.numArrowStrength
                        : l.numArrowAbsence,
                    tone: line.status == 'strength'
                        ? _ChipTone.good
                        : _ChipTone.warn,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      line.gloss,
                      style: const TextStyle(fontSize: 12, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (grid.summary.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              grid.summary,
              style: TextStyle(
                fontSize: 12.5,
                height: 1.45,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _LoShuCell extends StatelessWidget {
  const _LoShuCell({required this.n, required this.count});
  final int n;
  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final present = count > 0;
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: present
            ? theme.colorScheme.primaryContainer.withValues(alpha: 0.5)
            : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: context.brand.hairline),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            present ? '$n' * count : '$n',
            style: TextStyle(
              fontSize: present ? 17 : 14,
              fontWeight: present ? FontWeight.w800 : FontWeight.w400,
              color: present
                  ? theme.colorScheme.onSurface
                  : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}

enum _ChipTone { good, warn }

class _MiniChip extends StatelessWidget {
  const _MiniChip({required this.label, required this.tone});
  final String label;
  final _ChipTone tone;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (tone) {
      _ChipTone.good => (const Color(0xFFDDF0E4), const Color(0xFF2C6B45)),
      _ChipTone.warn => (const Color(0xFFFBEBD8), const Color(0xFFB0691F)),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: fg),
      ),
    );
  }
}
