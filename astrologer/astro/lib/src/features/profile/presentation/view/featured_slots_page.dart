import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/astro_palette.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../../core/util/money.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/hue_widgets.dart';
import '../../../../shared/widgets/settings_widgets.dart';
import '../../data/profile_api.dart';
import '../../data/profile_models.dart';

/// Billable days for a window — mirrors backend `featured._validate_window`
/// (`max(1, round(duration / 1 day))`).
int featuredDays(DateTime start, DateTime end) =>
    math.max(1, (end.difference(start).inMinutes / (24 * 60)).round());

/// Start/end instants for an inclusive date range. A range starting today
/// begins a minute from now (the backend rejects past starts).
({DateTime start, DateTime end}) featuredWindow(
  DateTimeRange range, {
  DateTime? now,
}) {
  final n = now ?? DateTime.now();
  final first = DateUtils.dateOnly(range.start);
  final start = DateUtils.isSameDay(first, n)
      ? n.add(const Duration(minutes: 1))
      : first;
  final end = DateUtils.dateOnly(range.end).add(const Duration(days: 1));
  return (start: start, end: end);
}

/// Request paid placements in the customer app and track existing ones.
class FeaturedSlotsPage extends StatefulWidget {
  const FeaturedSlotsPage({super.key});

  @override
  State<FeaturedSlotsPage> createState() => _FeaturedSlotsPageState();
}

class _FeaturedSlotsPageState extends State<FeaturedSlotsPage> {
  final _api = getIt<ProfileApi>();

  FeaturedPricing? _pricing;
  List<FeaturedSlot> _slots = const [];
  List<RefOption> _skills = const [];
  bool _loading = true;
  bool _failed = false;

  String _placement = kFeaturedPlacements.first;
  String? _skill;
  DateTimeRange? _range;
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _failed = false);
    try {
      final r = await Future.wait([
        _api.featuredPricing(),
        _api.featuredSlots(),
        _api.skillOptions(),
      ]);
      if (!mounted) return;
      setState(() {
        _pricing = r[0] as FeaturedPricing;
        _slots = r[1] as List<FeaturedSlot>;
        _skills = r[2] as List<RefOption>;
        _loading = false;
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          _loading = false;
          _failed = true;
        });
      }
    }
  }

  Future<void> _pickDates() async {
    final now = DateTime.now();
    final max = _pricing?.maxDays ?? 30;
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateUtils.dateOnly(now),
      lastDate: now.add(const Duration(days: 180)),
      initialDateRange: _range,
    );
    if (picked == null || !mounted) return;
    // Clamp to the maximum slot length rather than rejecting the pick.
    final days = picked.end.difference(picked.start).inDays + 1;
    setState(() {
      _range = days > max
          ? DateTimeRange(
              start: picked.start,
              end: picked.start.add(Duration(days: max - 1)),
            )
          : picked;
    });
  }

  Future<void> _send() async {
    final l = context.l10n;
    final range = _range;
    if (range == null) return;
    final w = featuredWindow(range);
    setState(() => _sending = true);
    try {
      final slot = await _api.requestFeaturedSlot(
        placement: _placement,
        startsAt: w.start,
        endsAt: w.end,
        skill: _placement == 'category_top' ? _skill : null,
      );
      if (!mounted) return;
      setState(() {
        _slots = [slot, ..._slots];
        _range = null;
      });
      showToast(context, l.featSent);
    } on ApiException catch (e) {
      if (mounted) {
        showToast(context, e.isNetwork ? l.commonSaveFailed : e.message);
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    final pricing = _pricing;
    final needsSkill = _placement == 'category_top';
    final range = _range;
    final days = range == null
        ? 0
        : (() {
            final w = featuredWindow(range);
            return featuredDays(w.start, w.end);
          })();
    final perDay = pricing?.priceFor(_placement);
    final ready = range != null && (!needsSkill || _skill != null);

    return SubPageScaffold(
      title: l.profileFeatured,
      subtitle: l.featIntro,
      onRefresh: _load,
      children: [
        if (_loading)
          const Padding(
            padding: EdgeInsets.all(48),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (_failed)
          ErrorView(message: l.commonLoadFailed, onRetry: _load)
        else ...[
          SettingsCard(
            title: l.featRequest,
            subtitle: pricing == null ? null : l.featMaxDays(pricing.maxDays),
            icon: Icons.workspace_premium_rounded,
            hue: AstroPalette.money,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final p in kFeaturedPlacements)
                  if (pricing?.priceFor(p) != null)
                    _PlacementTile(
                      placement: p,
                      perDay: pricing!.priceFor(p)!,
                      selected: p == _placement,
                      onTap: () => setState(() => _placement = p),
                    ),
                if (needsSkill) ...[
                  const SizedBox(height: 4),
                  DropdownButtonFormField<String>(
                    initialValue: _skill,
                    isExpanded: true,
                    decoration: InputDecoration(labelText: l.featCategory),
                    items: [
                      for (final s in _skills)
                        DropdownMenuItem(value: s.code, child: Text(s.name)),
                    ],
                    onChanged: (v) => setState(() => _skill = v),
                  ),
                ],
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Radii.md),
                    ),
                  ),
                  onPressed: _pickDates,
                  icon: const Icon(Icons.date_range_rounded),
                  label: Text(
                    range == null
                        ? l.featPickDates
                        : '${_d(context, range.start)} – ${_d(context, range.end)}',
                  ),
                ),
                if (range != null && perDay != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: brand.tint,
                      borderRadius: BorderRadius.circular(Radii.sm),
                    ),
                    child: Text(
                      l.featTotal(Money.format(perDay * days, 'INR'), days),
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: brand.onTint,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                BusyButton(
                  label: l.featSend,
                  icon: Icons.send_rounded,
                  busy: _sending,
                  onPressed: ready ? _send : null,
                ),
              ],
            ),
          ),
          if (_slots.isNotEmpty) ...[
            GroupLabel(l.featMine),
            for (final s in _slots) _SlotCard(slot: s, skills: _skills),
          ] else
            Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Text(
                  l.featEmpty,
                  style: TextStyle(color: brand.inkMuted),
                ),
              ),
            ),
        ],
      ],
    );
  }

  static String _d(BuildContext context, DateTime d) =>
      DateFormat.MMMd(context.l10n.localeName).format(d);
}

