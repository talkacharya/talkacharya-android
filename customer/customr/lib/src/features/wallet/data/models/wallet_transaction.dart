import 'package:equatable/equatable.dart';

/// One ledger movement from `GET /app/wallet/transactions`.
class WalletTransaction extends Equatable {
  const WalletTransaction({
    required this.id,
    required this.direction,
    required this.amount,
    required this.currency,
    required this.kind,
    required this.kindLabel,
    required this.balanceAfter,
    this.reason = '',
    this.createdAt,
  });

  final String id;
  final String direction; // credit | debit
  final double amount;
  final String currency;

  /// Backend [EntryKind] slug — used to pick the icon and a localized label.
  final String kind;

  /// The server's localized label (fallback when the client has no mapping).
  final String kindLabel;
  final double balanceAfter;
  final String reason;
  final DateTime? createdAt;

  bool get isCredit => direction == 'credit';
  double get signedAmount => isCredit ? amount : -amount;

  factory WalletTransaction.fromJson(Map<String, dynamic> json) {
    double d(dynamic v) => v == null ? 0 : double.tryParse('$v') ?? 0;
    return WalletTransaction(
      id: '${json['id'] ?? ''}',
      direction: '${json['direction'] ?? 'debit'}',
      amount: d(json['amount']),
      currency: '${json['currency'] ?? 'INR'}',
      kind: '${json['kind'] ?? ''}',
      kindLabel: '${json['kind_label'] ?? json['kind'] ?? ''}',
      balanceAfter: d(json['balance_after']),
      reason: '${json['reason'] ?? ''}',
      createdAt: DateTime.tryParse('${json['created_at'] ?? ''}')?.toLocal(),
    );
  }

  @override
  List<Object?> get props => [id, direction, amount, kind, balanceAfter];
}
