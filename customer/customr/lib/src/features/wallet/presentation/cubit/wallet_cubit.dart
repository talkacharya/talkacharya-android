import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/realtime/realtime_client.dart';
import '../../../../core/realtime/realtime_event.dart';
import '../../../../core/util/async_value.dart';
import '../../data/wallet_api.dart' show PromoResult;
import '../../data/models/recharge_pack.dart';
import '../../data/models/wallet_balance.dart';
import '../../data/models/wallet_transaction.dart';
import '../../data/wallet_repository.dart';
import '../../../../core/network/friendly_error.dart';

part 'wallet_state.dart';

/// One source of truth for the wallet balance — the Home header chip, the Wallet
/// tab and the recharge flow all read this. Kept in sync by explicit refreshes
/// and by the `wallet.updated` realtime frame (instant balance after a recharge
/// or during a metered call).
class WalletCubit extends Cubit<WalletState> {
  WalletCubit({required WalletRepository repo, RealtimeClient? realtime})
    : _repo = repo,
      super(const WalletState()) {
    _sub = realtime?.events.listen(_onRealtime);
  }

  final WalletRepository _repo;
  StreamSubscription<RealtimeEvent>? _sub;
  bool _loadInFlight = false;

  Future<void> load() async {
    if (_loadInFlight) return;
    _loadInFlight = true;
    try {
      await Future.wait([_loadBalances(), _loadPacks(), _loadRecent()]);
    } finally {
      _loadInFlight = false;
    }
  }

  Future<void> refresh() =>
      Future.wait([_loadBalances(), _loadPacks(), _loadRecent()]);

  Future<void> refreshBalance() =>
      Future.wait([_loadBalances(), _loadRecent()]);

  /// Redeem a coupon/promo code; on success the wallet is refreshed.
  Future<PromoResult> redeemPromo(String code, {String? currency}) async {
    final result = await _repo.redeemPromo(code: code, currency: currency);
    await refreshBalance();
    return result;
  }

  /// Run one slice's fetch. Every `emit` reads `state` *after* the await — the
  /// loaders run concurrently, so a `state.copyWith(...)` whose receiver was
  /// captured before the await would clobber a sibling slice with a stale
  /// snapshot (e.g. leave `balances` stuck on `loading` forever).
  Future<void> _slice<T>({
    required AsyncValue<T> Function(WalletState) read,
    required WalletState Function(WalletState, AsyncValue<T>) write,
    required Future<T> Function() fetch,
  }) async {
    emit(write(state, AsyncValue.loading(read(state).value)));
    try {
      final value = await fetch();
      emit(write(state, AsyncValue.data(value)));
    } catch (e) {
      emit(write(state, AsyncValue.error(friendlyError(e), read(state).value)));
    }
  }

  Future<void> _loadRecent() => _slice(
    read: (s) => s.recent,
    write: (s, v) => s.copyWith(recent: v),
    fetch: () async {
      final page = await _repo.transactions();
      return page.items.take(6).toList();
    },
  );

  Future<void> _loadBalances() => _slice(
    read: (s) => s.balances,
    write: (s, v) => s.copyWith(balances: v),
    fetch: _repo.balances,
  );

  Future<void> _loadPacks() => _slice(
    read: (s) => s.packs,
    write: (s, v) => s.copyWith(packs: v),
    fetch: () => _repo.packs(),
  );

  void _onRealtime(RealtimeEvent event) {
    if (event is! WalletUpdated) return;
    final current = state.balances.value ?? const <WalletBalance>[];
    final available =
        double.tryParse(event.availableBalance) ?? _current(event.currency);
    final next = [
      for (final w in current)
        if (w.currency == event.currency)
          WalletBalance(
            currency: w.currency,
            available: available,
            cached: available + w.held,
            held: w.held,
            frozen: w.frozen,
          )
        else
          w,
    ];
    if (!next.any((w) => w.currency == event.currency)) {
      next.add(WalletBalance(currency: event.currency, available: available));
    }
    emit(state.copyWith(balances: AsyncValue.data(next)));
    // A gentle reconcile against the server a moment later.
    Future<void>.delayed(const Duration(seconds: 2), _loadBalances);
  }

  double _current(String currency) =>
      state.balances.value
          ?.firstWhere(
            (w) => w.currency == currency,
            orElse: () => WalletBalance(currency: currency, available: 0),
          )
          .available ??
      0;

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
