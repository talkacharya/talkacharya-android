import 'package:equatable/equatable.dart';

/// One customer GST invoice from `GET /app/invoices` (a `TaxDocument`).
class Invoice extends Equatable {
  const Invoice({
    required this.id,
    required this.number,
    required this.currency,
    required this.total,
    this.tax = 0,
    this.issuedAt,
  });

  final String id;
  final String number;
  final String currency;
  final double total;
  final double tax;
  final DateTime? issuedAt;

  factory Invoice.fromJson(Map<String, dynamic> json) {
    double d(dynamic v) => v == null ? 0 : double.tryParse('$v') ?? 0;
    return Invoice(
      id: '${json['public_id'] ?? json['id'] ?? ''}',
      number: '${json['number'] ?? ''}',
      currency: '${json['currency'] ?? 'INR'}',
      total: d(json['total_amount']),
      tax: d(json['tax_amount']),
      issuedAt: DateTime.tryParse('${json['issued_at'] ?? ''}')?.toLocal(),
    );
  }

  @override
  List<Object?> get props => [id, number, total];
}
