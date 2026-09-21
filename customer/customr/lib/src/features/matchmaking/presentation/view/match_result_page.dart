import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/astro_palette.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../../core/util/async_value.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/fade_slide_in.dart';
import '../../../../shared/widgets/pressable.dart';
import '../../../../shared/widgets/score_ring.dart';
import '../../../kundali/presentation/kundali_terms.dart';
import '../../../consultations/presentation/view/widgets/share_with_astrologer.dart';
import '../../data/models/match_result.dart';
import '../cubit/matchmaking_cubit.dart';
import 'widgets/match_widgets.dart';

class MatchResultPage extends StatefulWidget {
  const MatchResultPage({super.key});

  @override
  State<MatchResultPage> createState() => _MatchResultPageState();
}

class _MatchResultPageState extends State<MatchResultPage> {
  @override
  void initState() {
    super.initState();
    context.read<MatchResultCubit>().load();
  }

  void _share(MatchResult m) {
    final l = context.l10n;
    final lines = [
      l.matchPairNames(m.boy.name, m.girl.name),
      l.matchShareScore(m.pointsLabel, verdictLabel(l, m.verdictKey)),
      '',
      for (final k in m.kootas)
        '${kootaLabel(l, k.key)}: ${_pts(k.obtained)}/${_pts(k.maximum)}',
      if (m.manglik != null) ...['', manglikBody(l, m.manglik!.status)],
      '',
      '— TalkAcharya',
    ];
    Share.share(lines.join('\n'));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    return BlocBuilder<MatchResultCubit, AsyncValue<MatchResult>>(
      builder: (context, state) {
        final m = state.value;
        return Scaffold(
          backgroundColor: brand.canvas,
          appBar: AppBar(
            title: Text(l.matchResultTitle),
            actions: [
              if (m != null)
                IconButton(
                  tooltip: l.horoShare,
                  icon: const Icon(Icons.ios_share_rounded),
                  onPressed: () => _share(m),
                ),
            ],
          ),
          body: state.when(
            idle: () => const Center(child: CircularProgressIndicator()),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (msg) => ErrorView(
              message: msg,
              onRetry: () => context.read<MatchResultCubit>().load(force: true),
            ),
            data: (m) => ListView(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 40),
              children: FadeSlideIn.list([
                _ScoreHero(match: m),
                const SizedBox(height: 14),
                _QuickChecks(match: m),
                if (m.manglik != null && m.manglik!.status.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  _ManglikCard(match: m),
                ],
                const SizedBox(height: 22),
                _SectionTitle(l.matchBreakdownTitle, l.matchBreakdownSub),
                const SizedBox(height: 10),
                for (final k in m.kootas) ...[
                  _KootaTile(koota: k),
                  const SizedBox(height: 10),
                ],
                if (m.boyInfo.rasi.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _SectionTitle(l.matchChartsTitle, null),
                  const SizedBox(height: 10),
                  _ChartsCompare(match: m),
                ],
                const SizedBox(height: 18),
                _AskAstrologer(match: m),
                const SizedBox(height: 14),
                Text(
                  l.matchDisclaimer,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: brand.inkMuted,
                    height: 1.4,
                  ),
                ),
              ], step: const Duration(milliseconds: 40)),
            ),
          ),
        );
      },
    );
  }
}

String _pts(double v) =>
    v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(1);

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title, this.subtitle);
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.textTheme.titleLarge?.copyWith(fontSize: 20)),
        if (subtitle != null)
          Text(
            subtitle!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: context.brand.inkMuted,
            ),
          ),
      ],
    );
  }
}

// --- score hero ---------------------------------------------------------------------

