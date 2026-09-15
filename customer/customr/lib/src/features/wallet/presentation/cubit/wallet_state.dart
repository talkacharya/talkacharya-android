part of 'wallet_cubit.dart';

class WalletState extends Equatable {
  const WalletState({
    this.balances = const AsyncValue.idle(),
    this.packs = const AsyncValue.idle(),
    this.recent = const AsyncValue.idle(),
  });

  final AsyncValue<List<WalletBalance>> balances;
  final AsyncValue<WalletPacks> packs;
  final AsyncValue<List<WalletTransaction>> recent;

  WalletBalance? primaryFor(String currency) =>
      balances.value?.primary(currency);

  WalletState copyWith({
    AsyncValue<List<WalletBalance>>? balances,
    AsyncValue<WalletPacks>? packs,
    AsyncValue<List<WalletTransaction>>? recent,
  }) {
    return WalletState(
      balances: balances ?? this.balances,
      packs: packs ?? this.packs,
      recent: recent ?? this.recent,
    );
  }

  @override
  List<Object?> get props => [balances, packs, recent];
}
