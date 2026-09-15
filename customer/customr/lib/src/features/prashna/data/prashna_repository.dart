import 'package:astro_kundali/astro_kundali.dart';

import 'prashna_api.dart';

class PrashnaRepository {
  PrashnaRepository(this._api);

  final PrashnaApi _api;

  Future<PrashnaCatalog> catalog() async =>
      PrashnaCatalog.fromMap(await _api.catalog());

  Future<List<Prashna>> list() async => (await _api.list())
      .map((e) => Prashna.fromMap((e as Map).cast<String, dynamic>()))
      .toList();

  Future<Prashna> detail(String id) async =>
      Prashna.fromMap(await _api.detail(id));

  Future<Prashna> ask({
    required String question,
    required String category,
    double? latitude,
    double? longitude,
    String? placeLabel,
  }) async => Prashna.fromMap(
    await _api.ask(
      question: question,
      category: category,
      latitude: latitude,
      longitude: longitude,
      placeLabel: placeLabel,
    ),
  );
}
