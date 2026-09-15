import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/varga_chart.dart';
import 'kundali_strings.dart';
import 'natal_chart.dart';
import 'planet_palette.dart';

/// Shared building blocks for every chart view — the wheel card, the details
/// block, the planet table, the picker sheet and the legend. Pure rendering:
/// the host app owns loading/state and passes plain values in. All copy comes
/// from [KundaliStrings.of].

String fmtChartAsOf(String iso, {String? locale}) {
  try {
    return DateFormat('d MMM, h:mm a', locale)
        .format(DateTime.parse(iso).toLocal());
  } catch (_) {
    return iso;
  }
}

/// English chip label for a chart type — 'D1', 'Moon', 'Chalit', 'Transit'.
/// Localised screens use [KundaliStrings.chartShortLabel].
String chartShortLabel(String type) =>
    const KundaliStrings().chartShortLabel(type);

/// A themed card with padding — picks up the host app's [CardTheme].
class KundaliCard extends StatelessWidget {
  const KundaliCard({
    required this.child,
    this.padding = const EdgeInsets.all(16),
    super.key,
  });
  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) =>
      Card(child: Padding(padding: padding, child: child));
}

/// Small upper-case section label.
class KundaliLabel extends StatelessWidget {
  const KundaliLabel(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text.toUpperCase(),
    style: Theme.of(context).textTheme.labelSmall?.copyWith(
      color: Theme.of(context).colorScheme.onSurfaceVariant,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.7,
    ),
  );
}

class KundaliChip extends StatelessWidget {
  const KundaliChip(this.label, {this.color, super.key});
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color ?? scheme.onSurface,
        ),
      ),
    );
  }
}

/// The chart wheel in a card. The host passes a resolved [chart] plus optional
/// [loading] / [error] flags — no state framework coupling.
class ChartWheel extends StatelessWidget {
  const ChartWheel({
    required this.chart,
    this.style = ChartStyle.north,
    this.loading = false,
    this.error,
    this.onRetry,
    this.onHouseTap,
    this.planetLabel,
    super.key,
  });

  final VargaChart? chart;
  final ChartStyle style;
  final bool loading;
  final String? error;
  final VoidCallback? onRetry;
  final ValueChanged<int>? onHouseTap;
  final String Function(String planetName)? planetLabel;

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (chart != null) {
      body = NatalChart(
        houses: chart!.houses,
        style: style,
        retrograde: {
          for (final p in chart!.planets)
            if (p.retrograde) p.name,
        },
        onHouseTap: onHouseTap,
        planetLabel: planetLabel,
      );
    } else if (error != null) {
      body = AspectRatio(
        aspectRatio: 1,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(error!, textAlign: TextAlign.center),
              if (onRetry != null) ...[
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: onRetry,
                  child: Text(KundaliStrings.of(context).retry),
                ),
              ],
            ],
          ),
        ),
      );
    } else {
      body = const AspectRatio(
        aspectRatio: 1,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    return KundaliCard(padding: const EdgeInsets.all(16), child: body);
  }
}

