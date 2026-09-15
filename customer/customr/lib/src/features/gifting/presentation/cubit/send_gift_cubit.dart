import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/gifting_api.dart';
import '../../data/gifting_repository.dart';
import '../../data/models/gift.dart';

part 'send_gift_state.dart';

/// Drives the gift sheet for one [GiftTarget]:
///
///   loading → ready ⇄ sending → sent | (ready + error / lowBalance)
///
/// A retry after a failure reuses the same idempotency key, so a send that
/// actually landed server-side is never charged twice. Changing the gift or
/// quantity starts a fresh key.
class SendGiftCubit extends Cubit<SendGiftState> {
  SendGiftCubit({
    required GiftingRepository repo,
    required GiftTarget target,
    Future<void> Function()? onSent,
  }) : _repo = repo,
       _onSent = onSent,
       super(SendGiftState(target: target));

  final GiftingRepository _repo;
  final Future<void> Function()? _onSent;
  String? _pendingKey;

  Future<void> load() async {
    emit(state.copyWith(status: SendGiftStatus.loading, clearError: true));
    try {
      final gifts = await _repo.catalog();
      emit(
        state.copyWith(
          status: SendGiftStatus.ready,
          gifts: gifts,
          selected: state.selected ?? (gifts.length > 1 ? gifts[1] : null),
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: SendGiftStatus.failed, error: e));
    }
  }

  void select(Gift gift) {
    if (state.isSending) return;
    _pendingKey = null;
    emit(state.copyWith(selected: gift, lowBalance: false, clearError: true));
  }

  void setQuantity(int quantity) {
    if (state.isSending) return;
    _pendingKey = null;
    emit(
      state.copyWith(
        quantity: quantity.clamp(1, SendGiftState.maxQuantity),
        lowBalance: false,
        clearError: true,
      ),
    );
  }

  Future<void> send({String message = ''}) async {
    final gift = state.selected;
    if (gift == null || state.isSending) return;
    _pendingKey ??= GiftingRepository.newIdempotencyKey();
    emit(
      state.copyWith(
        status: SendGiftStatus.sending,
        lowBalance: false,
        clearError: true,
      ),
    );
    try {
      final txn = await _repo.send(
        gift: gift,
        quantity: state.quantity,
        target: state.target,
        idempotencyKey: _pendingKey!,
        message: message.trim(),
      );
      _pendingKey = null;
      emit(state.copyWith(status: SendGiftStatus.sent, sent: txn));
      await _onSent?.call();
    } on GiftInsufficientBalance {
      // Nothing was charged — a fresh key after the top-up is safe.
      _pendingKey = null;
      emit(state.copyWith(status: SendGiftStatus.ready, lowBalance: true));
    } catch (e) {
      emit(state.copyWith(status: SendGiftStatus.ready, error: e));
    }
  }

  /// "Send another" from the success face.
  void again() {
    _pendingKey = null;
    emit(
      state.copyWith(
        status: SendGiftStatus.ready,
        quantity: 1,
        clearSent: true,
        clearError: true,
      ),
    );
  }
}
