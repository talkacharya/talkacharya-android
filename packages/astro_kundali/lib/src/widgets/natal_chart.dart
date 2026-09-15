import 'package:flutter/material.dart';

import '../models/kundali.dart';
import 'kundali_strings.dart';
import 'planet_palette.dart';

enum ChartStyle { north, south }

/// A Vedic birth-chart diagram drawn natively (so houses are tappable and it
/// follows the app theme). Takes the `houses` list from any chart payload
/// (D1, D9, …) — each entry is house → sign → planet names.
class NatalChart extends StatelessWidget {
  const NatalChart({
    required this.houses,
    this.style = ChartStyle.north,
    this.retrograde = const {},
    this.selectedHouse,
    this.onHouseTap,
    this.showHouseNumbers = true,
    this.planetLabel,
    this.fillColor,
    this.lineColor,
    this.numberColor,
    this.textColor,
    super.key,
  });

  final List<ChartHouse> houses;
  final ChartStyle style;

  /// Colors for the chart. If null, they will be derived from the theme.
  final Color? fillColor;
  final Color? lineColor;
  final Color? numberColor;
  final Color? textColor;

  /// Planet names currently retrograde — drawn with a ℞ mark.
  final Set<String> retrograde;
  final int? selectedHouse;
  final ValueChanged<int>? onHouseTap;
  final bool showHouseNumbers;

  /// Overrides the short in-chart token for a planet. Defaults to
  /// [KundaliStrings.planetToken] from the nearest [KundaliStringsScope].
  final String Function(String planetName)? planetLabel;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final label = planetLabel ?? KundaliStrings.of(context).planetToken;
    final line = lineColor ?? scheme.outlineVariant;
    final ascSign = houses.isEmpty
        ? ''
        : houses.firstWhere((h) => h.house == 1, orElse: () => houses.first).sign;

    return AspectRatio(
      aspectRatio: 1,
      child: LayoutBuilder(
        builder: (context, c) {
          final size = Size(c.maxWidth, c.maxHeight);
          final geo = style == ChartStyle.north
              ? _northPolys(size)
              : _southPolys(size, ascSign);
          return GestureDetector(
            onTapUp: onHouseTap == null
                ? null
                : (d) {
                    for (final e in geo.entries) {
                      if (_contains(e.value, d.localPosition)) {
                        onHouseTap!(e.key);
                        return;
                      }
                    }
                  },
            child: CustomPaint(
              size: size,
              painter: _ChartPainter(
                houses: houses,
                geo: geo,
                style: style,
                lineColor: line,
                fillColor: fillColor ?? scheme.surface,
                selectedFill: scheme.primary.withValues(alpha: 0.14),
                selectedLine: scheme.primary,
                numberColor: numberColor ?? scheme.onSurfaceVariant.withValues(alpha: 0.5),
                onSurface: textColor ?? scheme.onSurface,
                retrograde: retrograde,
                selectedHouse: selectedHouse,
                showNumbers: showHouseNumbers,
                planetLabel: label,
              ),
            ),
          );
        },
      ),
    );
  }

  // --- geometry -------------------------------------------------------

  static Map<int, List<Offset>> _northPolys(Size s) {
    Offset p(double x, double y) => Offset(x * s.width, y * s.height);
    final tl = p(0, 0), tr = p(1, 0), br = p(1, 1), bl = p(0, 1);
    final n = p(.5, 0), e = p(1, .5), so = p(.5, 1), w = p(0, .5), c = p(.5, .5);
    final ne = p(.75, .25), nw = p(.25, .25), se = p(.75, .75), sw = p(.25, .75);
    return {
      1: [n, ne, c, nw],
      2: [tl, n, nw],
      3: [tl, nw, w],
      4: [w, nw, c, sw],
      5: [w, sw, bl],
      6: [bl, sw, so],
      7: [so, sw, c, se],
      8: [so, se, br],
      9: [br, se, e],
      10: [e, se, c, ne],
      11: [e, ne, tr],
      12: [tr, ne, n],
    };
  }

  /// South Indian: signs sit in fixed cells; houses count clockwise from the
  /// ascendant sign's cell.
  static Map<int, List<Offset>> _southPolys(Size s, String ascSign) {
    const cell = <int, List<int>>{
      0: [1, 0], 1: [2, 0], 2: [3, 0], 3: [3, 1], 4: [3, 2], 5: [3, 3],
      6: [2, 3], 7: [1, 3], 8: [0, 3], 9: [0, 2], 10: [0, 1], 11: [0, 0],
    };
    final asc = _signs.indexOf(ascSign);
    final out = <int, List<Offset>>{};
    final cw = s.width / 4, ch = s.height / 4;
    for (var house = 1; house <= 12; house++) {
      final si = asc < 0 ? house - 1 : (asc + house - 1) % 12;
      final rc = cell[si]!;
      final x = rc[0] * cw, y = rc[1] * ch;
      out[house] = [
        Offset(x, y),
        Offset(x + cw, y),
        Offset(x + cw, y + ch),
        Offset(x, y + ch),
      ];
    }
    return out;
  }

  static const _signs = [
    'Aries', 'Taurus', 'Gemini', 'Cancer', 'Leo', 'Virgo',
    'Libra', 'Scorpio', 'Sagittarius', 'Capricorn', 'Aquarius', 'Pisces',
  ];

  static bool _contains(List<Offset> poly, Offset pt) {
    var inside = false;
    for (var i = 0, j = poly.length - 1; i < poly.length; j = i++) {
      final a = poly[i], b = poly[j];
      if (((a.dy > pt.dy) != (b.dy > pt.dy)) &&
          (pt.dx < (b.dx - a.dx) * (pt.dy - a.dy) / (b.dy - a.dy) + a.dx)) {
        inside = !inside;
      }
    }
    return inside;
  }
}