class _ScoreHero extends StatelessWidget {
  const _ScoreHero({required this.match});
  final MatchResult match;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final band = AstroPalette.ratio(match.ratio);
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AstroPalette.romance,
        ),
        boxShadow: [
          BoxShadow(
            color: AstroPalette.romance[1].withValues(alpha: 0.35),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          const Positioned.fill(child: CustomPaint(painter: HeartsPainter())),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _Person(
                        person: match.boy,
                        hue: AstroPalette.partnerA,
                        label: l.matchBoy,
                      ),
                    ),
                    const PulsingHeart(size: 36),
                    Expanded(
                      child: _Person(
                        person: match.girl,
                        hue: AstroPalette.partnerB,
                        label: l.matchGirl,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.14),
                  ),
                  child: ScoreRing(
                    value: match.ratio,
                    size: 168,
                    stroke: 14,
                    colors: [band.start, band.end, band.start],
                    trackColor: Colors.white.withValues(alpha: 0.2),
                    center: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: match.total),
                          duration: const Duration(milliseconds: 1100),
                          curve: Curves.easeOutCubic,
                          builder: (context, v, _) => Text(
                            _pts((v * 2).round() / 2),
                            style: theme.textTheme.displaySmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              height: 1,
                            ),
                          ),
                        ),
                        Text(
                          l.matchOutOf36,
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.auto_awesome_rounded,
                        size: 16,
                        color: band.end,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        verdictLabel(l, match.verdictKey),
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: band.end,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  verdictBody(l, match.verdictKey),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    height: 1.45,
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

class _Person extends StatelessWidget {
  const _Person({required this.person, required this.hue, required this.label});
  final MatchPerson person;
  final AstroHue hue;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        PersonAvatar(
          initials: person.initials,
          hue: hue,
          size: 58,
          ring: Colors.white,
        ),
        const SizedBox(height: 8),
        Text(
          person.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}

// --- quick checks ---------------------------------------------------------------------

class _QuickChecks extends StatelessWidget {
  const _QuickChecks({required this.match});
  final MatchResult match;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final items = <(String, bool)>[
      if (match.manglik != null && match.manglik!.status.isNotEmpty)
        (l.matchManglikShort, match.manglik!.compatible),
      for (final k in const ['nadi', 'bhakoot', 'gana'])
        if (match.doshas.containsKey(k)) (doshaLabel(l, k), !match.doshas[k]!),
    ];
    if (items.isEmpty) return const SizedBox.shrink();
    final ok = AstroPalette.band(5);
    final bad = AstroPalette.band(1);
    final theme = Theme.of(context);
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final (label, good) in items)
          Container(
            padding: const EdgeInsets.fromLTRB(8, 7, 12, 7),
            decoration: BoxDecoration(
              color: (good ? ok : bad).tint(0.12),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: (good ? ok : bad).end.withValues(alpha: 0.45),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  good ? Icons.check_circle_rounded : Icons.error_rounded,
                  size: 18,
                  color: (good ? ok : bad).end,
                ),
                const SizedBox(width: 6),
                Text(
                  good ? l.matchCheckClear(label) : l.matchCheckPresent(label),
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: (good ? ok : bad).end,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _ManglikCard extends StatelessWidget {
  const _ManglikCard({required this.match});
  final MatchResult match;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    final mk = match.manglik!;
    final hue = mk.compatible ? AstroPalette.band(5) : AstroPalette.band(2);

    Widget side(MatchPerson p, ManglikSide s, AstroHue personHue) => Expanded(
      child: Row(
        children: [
          PersonAvatar(initials: p.initials, hue: personHue, size: 32),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  !s.isManglik
                      ? l.matchNotManglik
                      : s.isCancelled
                      ? l.matchManglikCancelledShort
                      : l.matchIsManglik,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: s.isManglik && !s.isCancelled
                        ? AstroPalette.band(2).end
                        : AstroPalette.band(5).end,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: brand.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: hue.linear(),
                ),
                child: const Icon(
                  Icons.local_fire_department_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  l.matchManglikTitle,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            manglikBody(l, mk.status),
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.45),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              side(match.boy, mk.boy, AstroPalette.partnerA),
              const SizedBox(width: 10),
              side(match.girl, mk.girl, AstroPalette.partnerB),
            ],
          ),
        ],
      ),
    );
  }
}

// --- koota breakdown -----------------------------------------------------------------

class _KootaTile extends StatefulWidget {
  const _KootaTile({required this.koota});
  final Koota koota;

  @override
  State<_KootaTile> createState() => _KootaTileState();
}

