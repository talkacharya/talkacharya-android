import 'package:talkacharya_predictions/talkacharya_predictions.dart';

import 'predictions_api.dart';

class PredictionsRepository {
  PredictionsRepository(this._api);

  final PredictionsApi _api;

  Future<List<Prediction>> queue() async => (await _api.queue())
      .map((e) => Prediction.fromMap((e as Map).cast<String, dynamic>()))
      .toList();

  Future<Prediction> detail(String id) async =>
      Prediction.fromMap(await _api.detail(id));

  Future<Prediction> claim(String id) async =>
      Prediction.fromMap(await _api.claim(id));

  Future<Prediction> saveDraft(
    String id, {
    required String title,
    required String body,
  }) async =>
      Prediction.fromMap(await _api.saveDraft(id, title: title, body: body));

  Future<Prediction> deliver(
    String id, {
    required String title,
    required String body,
  }) async =>
      Prediction.fromMap(await _api.deliver(id, title: title, body: body));

  Future<Prediction> release(String id) async =>
      Prediction.fromMap(await _api.release(id));
}
