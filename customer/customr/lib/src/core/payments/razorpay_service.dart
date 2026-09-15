import 'dart:async';

import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../features/wallet/data/models/recharge_order.dart';

sealed class RazorpayResult {
  const RazorpayResult();
}

class RazorpaySuccess extends RazorpayResult {
  const RazorpaySuccess({
    required this.paymentId,
    required this.orderId,
    required this.signature,
  });
  final String paymentId;
  final String orderId;
  final String signature;
}

class RazorpayFailure extends RazorpayResult {
  const RazorpayFailure({this.code, this.message = ''});
  final int? code;
  final String message;

  /// The user dismissed Razorpay's sheet without paying.
  bool get cancelled => code == Razorpay.PAYMENT_CANCELLED;
}

/// Thin wrapper around `razorpay_flutter`'s callback API — exposes a single
/// [checkout] future so the recharge cubit can `await` it.
class RazorpayService {
  Future<RazorpayResult> checkout({
    required RechargeOrder order,
    required String appName,
    required String description,
    String? contact,
    String? email,
  }) {
    final rp = Razorpay();
    final completer = Completer<RazorpayResult>();

    void done(RazorpayResult r) {
      if (!completer.isCompleted) completer.complete(r);
    }

    rp.on(Razorpay.EVENT_PAYMENT_SUCCESS, (PaymentSuccessResponse res) {
      done(
        RazorpaySuccess(
          paymentId: res.paymentId ?? '',
          orderId: res.orderId ?? order.gatewayOrderId,
          signature: res.signature ?? '',
        ),
      );
    });
    rp.on(Razorpay.EVENT_PAYMENT_ERROR, (PaymentFailureResponse res) {
      done(RazorpayFailure(code: res.code, message: res.message ?? ''));
    });
    rp.on(Razorpay.EVENT_EXTERNAL_WALLET, (_) {
      /* handled inside Razorpay */
    });

    try {
      rp.open({
        'key': order.keyId,
        'order_id': order.gatewayOrderId,
        'amount': order.amountMinor,
        'currency': order.currency,
        'name': appName,
        'description': description,
        'timeout': 300,
        'retry': {'enabled': true, 'max_count': 2},
        'theme': {'color': '#EA6A1E'},
        if (contact != null && contact.isNotEmpty || email != null)
          'prefill': {'contact': ?contact, 'email': ?email},
      });
    } catch (e) {
      done(RazorpayFailure(message: '$e'));
    }

    return completer.future.whenComplete(rp.clear);
  }
}
