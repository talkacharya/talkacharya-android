import 'package:astro_kundali/astro_kundali.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/astro_palette.dart';
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
    return BlocBuilder<KundaliCubit, KundaliState>(
      buildWhen: (a, b) => a.numerology != b.numerology,
      builder: (context, state) {
        final cubit = context.read<KundaliCubit>();
        final report = state.numerology.value;
        final moolank = report?.numbers
            .where((n) => n.kind == 'moolank')
            .firstOrNull;
        final hue = moolank == null ? AstroPalette.career : _numberHue(moolank);

        return KundaliScaffold(
          title: l.numerologyTitle,
          eyebrow: l.kOvTitle,
          headline: l.numerologyTitle,
          subheadline: l.kNumHeroSub,
          hue: hue,
          heroTrailing: KHeroGlyph(
            hue: hue,
            text: report == null || report.moolank == 0
                ? null
                : '${report.moolank}',
            icon: report == null || report.moolank == 0
                ? Icons.tag_rounded
                : null,
            size: 72,
          ),
          heroChips: report == null
              ? const []
              : [
                  if (report.moolank > 0)
                    KHeroChip(label: '${l.numMoolank} ${report.moolank}'),
                  if (report.bhagyank > 0)
                    KHeroChip(label: '${l.numBhagyank} ${report.bhagyank}'),
                ],
          onRefresh: () => cubit.loadNumerology(force: true),
          animate: report != null,
          children: report == null
              ? [
                  SliceBuilder<NumerologyReport>(
                    slice: state.numerology,
                    onRetry: () => cubit.loadNumerology(force: true),
                    skeleton: const KBodySkeleton(blocks: [90, 180, 180, 260]),
                    builder: (_, _) => const SizedBox.shrink(),
                  ),
                ]
              : [
                  Text(
                    l.numerologyIntro,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: context.brand.inkMuted,
                      height: 1.45,
                    ),
                  ),
                  if (report.numbers.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    _NumberStrip(numbers: report.numbers),
                  ],
                  if (report.combination.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    ReadingCard(body: report.combination, hue: hue),
                  ],
                  KSection(
                    title: l.kNumYourNumbers,
                    hue: hue,
                    child: Column(
                      children: [
                        for (final n in report.numbers)
                          _NumberCard(
                            number: n,
                            initiallyOpen: n.kind == 'moolank',
                          ),
                      ],
                    ),
                  ),
                  KSection(
                    title: l.numLoShuTitle,
                    hue: AstroPalette.earth,
                    child: _LoShuCard(grid: report.loShu),
                  ),
                  if (report.disclaimer.isNotEmpty)
                    KFootnote(report.disclaimer),
                  KAskCta(title: l.numAskCta),
                ],
        );
      },
    );
  }
}

AstroHue _numberHue(NumerologyNumber n) =>
    n.planet.isEmpty ? AstroPalette.career : kPlanetHue(n.planet);

String _kindLabel(AppLocalizations l, String kind) => switch (kind) {
  'moolank' => l.numMoolank,
  'bhagyank' => l.numBhagyank,
  'naamank' => l.numNaamank,
  _ => kind,
};

