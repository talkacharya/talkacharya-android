/// A gift someone sent this astrologer.
class ReceivedGift {
  const ReceivedGift({
    required this.id,
    this.giftSlug = '',
    this.giftName = '',
    this.senderName = '',
    this.quantity = 1,
    this.grossAmount = 0,
    this.currency = 'INR',
    this.context = '',
    this.message = '',
    this.status = '',
    this.createdAt,
  });

  final String id;
  final String giftSlug;
  final String giftName;
  final String senderName;
  final int quantity;
  final double grossAmount;
  final String currency;

  /// `livestream` or `consultation` — where it was sent from.
  final String context;
  final String message;
  final String status;
  final DateTime? createdAt;

  factory ReceivedGift.fromJson(Map<String, dynamic> j) => ReceivedGift(
    id: j['public_id']?.toString() ?? '',
    giftSlug: j['gift'] as String? ?? '',
    giftName: j['gift_name'] as String? ?? '',
    senderName: j['sender_name'] as String? ?? '',
    quantity: (j['quantity'] as num?)?.toInt() ?? 1,
    grossAmount: double.tryParse('${j['gross_amount']}') ?? 0,
    currency: j['currency'] as String? ?? 'INR',
    context: j['context'] as String? ?? '',
    message: j['message'] as String? ?? '',
    status: j['status'] as String? ?? '',
    createdAt: DateTime.tryParse('${j['created_at']}')?.toLocal(),
  );

  /// A refunded gift is still shown — it was still sent — but it is not money.
  bool get isRefunded => status == 'refunded';
}
