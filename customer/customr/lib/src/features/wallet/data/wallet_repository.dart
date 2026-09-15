import '../../../core/config/config_repository.dart';
import 'models/recharge_order.dart';
import 'models/recharge_pack.dart';
import 'models/wallet_balance.dart';
import 'wallet_api.dart';

class WalletRepository {
  WalletRepository({required WalletApi api, required ConfigRepository config})
    : _api = api,
      _config = config;

  final WalletApi _api;
  final ConfigRepository _config;

  Future<List<WalletBalance>> balances() => _api.balances();

  Future<WalletPacks> packs({String? currency}) async {
    try {
      return await _api.packs(currency: currency);
    } catch (_) {
      final min =
          double.tryParse(_config.value.minRecharge.amount)?.round() ?? 100;
      final cur = currency ?? _config.value.minRecharge.currency;
      return WalletPacks(
        currency: cur,
        minRecharge: min.toDouble(),
        packs: RechargePack.fallback(minRecharge: min, currency: cur),
      );
    }
  }

  Future<TransactionsPage> transactions({String? cursor, String? currency}) =>
      _api.transactions(cursor: cursor, currency: currency);

  Future<RechargeOrder> createRecharge({
    required num amount,
    String? currency,
  }) => _api.createRecharge(amount: amount, currency: currency);

  Future<PaymentStatus> rechargeStatus(String paymentId) =>
      _api.rechargeStatus(paymentId);

  Future<PaymentStatus> verifyRecharge(
    String paymentId, {
    required String razorpayPaymentId,
    required String razorpayOrderId,
    required String razorpaySignature,
  }) => _api.verifyRecharge(
    paymentId,
    razorpayPaymentId: razorpayPaymentId,
    razorpayOrderId: razorpayOrderId,
    razorpaySignature: razorpaySignature,
  );

  Future<PromoResult> redeemPromo({
    required String code,
    String? currency,
    num? rechargeAmount,
  }) => _api.redeemPromo(
    code: code,
    currency: currency,
    rechargeAmount: rechargeAmount,
  );

  double get minRecharge =>
      double.tryParse(_config.value.minRecharge.amount) ?? 100;
}
