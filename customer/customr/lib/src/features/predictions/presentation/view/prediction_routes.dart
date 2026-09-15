class PredictionRoutes {
  const PredictionRoutes._();

  static const base = '/predictions';
  static const request = '/predictions/request';
  static String detail(String id) => '/predictions/$id';
}