/// The core numbers side by side as gradient medallions.
class _NumberStrip extends StatelessWidget {
  const _NumberStrip({required this.numbers});
  final List<NumerologyNumber> numbers;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return Row(
      children: [
        for (var i = 0; i < numbers.length; i++) ...[
          if (i > 0) const SizedBox(width: 10),
          Expanded(
            child: KHueCard(
              hue: _numberHue(numbers[i]),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
              child: Column(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: _numberHue(numbers[i]).linear(),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${numbers[i].value}',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _kindLabel(l, numbers[i].kind),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (numbers[i].planet.isNotEmpty)
                    Text(
                      KTerms.planetName(l, numbers[i].planet),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: context.brand.inkMuted,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _NumberCard extends StatelessWidget {
  const _NumberCard({required this.number, this.initiallyOpen = false});
  final NumerologyNumber number;
  final bool initiallyOpen;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final hue = _numberHue(number);
    return KExpandable(
      initiallyOpen: initiallyOpen,
      header: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: hue.linear(),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              '${number.value}',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _kindLabel(l, number.kind),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (number.planet.isNotEmpty)
                  Text(
                    l.numRuledBy(KTerms.planetName(l, number.planet)),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: context.brand.inkMuted,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (number.summary.isNotEmpty)
            Text(
              number.summary,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
            ),
          if (number.friendly.isNotEmpty || number.unfriendly.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                if (number.friendly.isNotEmpty)
                  KToneChip(
                    '${l.numFriendly}: ${number.friendly.join(", ")}',
                    tone: KTone.good,
                  ),
                if (number.unfriendly.isNotEmpty)
                  KToneChip(
                    '${l.numUnfriendly}: ${number.unfriendly.join(", ")}',
                    tone: KTone.caution,
                  ),
              ],
            ),
          ],
          const SizedBox(height: 4),
          if (number.days.isNotEmpty)
            KInfoRow(
              icon: Icons.calendar_today_rounded,
              hue: AstroPalette.career,
              label: l.numFavDays,
              value: number.days.join(', '),
            ),
          if (number.colours.isNotEmpty)
            KInfoRow(
              icon: Icons.palette_rounded,
              hue: AstroPalette.love,
              label: l.numFavColours,
              value: number.colours.join(', '),
            ),
          if (number.direction.trim().isNotEmpty)
            KInfoRow(
              icon: Icons.explore_rounded,
              hue: AstroPalette.air,
              label: l.numDirection,
              value: number.direction,
            ),
          if (number.deity.trim().isNotEmpty)
            KInfoRow(
              icon: Icons.temple_hindu_rounded,
              hue: AstroPalette.money,
              label: l.numDeity,
              value: number.deity,
            ),
          if (number.gemstone.isNotEmpty)
            KNoteBox(
              title: '${l.numGemstone}: ${number.gemstone}',
              icon: Icons.lock_outline_rounded,
              hue: AstroPalette.money,
              child: number.gemstoneNote.isEmpty
                  ? null
                  : Text(
                      number.gemstoneNote,
                      style: theme.textTheme.bodySmall?.copyWith(height: 1.4),
                    ),
            ),
        ],
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
    final arrows = grid.lines.where((x) => x.status != 'partial').toList();
    return KSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 260),
              child: KCosmicPanel(
                hue: AstroPalette.earth,
                padding: const EdgeInsets.all(10),
                child: GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  children: [
                    for (final n in grid.layout)
                      _LoShuCell(n: n, count: grid.countOf(n)),
                  ],
                ),
              ),
            ),
          ),
          if (grid.missing.isNotEmpty || grid.repeated.isNotEmpty) ...[
            const SizedBox(height: 14),
            if (grid.missing.isNotEmpty)
              _NumberRow(
                label: l.kNumMissing,
                numbers: grid.missing,
                hue: AstroPalette.money,
              ),
            if (grid.repeated.isNotEmpty)
              _NumberRow(
                label: l.kNumRepeated,
                numbers: grid.repeated,
                hue: AstroPalette.health,
              ),
          ],
          if (arrows.isNotEmpty) ...[
            const SizedBox(height: 8),
            for (final line in arrows)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    KToneChip(
                      line.status == 'strength'
                          ? l.numArrowStrength
                          : l.numArrowAbsence,
                      tone: line.status == 'strength'
                          ? KTone.good
                          : KTone.caution,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      line.gloss,
                      style: theme.textTheme.bodySmall?.copyWith(height: 1.45),
                    ),
                  ],
                ),
              ),
          ],
          if (grid.summary.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              grid.summary,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: context.brand.inkMuted,
                height: 1.45,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _NumberRow extends StatelessWidget {
  const _NumberRow({
    required this.label,
    required this.numbers,
    required this.hue,
  });
  final String label;
  final List<int> numbers;
  final AstroHue hue;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: context.brand.inkMuted),
          ),
        ),
        Flexible(
          child: Wrap(
            alignment: WrapAlignment.end,
            spacing: 6,
            runSpacing: 6,
            children: [for (final n in numbers) KPill('$n', hue: hue)],
          ),
        ),
      ],
    ),
  );
}

class _LoShuCell extends StatelessWidget {
  const _LoShuCell({required this.n, required this.count});
  final int n;
  final int count;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final present = count > 0;
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: present ? AstroPalette.money.linear() : null,
        color: present ? null : Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: present
              ? Colors.white.withValues(alpha: 0.3)
              : Colors.white.withValues(alpha: 0.12),
        ),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Text(
            present ? '$n' * count : '$n',
            style: TextStyle(
              fontSize: present ? 20 : 16,
              fontWeight: present ? FontWeight.w800 : FontWeight.w400,
              color: present
                  ? Colors.white
                  : brand.onCosmicMuted.withValues(alpha: 0.5),
            ),
          ),
        ),
      ),
    );
  }
}
