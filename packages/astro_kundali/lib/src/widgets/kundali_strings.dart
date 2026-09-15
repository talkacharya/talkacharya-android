import 'package:flutter/widgets.dart';

/// Every user-visible string the package's chart widgets draw. Defaults are
/// English, so an app that never provides a [KundaliStringsScope] (the
/// astrologer app) renders exactly as before. The customer app fills this from
/// its ARB and wraps the kundali section in a scope.
///
/// Backend payloads carry canonical English names ("Libra", "Sun", "Rashi");
/// the name functions map those stable keys to display text.
@immutable
class KundaliStrings {
  const KundaliStrings({
    this.planetName = _identity,
    this.signName = _identity,
    this.chartName = _fallback,
    this.chartSignifies = _fallback,
    this.chartShortLabel = _chartShortLabelEn,
    this.ascendant = 'Ascendant',
    this.lagnaVargottama = 'Lagna vargottama',
    this.asOf = _asOfEn,
    this.unverified =
        'This division is not yet verified against DrikPanchang — '
        'treat the placements as experimental.',
    this.chalitShifted = _chalitShiftedEn,
    this.colPlanet = 'PLANET',
    this.colSign = 'SIGN',
    this.colDegree = 'DEG',
    this.colHouse = 'HOUSE',
    this.colBhava = 'BHAVA',
    this.colFromMoon = 'MOON',
    this.legend = 'Legend',
    this.legendNote =
        '℞ retrograde   ⬦ vargottama   ← moved bhava (chalit)\n'
        'North: cell number = rasi (1 Aries … 12 Pisces), 1st house is top-centre.',
    this.northIndian = 'North Indian',
    this.southIndian = 'South Indian',
    this.pickerCharts = 'Charts',
    this.pickerDivisional = 'Divisional charts (Varga)',
    this.retry = 'Retry',
  });

  final String Function(String planet) planetName;
  final String Function(String sign) signName;

  /// `(chartType, payloadName)` — e.g. `('d9', 'Navamsha')`.
  final String Function(String type, String fallback) chartName;
  final String Function(String type, String fallback) chartSignifies;

  /// Chip label for a chart type — 'D1', 'Moon', 'Chalit', 'Transit'.
  final String Function(String type) chartShortLabel;

  final String ascendant;
  final String lagnaVargottama;
  final String Function(String when) asOf;
  final String unverified;

  /// `(planet names joined, count)`.
  final String Function(String planets, int count) chalitShifted;

  final String colPlanet;
  final String colSign;
  final String colDegree;
  final String colHouse;
  final String colBhava;
  final String colFromMoon;
  final String legend;
  final String legendNote;
  final String northIndian;
  final String southIndian;
  final String pickerCharts;
  final String pickerDivisional;
  final String retry;

  /// Short in-chart token — the first two characters of the display name, so
  /// `Sun` → `Su` in English and `सूर्य` → `सू` in Hindi.
  String planetToken(String planet) {
    final n = planetName(planet);
    return n.length >= 2 ? n.substring(0, 2) : n;
  }

  static KundaliStrings of(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<KundaliStringsScope>()
          ?.strings ??
      const KundaliStrings();

  static String _identity(String s) => s;
  static String _fallback(String _, String fallback) => fallback;
  static String _asOfEn(String when) => 'As of $when';
  static String _chalitShiftedEn(String planets, int count) =>
      '$planets ${count == 1 ? 'sits' : 'sit'} in a different bhava than '
      'the whole-sign house.';
  static String _chartShortLabelEn(String type) => switch (type) {
    'moon' || 'chandra' => 'Moon',
    'bhava_chalit' => 'Chalit',
    'transit' => 'Transit',
    _ => type.toUpperCase(),
  };
}

/// Provides [KundaliStrings] to every chart widget below it.
class KundaliStringsScope extends InheritedWidget {
  const KundaliStringsScope({
    required this.strings,
    required super.child,
    super.key,
  });

  final KundaliStrings strings;

  @override
  bool updateShouldNotify(KundaliStringsScope oldWidget) =>
      !identical(oldWidget.strings, strings);
}
