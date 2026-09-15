import 'package:equatable/equatable.dart';

/// One catalog item from `GET /app/gifts`.
///
/// Prices are per currency (`unit_prices`); a currency the catalog doesn't list
/// is FX-derived from the INR price at send time, so [priceIn] returns `null`
/// and the UI shows the INR price as an estimate.
class Gift extends Equatable {
  const Gift({
    required this.slug,
    required this.name,
    this.category = 'sticker',
    this.coins = 0,
    this.unitPrices = const {},
  });

  final String slug;
  final String name;
  final String category;
  final int coins;
  final Map<String, double> unitPrices;

  /// Price of one gift in [currency], or `null` when the server will convert.
  double? priceIn(String currency) => unitPrices[currency.toUpperCase()];

  /// Best display price: the exact one, else the INR base (flagged estimate).
  ({double amount, String currency, bool estimate}) displayPrice(
    String currency,
  ) {
    final exact = priceIn(currency);
    if (exact != null) {
      return (amount: exact, currency: currency, estimate: false);
    }
    return (
      amount: unitPrices['INR'] ?? coins.toDouble(),
      currency: 'INR',
      estimate: currency.toUpperCase() != 'INR',
    );
  }

  factory Gift.fromJson(Map<String, dynamic> j) {
    final raw = (j['unit_prices'] as Map?)?.cast<String, dynamic>() ?? const {};
    return Gift(
      slug: '${j['slug'] ?? ''}',
      name: '${j['name'] ?? ''}',
      category: '${j['category'] ?? 'sticker'}',
      coins: (j['coins'] as num?)?.toInt() ?? 0,
      unitPrices: {
        for (final e in raw.entries)
          if (double.tryParse('${e.value}') != null)
            e.key.toUpperCase(): double.parse('${e.value}'),
      },
    );
  }

  @override
  List<Object?> get props => [slug, name, category, coins, unitPrices];
}

/// A completed send, from `POST /app/gifts/send` or `GET /app/gifts/sent`.
class GiftTransaction extends Equatable {
  const GiftTransaction({
    required this.id,
    required this.gift,
    required this.giftName,
    this.quantity = 1,
    this.grossAmount = 0,
    this.currency = 'INR',
    this.context = 'profile',
    this.astrologerId = '',
    this.astrologerName = '',
    this.message = '',
    this.createdAt,
  });

  final String id;
  final String gift;
  final String giftName;
  final int quantity;
  final double grossAmount;
  final String currency;

  /// `consultation`, `livestream` or `profile`.
  final String context;
  final String astrologerId;
  final String astrologerName;
  final String message;
  final DateTime? createdAt;

  factory GiftTransaction.fromJson(Map<String, dynamic> j) => GiftTransaction(
    id: '${j['public_id'] ?? ''}',
    gift: '${j['gift'] ?? ''}',
    giftName: '${j['gift_name'] ?? ''}',
    quantity: (j['quantity'] as num?)?.toInt() ?? 1,
    grossAmount: double.tryParse('${j['gross_amount']}') ?? 0,
    currency: '${j['currency'] ?? 'INR'}',
    context: '${j['context'] ?? 'profile'}',
    astrologerId: '${j['astrologer'] ?? ''}',
    astrologerName: '${j['astrologer_name'] ?? ''}',
    message: '${j['message'] ?? ''}',
    createdAt: DateTime.tryParse('${j['created_at']}'),
  );

  @override
  List<Object?> get props => [id, gift, quantity, grossAmount, currency];
}

/// Who a gift goes to. Exactly one target per send (mirrors the backend).
sealed class GiftTarget extends Equatable {
  const GiftTarget({required this.astrologerName, required this.currency});

  final String astrologerName;

  /// The wallet the gift is paid from.
  final String currency;

  Map<String, String> get body;
}

/// From the astrologer's profile, outside any session.
class ProfileGiftTarget extends GiftTarget {
  const ProfileGiftTarget({
    required this.astrologerId,
    required super.astrologerName,
    required super.currency,
  });

  final String astrologerId;

  @override
  Map<String, String> get body => {'astrologer': astrologerId};

  @override
  List<Object?> get props => [astrologerId, currency];
}

/// During a live consultation, or as a thank-you shortly after it ends.
class ConsultationGiftTarget extends GiftTarget {
  const ConsultationGiftTarget({
    required this.consultationId,
    required super.astrologerName,
    required super.currency,
  });

  final String consultationId;

  @override
  Map<String, String> get body => {'consultation': consultationId};

  @override
  List<Object?> get props => [consultationId, currency];
}

/// On a live stream the viewer is watching.
class LivestreamGiftTarget extends GiftTarget {
  const LivestreamGiftTarget({
    required this.livestreamId,
    required super.astrologerName,
    required super.currency,
  });

  final String livestreamId;

  @override
  Map<String, String> get body => {'livestream': livestreamId};

  @override
  List<Object?> get props => [livestreamId, currency];
}