class _ChartPainter extends CustomPainter {
  _ChartPainter({
    required this.houses,
    required this.geo,
    required this.style,
    required this.lineColor,
    required this.fillColor,
    required this.selectedFill,
    required this.selectedLine,
    required this.numberColor,
    required this.onSurface,
    required this.retrograde,
    required this.selectedHouse,
    required this.showNumbers,
    required this.planetLabel,
  });

  final List<ChartHouse> houses;
  final Map<int, List<Offset>> geo;
  final ChartStyle style;
  final Color lineColor, fillColor, selectedFill, selectedLine, numberColor, onSurface;
  final Set<String> retrograde;
  final int? selectedHouse;
  final bool showNumbers;
  final String Function(String planetName) planetLabel;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = lineColor;
    canvas.drawRect(Offset.zero & size, Paint()..color = fillColor);

    // selected fill
    if (selectedHouse != null && geo[selectedHouse] != null) {
      canvas.drawPath(_path(geo[selectedHouse]!), Paint()..color = selectedFill);
    }

    if (style == ChartStyle.north) {
      canvas.drawRect(Offset.zero & size, stroke);
      canvas.drawLine(Offset.zero, size.bottomRight(Offset.zero), stroke);
      canvas.drawLine(Offset(size.width, 0), Offset(0, size.height), stroke);
      canvas.drawPath(
        _path([
          Offset(size.width / 2, 0),
          Offset(size.width, size.height / 2),
          Offset(size.width / 2, size.height),
          Offset(0, size.height / 2),
        ]),
        stroke,
      );
    } else {
      for (var i = 1; i <= 3; i++) {
        canvas
          ..drawLine(Offset(size.width / 4 * i, 0),
              Offset(size.width / 4 * i, size.height), stroke)
          ..drawLine(Offset(0, size.height / 4 * i),
              Offset(size.width, size.height / 4 * i), stroke);
      }
      canvas.drawRect(Offset.zero & size, stroke);
    }

    // selected outline
    if (selectedHouse != null && geo[selectedHouse] != null) {
      canvas.drawPath(
        _path(geo[selectedHouse]!),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = selectedLine,
      );
    }

    final byHouse = {for (final h in houses) h.house: h};

