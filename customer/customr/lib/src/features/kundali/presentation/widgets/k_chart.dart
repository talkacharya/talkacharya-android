import 'package:astro_kundali/astro_kundali.dart';
import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/astro_palette.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../../shared/widgets/hue_widgets.dart';
import '../../../../shared/widgets/pressable.dart';
import '../kundali_terms.dart';
import 'k_kit.dart';

/// Chart building blocks for the kundali screens, in the section's visual
/// language. Pure rendering over the `astro_kundali` models — the shared
/// package keeps its own neutral widgets for the astrologer app.

/// Compact segmented switch for dark (cosmic) panels. Scales down instead of
/// overflowing when long labels meet a narrow slot.
class KDarkSegment extends StatelessWidget {
  const KDarkSegment({
    required this.labels,
    required this.selected,
    required this.onSelect,
    super.key,
  });

  final List<String> labels;
  final int selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < labels.length; i++)
              GestureDetector(
                onTap: () => onSelect(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: i == selected
                        ? brand.glowAccent.withValues(alpha: 0.92)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    labels[i],
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: i == selected
                          ? const Color(0xFF3A1703)
                          : brand.onCosmicMuted,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Horizontal chip rail for the cosmic hero (chart types).
class KDarkChipRail extends StatelessWidget {
  const KDarkChipRail({
    required this.labels,
    required this.selected,
    required this.onSelect,
    super.key,
  });

  final List<String> labels;
  final int selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: labels.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final on = i == selected;
          return GestureDetector(
            onTap: () => onSelect(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: on
                    ? const LinearGradient(colors: BrandColors.goldGradient)
                    : null,
                color: on ? null : Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: Colors.white.withValues(alpha: on ? 0 : 0.2),
                ),
              ),
              child: Text(
                labels[i],
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: on ? const Color(0xFF3A1703) : brand.onCosmic,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// The chart itself on a cosmic panel, with loading / error faces.
class KChartPanel extends StatelessWidget {
  const KChartPanel({
    required this.houses,
    this.style = ChartStyle.north,
    this.retrograde = const {},
    this.hue = AstroPalette.career,
    this.loading = false,
    this.error = false,
    this.onRetry,
    this.onHouseTap,
    this.header,
    this.footer,
    super.key,
  });

  final List<ChartHouse> houses;
  final ChartStyle style;
  final Set<String> retrograde;
  final AstroHue hue;
  final bool loading;
  final bool error;
  final VoidCallback? onRetry;
  final ValueChanged<int>? onHouseTap;
  final Widget? header;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final l = context.l10n;
    Widget chart;
    if (houses.isNotEmpty) {
      chart = NatalChart(
        houses: houses,
        style: style,
        retrograde: retrograde,
        fillColor: Colors.white.withValues(alpha: 0.03),
        lineColor: Colors.white.withValues(alpha: 0.26),
        numberColor: Colors.white.withValues(alpha: 0.5),
        textColor: Colors.white,
        onHouseTap: onHouseTap,
      );
    } else if (error) {
      chart = AspectRatio(
        aspectRatio: 1,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.cloud_off_rounded,
                color: brand.onCosmicMuted,
                size: 32,
              ),
              const SizedBox(height: 8),
              Text(
                l.kFcLoadError,
                textAlign: TextAlign.center,
                style: TextStyle(color: brand.onCosmicMuted),
              ),
              if (onRetry != null)
                TextButton(
                  onPressed: onRetry,
                  style: TextButton.styleFrom(
                    foregroundColor: brand.glowAccent,
                  ),
                  child: Text(l.commonRetry),
                ),
            ],
          ),
        ),
      );
    } else {
      chart = AspectRatio(
        aspectRatio: 1,
        child: Center(
          child: CircularProgressIndicator(color: brand.onCosmicMuted),
        ),
      );
    }
    return KCosmicPanel(
      hue: hue,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (header != null) ...[header!, const SizedBox(height: 12)],
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 340),
              child: chart,
            ),
          ),
          if (footer != null) ...[const SizedBox(height: 10), footer!],
        ],
      ),
    );
  }
}

/// Chart name, what it signifies, ascendant chips and verification /
/// bhava-chalit notes.
class KChartFacts extends StatelessWidget {
  const KChartFacts({required this.vc, required this.fallbackTitle, super.key});
  final VargaChart vc;
  final String fallbackTitle;

