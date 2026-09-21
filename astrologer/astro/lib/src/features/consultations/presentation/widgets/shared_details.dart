import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/astro_palette.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../../shared/widgets/hue_widgets.dart';
import '../../../../shared/widgets/pressable.dart';
import '../../data/models/consultation.dart';
import '../../data/models/consultation_share.dart';

/// "12 May 1994 · 07:30 · Mumbai" (or "Birth time not known").
String sharedPersonLine(BuildContext context, SharedPerson p) {
  final l = context.l10n;
  String date = p.birthDate;
  final parsed = DateTime.tryParse(p.birthDate);
  if (parsed != null) date = DateFormat.yMMMd(l.localeName).format(parsed);
  return [
    if (date.isNotEmpty) date,
    if (p.timeKnown && (p.birthTime ?? '').isNotEmpty)
      p.birthTime!
    else
      l.sharedTimeUnknown,
    if (p.birthPlace.isNotEmpty) p.birthPlace,
  ].join(' · ');
}

/// Everything the customer shared for a consultation: birth profiles (each
/// opens their kundali) and match reports. [canOpen] is false before the
/// request is accepted — the backend only serves charts for live sessions.
class SharedDetailsSection extends StatelessWidget {
  const SharedDetailsSection({
    required this.consultation,
    this.canOpen = true,
    this.padding = const EdgeInsets.fromLTRB(16, 0, 16, 12),
    super.key,
  });

  final Consultation consultation;
  final bool canOpen;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final c = consultation;
    final l = context.l10n;
    final brand = context.brand;
    if (c.shares.isEmpty) {
      return Padding(
        padding: padding,
        child: Row(
          children: [
            Icon(Icons.info_outline_rounded, size: 18, color: brand.inkMuted),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                l.sharedNone,
                style: TextStyle(color: brand.inkMuted),
              ),
            ),
          ],
        ),
      );
    }
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                Icons.auto_awesome_rounded,
                size: 16,
                color: AstroPalette.money.end,
              ),
              const SizedBox(width: 6),
              Text(
                l.sharedTitle.toUpperCase(),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: brand.inkMuted,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.6,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          for (final share in c.shares)
            if (share.match case final m?)
              _MatchCard(consultationId: c.id, match: m, canOpen: canOpen)
            else if (share.person case final p?)
              SharedPersonCard(
                consultationId: c.id,
                person: p,
                canOpen: canOpen,
              ),
        ],
      ),
    );
  }
}

/// One shared person: their birth details + a link to their kundali.
class SharedPersonCard extends StatelessWidget {
  const SharedPersonCard({
    required this.consultationId,
    required this.person,
    this.canOpen = true,
    super.key,
  });

  final String consultationId;
  final SharedPerson person;
  final bool canOpen;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    final hue = AstroPalette.forId(person.id);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Pressable(
        child: HueTile(
          hue: hue,
          onTap: canOpen ? () => _openKundali(context) : null,
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              HueAvatar(name: person.name, hue: hue, size: 42),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      person.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      sharedPersonLine(context, person),
                      maxLines: 2,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: brand.inkMuted,
                      ),
                    ),
                  ],
                ),
              ),
              if (canOpen) ...[
                const SizedBox(width: 8),
                Column(
                  children: [
                    Icon(Icons.auto_awesome_rounded, color: hue.end, size: 20),
                    Text(
                      l.detailKundali,
                      style: TextStyle(
                        color: hue.end,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _openKundali(BuildContext context) => context.push(
    Routes.consultationKundali(consultationId, profile: person.id),
    extra: person.name,
  );
}

class _MatchCard extends StatelessWidget {
  const _MatchCard({
    required this.consultationId,
    required this.match,
    required this.canOpen,
  });

  final String consultationId;
  final SharedMatch match;
  final bool canOpen;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    final hue = AstroPalette.ratio(match.ratio);
    final names = [
      match.boy?.name ?? '',
      match.girl?.name ?? '',
    ].where((n) => n.isNotEmpty).join(' & ');

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Pressable(
        child: HueTile(
          hue: hue,
          onTap: canOpen
              ? () => context.push(
                  Routes.consultationMatch(consultationId, match.id),
                )
              : null,
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  HueIcon(
                    hue: hue,
                    icon: Icons.favorite_rounded,
                    size: 42,
                    iconSize: 21,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          names.isEmpty ? l.sharedMatchTitle : names,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          l.sharedPoints(match.pointsLabel, match.maxLabel),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: hue.end,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (canOpen)
                    Icon(Icons.chevron_right_rounded, color: brand.inkMuted),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(Radii.pill),
                child: LinearProgressIndicator(
                  value: match.ratio,
                  minHeight: 6,
                  color: hue.end,
                  backgroundColor: hue.tint(0.18),
                ),
              ),
              // Each person's chart is readable too.
              if (canOpen) ...[
                const SizedBox(height: 10),
                Row(
                  children: [
                    for (final p in [match.boy, match.girl])
                      if (p != null)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ActionChip(
                            avatar: Icon(
                              Icons.auto_awesome_rounded,
                              size: 15,
                              color: hue.end,
                            ),
                            label: Text(p.name),
                            onPressed: () => context.push(
                              Routes.consultationKundali(
                                consultationId,
                                profile: p.id,
                              ),
                              extra: p.name,
                            ),
                          ),
                        ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Compact "birth details shared" / "kundali match" chips for request lists.
class SharedBadges extends StatelessWidget {
  const SharedBadges({required this.consultation, super.key});

  final Consultation consultation;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = consultation;
    if (c.shares.isEmpty) return const SizedBox.shrink();
    final hasMatch = c.sharedMatches.isNotEmpty;
    final hue = hasMatch ? AstroPalette.love : AstroPalette.money;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: hue.tint(0.14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            hasMatch ? Icons.favorite_rounded : Icons.auto_awesome_rounded,
            size: 12,
            color: hue.end,
          ),
          const SizedBox(width: 4),
          Text(
            hasMatch ? l.sharedMatchTitle : l.sharedAvailable,
            style: TextStyle(
              color: hue.end,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