/// Name + signification + ascendant chips + verification / bhava-chalit banners.
class ChartDetails extends StatelessWidget {
  const ChartDetails({required this.vc, required this.fallbackTitle, super.key});
  final VargaChart vc;
  final String fallbackTitle;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final s = KundaliStrings.of(context);
    final name = vc.name.isEmpty ? fallbackTitle : vc.name;
    final signifies = s.chartSignifies(vc.chartType, vc.signifies);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          s.chartName(vc.chartType, name),
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        ),
        if (signifies.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            signifies,
            style: TextStyle(fontSize: 12.5, color: scheme.onSurfaceVariant),
          ),
        ],
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: [
            if (vc.ascendantSign.isNotEmpty)
              KundaliChip(
                '${s.ascendant} · ${s.signName(vc.ascendantSign)}'
                '${vc.ascendantDegree > 0 ? " ${vc.ascendantDegree.toStringAsFixed(1)}°" : ""}',
              ),
            if (vc.ascendantVargottama)
              KundaliChip('⬦ ${s.lagnaVargottama}', color: scheme.primary),
            if (vc.isTransit && vc.asOf != null)
              KundaliChip(
                s.asOf(
                  fmtChartAsOf(
                    vc.asOf!,
                    locale: Localizations.localeOf(context).toLanguageTag(),
                  ),
                ),
              ),
          ],
        ),
        if (!vc.verified) ...[
          const SizedBox(height: 10),
          ChartBanner(icon: Icons.science_outlined, text: s.unverified),
        ],
        if (vc.isBhavaChalit && vc.shiftedPlanets.isNotEmpty) ...[
          const SizedBox(height: 10),
          ChartBanner(
            icon: Icons.swap_vert_rounded,
            tone: scheme.primary,
            text: s.chalitShifted(
              vc.shiftedPlanets.map((p) => s.planetName(p.name)).join(', '),
              vc.shiftedPlanets.length,
            ),
          ),
        ],
      ],
    );
  }
}

class ChartBanner extends StatelessWidget {
  const ChartBanner({required this.icon, required this.text, this.tone, super.key});
  final IconData icon;
  final String text;
  final Color? tone;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final c = tone ?? scheme.tertiary;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 17, color: c),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 12.5, height: 1.4)),
          ),
        ],
      ),
    );
  }
}

class PlanetTable extends StatelessWidget {
  const PlanetTable({required this.vc, super.key});
  final VargaChart vc;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final s = KundaliStrings.of(context);
    final transit = vc.isTransit;
    final bhava = vc.isBhavaChalit;
    final rows = [...vc.planets]..sort((a, b) => a.house.compareTo(b.house));

    Widget head(String s, {int flex = 1, TextAlign align = TextAlign.start}) =>
        Expanded(
          flex: flex,
          child: Text(
            s,
            textAlign: align,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.4,
              color: scheme.onSurfaceVariant,
            ),
          ),
        );

    return KundaliCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                head(s.colPlanet, flex: 3),
                head(s.colSign, flex: 3),
                head(s.colDegree, flex: 2, align: TextAlign.end),
                head(
                  bhava ? s.colBhava : s.colHouse,
                  flex: 2,
                  align: TextAlign.end,
                ),
                if (transit)
                  head(s.colFromMoon, flex: 2, align: TextAlign.end),
              ],
            ),
          ),
          Divider(height: 1, color: scheme.outlineVariant),
          for (final p in rows)
            _line(context, s, p, transit: transit, bhava: bhava),
        ],
      ),
    );
  }

  Widget _line(
    BuildContext context,
    KundaliStrings s,
    ChartPlacement p, {
    required bool transit,
    required bool bhava,
  }) {
    final scheme = Theme.of(context).colorScheme;
    final deg = p.dms.isNotEmpty
        ? p.dms.split("'").first
        : '${p.degree.toStringAsFixed(1)}°';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: planetColor(p.name),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    s.planetName(p.name),
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 12.5, fontWeight: FontWeight.w600),
                  ),
                ),
                if (p.retrograde)
                  const Padding(
                    padding: EdgeInsets.only(left: 3),
                    child: Text('℞',
                        style: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w700)),
                  ),
                if (p.vargottama)
                  Padding(
                    padding: const EdgeInsets.only(left: 3),
                    child: Text('⬦',
                        style: TextStyle(fontSize: 11, color: scheme.primary)),
                  ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              s.signName(p.sign),
              style: const TextStyle(fontSize: 12.5),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(deg,
                textAlign: TextAlign.end,
                style: const TextStyle(fontSize: 12.5)),
          ),
          Expanded(
            flex: 2,
            child: Text(
              bhava && p.shifted ? '${p.house} ←${p.rasiHouse}' : '${p.house}',
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight:
                    bhava && p.shifted ? FontWeight.w700 : FontWeight.w400,
                color: bhava && p.shifted ? scheme.primary : null,
              ),
            ),
          ),
          if (transit)
            Expanded(
              flex: 2,
              child: Text('${p.houseFromMoon}',
                  textAlign: TextAlign.end,
                  style: const TextStyle(fontSize: 12.5)),
            ),
        ],
      ),
    );
  }
}

