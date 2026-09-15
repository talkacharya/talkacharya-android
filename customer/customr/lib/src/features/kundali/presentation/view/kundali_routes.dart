/// Path helpers for the `/kundali/:id/...` section (a ShellRoute provides the
/// [KundaliCubit] to all of these).
class KundaliRoutes {
  const KundaliRoutes._();

  static const base = '/kundali';
  static String overview(String id) => '/kundali/$id';
  static String chart(String id) => '/kundali/$id/chart';
  static String chartDetail(String id, String type) =>
      '/kundali/$id/chart/$type';
  static String insights(String id) => '/kundali/$id/insights';
  static String remedies(String id) => '/kundali/$id/remedies';
  static String mood(String id) => '/kundali/$id/mood';
  static String numerology(String id) => '/kundali/$id/numerology';
  static String sadeSati(String id) => '/kundali/$id/sade-sati';
  static String muhurta(String id) => '/kundali/$id/muhurta';
  static String jyotishUpaya(String id) => '/kundali/$id/jyotish-upaya';
  static String lalKitab(String id) => '/kundali/$id/lal-kitab';
  static String varshphal(String id) => '/kundali/$id/varshphal';
  static String planets(String id) => '/kundali/$id/planets';
  static String dasha(String id) => '/kundali/$id/dasha';
  static String transits(String id) => '/kundali/$id/transits';
  static String yogas(String id) => '/kundali/$id/yogas';
  static String houses(String id) => '/kundali/$id/houses';
  static String advanced(String id) => '/kundali/$id/advanced';
  static String advancedReport(String id, String report) =>
      '/kundali/$id/advanced/$report';
}
