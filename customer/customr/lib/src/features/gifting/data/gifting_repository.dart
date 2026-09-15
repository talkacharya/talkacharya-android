import 'dart:math';

import 'gifting_api.dart';
import 'models/gift.dart';

class GiftingRepository {
  GiftingRepository(this._api);

  final GiftingApi _api;
  List<Gift>? _catalog;

  /// The active catalog — fetched once per app run (it changes rarely), then
  /// served from memory so the sheet opens instantly the second time.
  Future<List<Gift>> catalog({bool refresh = false}) async {
    if (!refresh && _catalog != null) return _catalog!;
    return _catalog = await _api.catalog();
  }

  /// One send. [idempotencyKey] must be reused for a retry of the *same* tap so
  /// a flaky network can never charge twice.
  Future<GiftTransaction> send({
    required Gift gift,
    required int quantity,
    required GiftTarget target,
    required String idempotencyKey,
    String message = '',
  }) => _api.send(
    gift: gift.slug,
    quantity: quantity,
    target: target,
    idempotencyKey: idempotencyKey,
    message: message,
  );

  Future<SentGiftsPage> sent({String? cursor}) => _api.sent(cursor: cursor);

  static final _rng = Random.secure();

  static String newIdempotencyKey() {
    final bytes = List<int>.generate(16, (_) => _rng.nextInt(256));
    final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return 'gift-$hex';
  }
}