  @override
  Widget build(BuildContext context) {
    final s = KundaliStrings.of(context);
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final name = vc.name.isEmpty ? fallbackTitle : vc.name;
    final signifies = s.chartSignifies(vc.chartType, vc.signifies);
    final hue = kSignHue(vc.ascendantSign);
    return KSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              HueIcon(
                hue: hue,
                icon: vc.isTransit
                    ? Icons.public_rounded
                    : Icons.grid_on_rounded,
                size: 40,
                iconSize: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.chartName(vc.chartType, name),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (signifies.isNotEmpty)
                      Text(
                        signifies,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: context.brand.inkMuted,
                          height: 1.35,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              if (vc.ascendantSign.isNotEmpty)
                KToneChip(
                  '${s.ascendant} · ${s.signName(vc.ascendantSign)}'
                  '${vc.ascendantDegree > 0 ? " ${vc.ascendantDegree.toStringAsFixed(1)}°" : ""}',
                  hue: hue,
                ),
              if (vc.ascendantVargottama)
                KToneChip('⬦ ${s.lagnaVargottama}', tone: KTone.good),
              if (vc.isTransit && vc.asOf != null)
                KToneChip(
                  s.asOf(fmtChartAsOf(vc.asOf!, locale: locale)),
                  tone: KTone.neutral,
                ),
            ],
          ),
          if (!vc.verified)
            _Note(
              icon: Icons.science_outlined,
              hue: AstroPalette.money,
              text: s.unverified,
            ),
          if (vc.isBhavaChalit && vc.shiftedPlanets.isNotEmpty)
            _Note(
              icon: Icons.swap_vert_rounded,
              hue: AstroPalette.career,
              text: s.chalitShifted(
                vc.shiftedPlanets.map((p) => s.planetName(p.name)).join(', '),
                vc.shiftedPlanets.length,
              ),
            ),
        ],
      ),
    );
  }
}

class _Note extends StatelessWidget {
  const _Note({required this.icon, required this.hue, required this.text});
  final IconData icon;
  final AstroHue hue;
  final String text;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(top: 12),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: hue.tint(0.1),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 17, color: hue.end),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.4),
          ),
        ),
      ],
    ),
  );
}

/// Planets of a chart as badge rows: token disc, name (+℞ / ⬦), sign · degree,
/// and the house (with the from-Moon house for transits, the rasi house for a
/// bhava-chalit shift).
class KPlanetList extends StatelessWidget {
  const KPlanetList({required this.vc, super.key});
  final VargaChart vc;

  @override
  Widget build(BuildContext context) {
    final s = KundaliStrings.of(context);
    final theme = Theme.of(context);
    final brand = context.brand;
    final rows = [...vc.planets]..sort((a, b) => a.house.compareTo(b.house));
    return KSurface(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0) Divider(height: 1, color: brand.hairline),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 9),
              child: Row(
                children: [
                  PlanetBadge(rows[i].name, size: 36),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          [
                            s.planetName(rows[i].name),
                            if (rows[i].retrograde) '℞',
                            if (rows[i].vargottama) '⬦',
                          ].join(' '),
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '${s.signName(rows[i].sign)} · ${_deg(rows[i])}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: brand.inkMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (vc.isTransit && rows[i].houseFromMoon > 0) ...[
                    _HousePill(
                      label: '${s.colFromMoon} ${rows[i].houseFromMoon}',
                      hue: AstroPalette.air,
                    ),
                    const SizedBox(width: 6),
                  ],
                  _HousePill(
                    label: vc.isBhavaChalit && rows[i].shifted
                        ? '${rows[i].house} ← ${rows[i].rasiHouse}'
                        : '${vc.isBhavaChalit ? s.colBhava : s.colHouse} ${rows[i].house}',
                    hue: vc.isBhavaChalit && rows[i].shifted
                        ? AstroPalette.fire
                        : kPlanetHue(rows[i].name),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  static String _deg(ChartPlacement p) => p.dms.isNotEmpty
      ? p.dms.split("'").first
      : '${p.degree.toStringAsFixed(1)}°';
}

class _HousePill extends StatelessWidget {
  const _HousePill({required this.label, required this.hue});
  final String label;
  final AstroHue hue;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: hue.tint(0.13),
      borderRadius: BorderRadius.circular(999),
    ),
    child: Text(
      label,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: hue.end,
        fontWeight: FontWeight.w800,
      ),
    ),
  );
}