class ChartLegend extends StatelessWidget {
  const ChartLegend({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final s = KundaliStrings.of(context);
    return KundaliCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            s.legend,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              for (final p in planetOrder)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 9,
                      height: 9,
                      decoration: BoxDecoration(
                        color: planetColor(p),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${s.planetToken(p)} · ${s.planetName(p)}',
                      style: const TextStyle(fontSize: 11.5),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 10),
          Divider(color: scheme.outlineVariant, height: 1),
          const SizedBox(height: 8),
          Text(
            s.legendNote,
            style: TextStyle(fontSize: 11.5, color: scheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

/// North / South Indian style toggle.
class ChartStyleToggle extends StatelessWidget {
  const ChartStyleToggle({required this.style, required this.onChanged, super.key});
  final ChartStyle style;
  final ValueChanged<ChartStyle> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final s = KundaliStrings.of(context);
    final labels = [s.northIndian, s.southIndian];
    final selected = style == ChartStyle.north ? 0 : 1;
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          for (var i = 0; i < labels.length; i++)
            Expanded(
              child: GestureDetector(
                onTap: () =>
                    onChanged(i == 0 ? ChartStyle.north : ChartStyle.south),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 9),
                  decoration: BoxDecoration(
                    color: i == selected ? scheme.surface : Colors.transparent,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Text(
                    labels[i],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: i == selected
                          ? scheme.onSurface
                          : scheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// The "all charts" bottom sheet — grouped Charts / Divisional, tap to open.
Future<void> showChartPicker(
  BuildContext context, {
  required List<ChartTypeInfo> menu,
  required String selected,
  required ValueChanged<String> onPick,
}) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (_) =>
        _ChartPickerSheet(menu: menu, selected: selected, onPick: onPick),
  );
}

class _ChartPickerSheet extends StatelessWidget {
  const _ChartPickerSheet({
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
      initialChildSize: 0.75,
      maxChildSize: 0.92,
      builder: (context, controller) => ListView(
        controller: controller,
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 24),
        children: [
          if (other.isNotEmpty) ...[
            _header(context, s.pickerCharts),
            for (final c in other) _row(context, s, c),
            const SizedBox(height: 8),
          ],
          _header(context, s.pickerDivisional),
          for (final c in divisional) _row(context, s, c),
        ],
      ),
    );
  }

  Widget _header(BuildContext context, String text) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
    child: KundaliLabel(text),
  );

  Widget _row(BuildContext context, KundaliStrings s, ChartTypeInfo c) {
    final scheme = Theme.of(context).colorScheme;
    final isSel = c.type == selected;
    final signifies = s.chartSignifies(c.type, c.signifies);
    return ListTile(
      selected: isSel,
      leading: CircleAvatar(
        radius: 18,
        backgroundColor: isSel ? scheme.primary : scheme.surfaceContainerHighest,
        child: Text(
          c.varga != null ? 'D${c.varga}' : '◈',
          style: TextStyle(
            fontSize: c.varga != null && c.varga! >= 10 ? 11 : 12.5,
            fontWeight: FontWeight.w700,
            color: isSel ? scheme.onPrimary : scheme.onSurfaceVariant,
          ),
        ),
      ),
      title: Row(
        children: [
          Flexible(
            child: Text(
              s.chartName(c.type, c.name),
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),
          if (!c.verified)
            Padding(
              padding: const EdgeInsets.only(left: 6),
              child: Icon(Icons.science_outlined,
                  size: 14, color: scheme.tertiary),
            ),
        ],
      ),
      subtitle: signifies.isEmpty
          ? null
          : Text(signifies, maxLines: 2, overflow: TextOverflow.ellipsis),
      trailing: isSel ? Icon(Icons.check_rounded, color: scheme.primary) : null,
      onTap: () => onPick(c.type),
    );
  }
}