    for (final entry in geo.entries) {
      final house = entry.key;
      final centre = _centroid(entry.value);
      final data = byHouse[house];

      if (showNumbers) {
        final corner = _numberAnchor(entry.value, centre);
        // North Indian charts label each bhava with its *rasi* number (1=Aries …
        // 12=Pisces), houses being fixed by position — that's what DrikPanchang
        // shows. South Indian has signs fixed by cell, so the house number is
        // the useful label there.
        final rasi = data == null ? 0 : NatalChart._signs.indexOf(data.sign) + 1;
        final label = style == ChartStyle.north ? '$rasi' : '$house';
        if (label != '0') {
          _text(canvas, label, corner, 8, numberColor,
              anchor: Alignment.center);
        }
      }

      final planets = data?.planets ?? const [];
      if (planets.isEmpty) continue;
      final tokens = planets.map((p) {
        final t = planetLabel(p);
        return retrograde.contains(p) ? '$t·' : t;
      }).toList();
      _planetCluster(canvas, tokens, planets, centre);
    }
  }

  void _planetCluster(
    Canvas canvas,
    List<String> tokens,
    List<String> names,
    Offset centre,
  ) {
    // Slightly smaller fonts and tighter gaps to prevent overlap in crowded houses
    const fs = 9.0;
    const dotR = 2.0;
    const dotGap = 2.0;
    const itemGap = 4.0;
    const lineGap = 2.0;

    // Group into rows of 2 to handle multiple planets without overflow
    final rows = <List<int>>[];
    for (var i = 0; i < names.length; i += 2) {
      rows.add([for (var j = i; j < i + 2 && j < names.length; j++) j]);
    }

    final totalH = rows.length * (fs + lineGap) - lineGap;
    var y = centre.dy - totalH / 2 + fs / 2;

    for (final row in rows) {
      final widths = row.map((i) => dotR * 2 + dotGap + _measure(tokens[i], fs).width).toList();
      final rowW = widths.fold<double>(0, (a, b) => a + b) + itemGap * (row.length - 1);
      var x = centre.dx - rowW / 2;

      for (var k = 0; k < row.length; k++) {
        final i = row[k];
        final token = tokens[i];
        final name = names[i];
        final color = planetColor(name);
        
        // draw dot
        final dotCenter = Offset(x + dotR, y);
        canvas.drawCircle(
          dotCenter,
          dotR,
          Paint()..color = color,
        );
        
        // draw text
        _text(
          canvas,
          token,
          Offset(x + dotR * 2 + dotGap, y),
          fs,
          onSurface,
          bold: true,
          anchor: Alignment.centerLeft,
        );

        x += widths[k] + itemGap;
      }
      y += fs + lineGap;
    }
  }

  Path _path(List<Offset> pts) {
    final p = Path()..moveTo(pts.first.dx, pts.first.dy);
    for (final o in pts.skip(1)) {
      p.lineTo(o.dx, o.dy);
    }
    return p..close();
  }

  Offset _centroid(List<Offset> pts) {
    var x = 0.0, y = 0.0;
    for (final o in pts) {
      x += o.dx;
      y += o.dy;
    }
    return Offset(x / pts.length, y / pts.length);
  }

  Offset _numberAnchor(List<Offset> pts, Offset centre) {
    // Pull the number toward the polygon's outer edge to avoid overlapping
    // with the planet cluster in the center.
    final far = pts.reduce((a, b) =>
        (a - centre).distanceSquared > (b - centre).distanceSquared ? a : b);
    return Offset.lerp(far, centre, 0.15)!;
  }

  void _text(
    Canvas canvas,
    String s,
    Offset at,
    double size,
    Color color, {
    bool bold = false,
    Alignment anchor = Alignment.topLeft,
  }) {
    final tp = TextPainter(
      text: TextSpan(
        text: s,
        style: TextStyle(
          fontSize: size,
          color: color,
          fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    final dx = anchor == Alignment.center ? at.dx - tp.width / 2 : at.dx;
    final dy = anchor == Alignment.center ? at.dy - tp.height / 2 : at.dy;
    tp.paint(canvas, Offset(dx, dy));
  }

  Size _measure(String s, double size) {
    final tp = TextPainter(
      text: TextSpan(
        text: s,
        style: TextStyle(fontSize: size, fontWeight: FontWeight.w700),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    return tp.size;
  }


  @override
  bool shouldRepaint(_ChartPainter old) =>
      old.houses != houses ||
      old.selectedHouse != selectedHouse ||
      old.style != style ||
      old.lineColor != lineColor;
}
