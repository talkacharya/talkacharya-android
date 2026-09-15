import '../../../../core/payments/razorpay_service.dart';
import '../../../wallet/presentation/cubit/wallet_cubit.dart';
import '../../data/models/order.dart';
import '../../data/store_repository.dart';

/// Who is paying and what the Razorpay sheet should say.
typedef PayerInfo = ({
  String appName,
  String description,
  String? contact,
  String? email,
});

sealed class GatewayOutcome {
  const GatewayOutcome();
}

/// The gateway share is settled — [order] is the fresh server copy.
class GatewayPaid extends GatewayOutcome {
  const GatewayPaid(this.order);
  final StoreOrder order;
}

/// The customer closed the Razorpay sheet. The order stays pending until it expires.
class GatewayCancelled extends GatewayOutcome {
  const GatewayCancelled();
}

/// Razorpay reported success but the server hasn't confirmed yet (webhook will).
class GatewayConfirming extends GatewayOutcome {
  const GatewayConfirming();
}

class GatewayFailed extends GatewayOutcome {
  const GatewayFailed(this.message);
  final String message;
}

/// Runs the Razorpay sheet for a store order's gateway share and confirms it with
/// the backend. Shared by checkout (first attempt) and order detail (retry).
class StorePaymentFlow {
  StorePaymentFlow({
    required StoreRepository repo,
    required RazorpayService razorpay,
    required WalletCubit wallet,
  }) : _repo = repo,
       _razorpay = razorpay,
       _wallet = wallet;

  final StoreRepository _repo;
  final RazorpayService _razorpay;
  final WalletCubit _wallet;

  Future<GatewayOutcome> pay({
    required String orderId,
    required StorePayment payment,
    required PayerInfo payer,
  }) async {
    final result = await _razorpay.checkout(
      order: payment.toGatewayOrder(),
      appName: payer.appName,
      description: payer.description,
      contact: payer.contact,
      email: payer.email,
    );
    switch (result) {
      case RazorpayFailure(:final cancelled, :final message):
        return cancelled ? const GatewayCancelled() : GatewayFailed(message);
      case final RazorpaySuccess s:
        return _confirm(orderId, s);
    }
  }

  Future<GatewayOutcome> _confirm(String orderId, RazorpaySuccess s) async {
    StoreOrder? order;
    try {
      order = await _repo.verifyPayment(
        orderId,
        paymentId: s.paymentId,
        signature: s.signature,
      );
    } catch (_) {
      // A hiccup or a signature the server can't check yet — the webhook still
      // settles it, so poll the order for a few seconds before giving up.
    }
    for (var i = 0; i < 4 && (order?.awaitingPayment ?? true); i++) {
      await Future<void>.delayed(const Duration(milliseconds: 1500));
      try {
        order = await _repo.order(orderId);
      } catch (_) {}
    }
    // Wallet share was debited when the order was placed.
    await _wallet.refreshBalance();
    if (order == null || order.awaitingPayment) {
      return const GatewayConfirming();
    }
    return GatewayPaid(order);
  }
}
