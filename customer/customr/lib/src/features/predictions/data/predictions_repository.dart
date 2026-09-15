import 'package:talkacharya_predictions/talkacharya_predictions.dart';

import 'predictions_api.dart';

class BuyPackResult {
  const BuyPackResult({required this.order, required this.creditBalance});
  final PredictionOrder order;
  final int creditBalance;
}

class PredictionsRepository {
  PredictionsRepository(this._api);

  final PredictionsApi _api;

  Future<PredictionCatalog> catalog() async =>
      PredictionCatalog.fromMap(await _api.catalog());

  Future<List<PredictionOrder>> orders() async => (await _api.orders())
      .map((e) => PredictionOrder.fromMap((e as Map).cast<String, dynamic>()))
      .toList();

  Future<BuyPackResult> buyPack(int pack) async {
    final j = await _api.buyPack(pack);
    return BuyPackResult(
      order: PredictionOrder.fromMap(
        (j['order'] as Map).cast<String, dynamic>(),
      ),
      creditBalance: (j['credit_balance'] as num?)?.toInt() ?? 0,
    );
  }

  Future<SubscriptionStatus> subscription(
    String action, {
    String? birthProfileId,
  }) async {
    final j = await _api.subscription(action, birthProfileId: birthProfileId);
    return SubscriptionStatus.fromWire(j['status'] as String?);
  }

  Future<List<Prediction>> list() async => (await _api.list())
      .map((e) => Prediction.fromMap((e as Map).cast<String, dynamic>()))
      .toList();

  Future<Prediction> request({
    required String birthProfileId,
    required PredictionArea area,
    required PredictionPeriod period,
  }) async => Prediction.fromMap(
    await _api.request(
      birthProfileId: birthProfileId,
      area: area.wire,
      period: period.wire,
    ),
  );

  Future<Prediction> detail(String id) async =>
      Prediction.fromMap(await _api.detail(id));
}