class _KootaTileState extends State<_KootaTile> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final k = widget.koota;
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    final hue = kootaHue(k.key);
    final scoreHue = AstroPalette.ratio(k.ratio);
    final isDosha =
        k.isZero && const {'nadi', 'bhakoot', 'gana'}.contains(k.key);

    return Pressable(
      scale: 0.99,
      child: Material(
        color: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(
            color: isDosha
                ? AstroPalette.band(1).end.withValues(alpha: 0.5)
                : brand.hairline,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => setState(() => _open = !_open),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 14, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: hue.linear(),
                      ),
                      child: Icon(
                        kootaIcon(k.key),
                        color: Colors.white,
                        size: 21,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  kootaLabel(l, k.key),
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              if (isDosha) ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 1,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AstroPalette.band(1).tint(0.14),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    l.matchDoshaTag,
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: AstroPalette.band(1).end,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          Text(
                            kootaMeaning(l, k.key),
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: brand.inkMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    RichText(
                      text: TextSpan(
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: brand.ink,
                        ),
                        children: [
                          TextSpan(
                            text: _pts(k.obtained),
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: scoreHue.end,
                            ),
                          ),
                          TextSpan(
                            text: '/${_pts(k.maximum)}',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: brand.inkMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AnimatedRotation(
                      turns: _open ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.expand_more_rounded,
                        color: brand.inkMuted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: Stack(
                    children: [
                      Container(height: 8, color: hue.tint(0.14)),
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: k.ratio),
                        duration: const Duration(milliseconds: 900),
                        curve: Curves.easeOutCubic,
                        builder: (context, v, _) => FractionallySizedBox(
                          widthFactor: v,
                          child: Container(
                            height: 8,
                            decoration: BoxDecoration(
                              gradient: scoreHue.linear(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  child: _open
                      ? Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            kootaDetail(l, k.key),
                            style: theme.textTheme.bodySmall?.copyWith(
                              height: 1.5,
                            ),
                          ),
                        )
                      : const SizedBox(width: double.infinity),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- charts comparison ---------------------------------------------------------------

class _ChartsCompare extends StatelessWidget {
  const _ChartsCompare({required this.match});
  final MatchResult match;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    final rows = <(String, String, String)>[
      (
        l.matchRowRasi,
        KTerms.signName(l, match.boyInfo.rasi),
        KTerms.signName(l, match.girlInfo.rasi),
      ),
      (
        l.matchRowNakshatra,
        KTerms.nakshatraName(l, match.boyInfo.nakshatra),
        KTerms.nakshatraName(l, match.girlInfo.nakshatra),
      ),
      if (match.boyInfo.gana.isNotEmpty)
        (l.matchRowGana, match.boyInfo.gana, match.girlInfo.gana),
      if (match.boyInfo.yoni.isNotEmpty)
        (l.matchRowYoni, match.boyInfo.yoni, match.girlInfo.yoni),
    ];
    TextStyle? head(AstroHue h) => theme.textTheme.labelLarge?.copyWith(
      color: h.end,
      fontWeight: FontWeight.w800,
    );

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: brand.hairline),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AstroPalette.partnerA.tint(0.12),
                  AstroPalette.partnerB.tint(0.12),
                ],
              ),
            ),
            child: Row(
              children: [
                const Expanded(flex: 4, child: SizedBox()),
                Expanded(
                  flex: 5,
                  child: Text(
                    match.boy.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: head(AstroPalette.partnerA),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Text(
                    match.girl.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: head(AstroPalette.partnerB),
                  ),
                ),
              ],
            ),
          ),
          for (var i = 0; i < rows.length; i++)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
              decoration: BoxDecoration(
                border: i == 0
                    ? null
                    : Border(top: BorderSide(color: brand.hairline)),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Text(
                      rows[i].$1,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: brand.inkMuted,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Text(
                      rows[i].$2,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Text(
                      rows[i].$3,
                      style: const TextStyle(fontWeight: FontWeight.w700),
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

class _AskAstrologer extends StatelessWidget {
  const _AskAstrologer({required this.match});

  final MatchResult match;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [context.brand.cosmicStart, context.brand.cosmicEnd],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.matchAskTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: context.brand.onCosmic,
                    fontFamily: theme.textTheme.titleLarge?.fontFamily,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l.matchAskBody,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: context.brand.onCosmicMuted,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(0, 42),
                    backgroundColor: context.brand.gold,
                    foregroundColor: context.brand.cosmicStart,
                  ),
                  onPressed: () => shareWithAstrologer(
                    context,
                    matchId: match.id,
                    label: '${match.boy.name} & ${match.girl.name}',
                  ),
                  icon: const Icon(Icons.chat_rounded, size: 18),
                  label: Text(l.horoCtaButton),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.diversity_1_rounded,
            size: 56,
            color: context.brand.cosmicAccent,
          ),
        ],
      ),
    );
  }
}
