import 'package:astro_kundali/astro_kundali.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/network/friendly_error.dart';
import '../../../../core/theme/astro_palette.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../data/kundali_repository.dart';
import '../kundali_terms.dart';
import '../widgets/kundali_ui.dart';

/// One level of the dasha tree, in full.
///
/// Four levels do not nest on a phone — by the third indent there is no room
/// left for a date. So each level gets the whole screen, with the path back up
/// as a breadcrumb: the reader is always looking at one complete timeline
/// rather than a fragment of four.
class DashaLevelPage extends StatefulWidget {
  const DashaLevelPage({
    required this.profileId,
    required this.path,
    super.key,
  });

  final String profileId;

  /// Lords from the top down. Empty would be the mahadashas, which the main
  /// Dasha page already shows.
  final List<String> path;

  @override
  State<DashaLevelPage> createState() => _DashaLevelPageState();
}

class _DashaLevelPageState extends State<DashaLevelPage> {
  late Future<DashaLevel> _future = _load();

  Future<DashaLevel> _load() =>
      getIt<KundaliRepository>().dashaPeriods(widget.profileId, widget.path);

  String _levelName(AppLocalizations l, String level) => switch (level) {
    'antar' => l.kDashaAntar,
    'pratyantar' => l.kDashaPratyantar,
    'sookshma' => l.kDashaSookshma,
    _ => l.kDashaMaha,
  };

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final hue = widget.path.isEmpty
        ? AstroPalette.career
        : kPlanetHue(widget.path.last);

    return FutureBuilder<DashaLevel>(
      future: _future,
      builder: (context, snap) {
        final data = snap.data;
        final level = data?.level ?? '';
        // The breadcrumb is the whole orientation story: Venus › Sun › Moon.
        final trail = widget.path
            .map((lord) => KTerms.displayName(l, lord))
            .join(' › ');

        return KundaliScaffold(
          title: _levelName(l, level),
          eyebrow: trail,
          headline: data?.parent == null
              ? _levelName(l, level)
              : l.kDashaInside(
                  KTerms.displayName(l, data!.parent!.lord),
                  _levelName(l, level),
                ),
          subheadline: data?.parent == null
              ? null
              : _range(context, data!.parent!.start, data.parent!.end),
          hue: hue,
          heroTrailing: widget.path.isEmpty
              ? null
              : KHeroGlyph(
                  hue: hue,
                  text: KundaliStrings.of(context).planetToken(widget.path.last),
                  size: 64,
                ),
          onRefresh: () async => setState(() => _future = _load()),
          children: [
            if (snap.connectionState != ConnectionState.done)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 48),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (data == null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Text(
                    snap.error == null
                        ? l.commonSomethingWentWrong
                        : friendlyError(snap.error!),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: context.brand.inkMuted),
                  ),
                ),
              )
            else
              _Rail(
                profileId: widget.profileId,
                path: widget.path,
                data: data,
              ),
          ],
        );
      },
    );
  }
}

String _range(BuildContext context, DateTime from, DateTime to) {
  // Short periods need the time of day; a mahadasha does not.
  final short = to.difference(from).inDays < 2;
  final fmt = DateFormat(short ? 'd MMM yyyy, HH:mm' : 'd MMM yyyy');
  return '${fmt.format(from)} — ${fmt.format(to)}';
}

class _Rail extends StatelessWidget {
  const _Rail({required this.profileId, required this.path, required this.data});

  final String profileId;
  final List<String> path;
  final DashaLevel data;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < data.periods.length; i++)
          _PeriodRow(
            node: data.periods[i],
            expandable: data.expandable,
            first: i == 0,
            last: i == data.periods.length - 1,
            onTap: !data.expandable
                ? null
                : () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => DashaLevelPage(
                        profileId: profileId,
                        path: [...path, data.periods[i].lord],
                      ),
                    ),
                  ),
          ),
      ],
    );
  }
}

class _PeriodRow extends StatelessWidget {
  const _PeriodRow({
    required this.node,
    required this.expandable,
    required this.first,
    required this.last,
    this.onTap,
  });

  final DashaNode node;
  final bool expandable;
  final bool first;
  final bool last;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    final hue = kPlanetHue(node.lord);
    final now = DateTime.now();
    const dotCenter = 22.0;

    return Stack(
      children: [
        // The rail runs behind the cards so a row can grow without forcing an
        // intrinsic-height pass over the whole list.
        Positioned(
          left: 13,
          top: first ? dotCenter : 0,
          bottom: last ? null : 0,
          height: last ? dotCenter : null,
          child: Container(width: 2, color: brand.hairline),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 28,
              height: dotCenter * 2,
              child: Center(
                child: Container(
                  width: node.isCurrent ? 12 : 8,
                  height: node.isCurrent ? 12 : 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: node.isCurrent ? hue.linear() : null,
                    color: node.isCurrent
                        ? null
                        : (node.isPast ? brand.hairline : brand.inkMuted),
                    border: node.isCurrent
                        ? Border.all(color: theme.colorScheme.surface, width: 2)
                        : null,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Material(
                  color: node.isCurrent
                      ? hue.tint(0.16)
                      : theme.colorScheme.surfaceContainerHighest.withValues(
                          alpha: node.isPast ? 0.35 : 0.6,
                        ),
                  borderRadius: BorderRadius.circular(14),
                  child: InkWell(
                    onTap: onTap,
                    borderRadius: BorderRadius.circular(14),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 10, 10, 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        KTerms.displayName(l, node.lord),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: theme.textTheme.titleSmall
                                            ?.copyWith(
                                              fontWeight: node.isCurrent
                                                  ? FontWeight.w800
                                                  : FontWeight.w700,
                                            ),
                                      ),
                                    ),
                                    if (node.isCurrent) ...[
                                      const SizedBox(width: 6),
                                      KPill(l.kDashaNow, hue: hue),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  _range(context, node.start, node.end),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: brand.inkMuted,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _duration(l, node),
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: brand.inkMuted,
                                  ),
                                ),
                                if (node.isCurrent) ...[
                                  const SizedBox(height: 7),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(999),
                                    child: LinearProgressIndicator(
                                      value: node.progress(now),
                                      minHeight: 4,
                                      backgroundColor: brand.hairline,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          if (onTap != null) ...[
                            const SizedBox(width: 6),
                            Icon(
                              Icons.chevron_right_rounded,
                              size: 20,
                              color: brand.inkMuted,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Years for the long levels, days for the short ones — "0 years" on a
  /// sookshma tells the reader nothing.
  String _duration(AppLocalizations l, DashaNode node) {
    if (node.days < 1) {
      return l.kDashaHours(node.end.difference(node.start).inHours);
    }
    if (node.days < 90) return l.kDashaDays(node.days.round());
    if (node.years < 1) return l.kDashaMonths((node.days / 30.44).round());
    return l.kDashaYears(node.years.toStringAsFixed(1));
  }
}
