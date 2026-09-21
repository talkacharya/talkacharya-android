import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/payments/razorpay_service.dart';
import '../../data/models/recharge_order.dart';
import '../../data/wallet_repository.dart';
import 'wallet_cubit.dart';
import '../../../../core/network/friendly_error.dart';

part 'recharge_state.dart';

/// Drives one recharge attempt end to end:
///
///   idle → creatingOrder → checkout → confirming → success | failed
///
/// The webhook stays the source of truth; `verify` + a short poll only make the
/// balance land instantly. If both are slow we still show success with a
/// "credited in a moment" note rather than leaving the user stuck.
class RechargeCubit extends Cubit<RechargeState> {
  RechargeCubit({
    required WalletRepository repo,
    required RazorpayService razorpay,
    required WalletCubit wallet,
  }) : _repo = repo,
       _razorpay = razorpay,
       _wallet = wallet,
       super(const RechargeState());

  final WalletRepository _repo;
  final RazorpayService _razorpay;
  final WalletCubit _wallet;

  Future<void> start({
    required num amount,
    required String currency,
    required String appName,
    required String description,
    String? contact,
    String? email,
  }) async {
    emit(
      RechargeState(
        status: RechargeStatus.creatingOrder,
        amount: amount.toDouble(),
        currency: currency,
      ),
    );
    try {
      final order = await _repo.createRecharge(
        amount: amount,
        currency: currency,
      );
      emit(state.copyWith(status: RechargeStatus.checkout, order: order));

      final result = await _razorpay.checkout(
        order: order,
        appName: appName,
        description: description,
        contact: contact,
        email: email,
      );

      switch (result) {
        case final RazorpaySuccess s:
          emit(state.copyWith(status: RechargeStatus.confirming));
          await _confirm(order, s);
        case final RazorpayFailure f:
          emit(
            state.copyWith(
              status: RechargeStatus.failed,
              cancelled: f.cancelled,
              message: f.cancelled ? null : f.message,
            ),
          );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: RechargeStatus.failed,
          message: friendlyError(e),
          error: () => e,
        ),
      );
    }
  }

  Future<void> _confirm(RechargeOrder order, RazorpaySuccess s) async {
    PaymentStatus? status;
    try {
      status = await _repo.verifyRecharge(
        order.paymentId,
        razorpayPaymentId: s.paymentId,
        razorpayOrderId: s.orderId,
        razorpaySignature: s.signature,
      );
    } catch (_) {
      // verify failed (rare — bad signature or a hiccup); fall through to polling
    }

    for (
      var i = 0;
      i < 4 && (status?.state ?? PaymentState.pending) == PaymentState.pending;
      i++
    ) {
      await Future<void>.delayed(const Duration(milliseconds: 1500));
      try {
        status = await _repo.rechargeStatus(order.paymentId);
      } catch (_) {}
    }

    await _wallet.refreshBalance();
    final newBalance = _wallet.state.primaryFor(order.currency)?.available;
    final captured = status?.state == PaymentState.captured;

    emit(
      state.copyWith(
        status: RechargeStatus.success,
        newBalance: () => captured ? newBalance : null,
        pendingWebhook: !captured,
      ),
    );
  }

  void reset() => emit(const RechargeState());
}
