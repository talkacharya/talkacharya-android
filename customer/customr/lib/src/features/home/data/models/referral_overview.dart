import 'package:equatable/equatable.dart';

/// `GET /app/referrals` — just the bits the home banner needs.
class ReferralOverview extends Equatable {
  const ReferralOverview({
    required this.code,
    this.total = 0,
    this.rewarded = 0,
    this.earned = '0',
    this.currency = 'INR',
  });

  final String code;
  final int total;
  final int rewarded;
  final String earned;
  final String currency;

  factory ReferralOverview.fromJson(Map<String, dynamic> json) {
    return ReferralOverview(
      code: '${json['code'] ?? ''}',
      total: (json['total'] as num?)?.toInt() ?? 0,
      rewarded: (json['rewarded'] as num?)?.toInt() ?? 0,
      earned: '${json['earned'] ?? '0'}',
      currency: '${json['currency'] ?? 'INR'}',
    );
  }

  @override
  List<Object?> get props => [code, total, rewarded, earned, currency];
}