/// The twelve houses as a 3-column grid: number, sign, planet tokens.
class KHouseGrid extends StatelessWidget {
  const KHouseGrid({required this.houses, this.onTap, super.key});
  final List<ChartHouse> houses;
  final ValueChanged<int>? onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final s = KundaliStrings.of(context);
    final theme = Theme.of(context);
    final ordered = [...houses]..sort((a, b) => a.house.compareTo(b.house));
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 0.92,
      children: [
        for (final h in ordered)
          KHueCard(
            hue: kSignHue(h.sign),
            radius: 16,
            padding: const EdgeInsets.all(10),
            onTap: onTap == null ? null : () => onTap!(h.house),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${h.house}',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: kSignHue(h.sign).end,
                        height: 1,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 16,
                      color: context.brand.inkMuted,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  KTerms.signName(l, h.sign),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Wrap(
                  spacing: 3,
                  runSpacing: 3,
                  children: [
                    for (final p in h.planets.take(4))
                      PlanetBadge(p, size: 20, label: s.planetToken(p)),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Planet colour key + chart reading notes.
class KChartLegend extends StatelessWidget {
  const KChartLegend({super.key});

  @override
  Widget build(BuildContext context) {
    final s = KundaliStrings.of(context);
    final theme = Theme.of(context);
    return KSurface(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            s.legend,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 8,
            children: [
              for (final p in planetOrder)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PlanetBadge(p, size: 22),
                    const SizedBox(width: 5),
                    Text(s.planetName(p), style: theme.textTheme.labelMedium),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            s.legendNote,
            style: theme.textTheme.bodySmall?.copyWith(
              color: context.brand.inkMuted,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

/// "All charts" sheet — the D1–D60 menu grouped, tap to open.
Future<void> showKChartPicker(
  BuildContext context, {
  required List<ChartTypeInfo> menu,
  required String selected,
  required ValueChanged<String> onPick,
}) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (_) =>
        _PickerSheet(menu: menu, selected: selected, onPick: onPick),
  );
}

class _PickerSheet extends StatelessWidget {
  const _PickerSheet({
    required this.menu,
    required this.selected,
    required this.onPick,
  });

  final List<ChartTypeInfo> menu;
  final String selected;
  final ValueChanged<String> onPick;

  @override
  Widget build(BuildContext context) {
    final s = KundaliStrings.of(context);
    final divisional = menu.where((c) => c.varga != null).toList();
    final other = menu.where((c) => c.varga == null).toList();
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.78,
      maxChildSize: 0.94,
      builder: (context, controller) => ListView(
        controller: controller,
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
        children: [
          if (other.isNotEmpty)
            KSection(
              title: s.pickerCharts,
              hue: AstroPalette.money,
              padTop: 4,
              child: Column(
                children: [for (final c in other) _row(context, s, c)],
              ),
            ),
          KSection(
            title: s.pickerDivisional,
            hue: AstroPalette.career,
            child: Column(
              children: [for (final c in divisional) _row(context, s, c)],
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(BuildContext context, KundaliStrings s, ChartTypeInfo c) {
    final theme = Theme.of(context);
    final on = c.type == selected;
    final hue = on ? AstroPalette.money : AstroPalette.air;
    final signifies = s.chartSignifies(c.type, c.signifies);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Pressable(
        child: Material(
          color: on ? hue.tint(0.1) : theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(color: on ? hue.end : context.brand.hairline),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => onPick(c.type),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: on ? hue.linear() : null,
                      color: on ? null : hue.tint(0.14),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      c.varga != null ? 'D${c.varga}' : '◈',
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: on ? Colors.white : hue.end,
                      ),
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
                                s.chartName(c.type, c.name),
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            if (!c.verified)
                              Padding(
                                padding: const EdgeInsets.only(left: 6),
                                child: Icon(
                                  Icons.science_outlined,
                                  size: 14,
                                  color: AstroPalette.money.end,
                                ),
                              ),
                          ],
                        ),
                        if (signifies.isNotEmpty)
                          Text(
                            signifies,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: context.brand.inkMuted,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (on)
                    Icon(Icons.check_circle_rounded, color: hue.end, size: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