({IconData icon, String title, String subtitle, AstroHue hue}) _placementStyle(
  AppLocalizations l,
  String placement,
) => switch (placement) {
  'category_top' => (
    icon: Icons.category_rounded,
    title: l.featCategoryTop,
    subtitle: l.featCategoryTopSub,
    hue: AstroPalette.air,
  ),
  'search_boost' => (
    icon: Icons.trending_up_rounded,
    title: l.featSearchBoost,
    subtitle: l.featSearchBoostSub,
    hue: AstroPalette.health,
  ),
  _ => (
    icon: Icons.star_rounded,
    title: l.featHomeHero,
    subtitle: l.featHomeHeroSub,
    hue: AstroPalette.money,
  ),
};

class _PlacementTile extends StatelessWidget {
  const _PlacementTile({
    required this.placement,
    required this.perDay,
    required this.selected,
    required this.onTap,
  });

  final String placement;
  final double perDay;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    final s = _placementStyle(l, placement);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: selected ? s.hue.tint(0.12) : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radii.md),
          side: BorderSide(
            color: selected ? s.hue.end : brand.hairline,
            width: selected ? 1.5 : 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                HueIcon(hue: s.hue, icon: s.icon, size: 36, iconSize: 18),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s.title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        s.subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: brand.inkMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  l.featPerDay(Money.format(perDay, 'INR')),
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: s.hue.end,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  selected
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_off_rounded,
                  color: selected ? s.hue.end : brand.inkMuted,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SlotCard extends StatelessWidget {
  const _SlotCard({required this.slot, required this.skills});

  final FeaturedSlot slot;
  final List<RefOption> skills;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    final s = _placementStyle(l, slot.placement);
    final (label, color) = switch (slot.status) {
      'requested' => (l.featStatusRequested, AstroPalette.money.end),
      'scheduled' => (l.featStatusScheduled, AstroPalette.career.end),
      'active' => (l.requestsLiveNow, brand.online),
      'expired' => (l.featStatusExpired, brand.inkMuted),
      'rejected' => (l.statusRejected, brand.live),
      'cancelled' => (l.statusCancelled, brand.inkMuted),
      _ => (slot.status, brand.inkMuted),
    };
    String d(DateTime? t) =>
        t == null ? '—' : DateFormat.MMMd(l.localeName).format(t.toLocal());
    final skillName = slot.skill == null
        ? null
        : skills.where((o) => o.code == slot.skill).firstOrNull?.name ??
              slot.skill;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              HueIcon(hue: s.hue, icon: s.icon, size: 40, iconSize: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      skillName == null ? s.title : '${s.title} · $skillName',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      // endsAt is exclusive (midnight after the last day).
                      '${d(slot.startsAt)} – ${d(slot.endsAt?.subtract(const Duration(minutes: 1)))}'
                      '${slot.price > 0 ? ' · ${Money.format(slot.price, slot.currency)}' : ''}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: brand.inkMuted,
                      ),
                    ),
                    if (slot.notes.isNotEmpty)
                      Text(slot.notes, style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
