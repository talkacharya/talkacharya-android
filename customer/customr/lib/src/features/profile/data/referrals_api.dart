import 'package:dio/dio.dart';

import '../../../core/constants/api_paths.dart';
import '../../../core/network/api_exception.dart';

/// Mirrors `apps.referrals.serializers.ReferralOverviewSerializer`
/// (`GET /app/referrals`).
class ReferralOverview {
  const ReferralOverview({
    required this.code,
    required this.currency,
    required this.invited,
    required this.pending,
    required this.rewarded,
    required this.earned,
    required this.refereeBonus,
    required this.referrerBonus,
    required this.inviteLink,
    required this.referrals,
  });

  final String code;
  final String currency;
  final int invited;
  final int pending;
  final int rewarded;
  final double earned;
  final double refereeBonus;
  final double referrerBonus;
  final String inviteLink;
  final List<ReferralEntry> referrals;

  factory ReferralOverview.fromJson(Map<String, dynamic> j) => ReferralOverview(
    code: j['code'] as String? ?? '',
    currency: j['currency'] as String? ?? 'INR',
    invited: (j['total'] as num?)?.toInt() ?? 0,
    pending: (j['pending'] as num?)?.toInt() ?? 0,
    rewarded: (j['rewarded'] as num?)?.toInt() ?? 0,
    earned: double.tryParse('${j['earned']}') ?? 0,
    refereeBonus: double.tryParse('${j['referee_bonus']}') ?? 0,
    referrerBonus: double.tryParse('${j['referrer_bonus']}') ?? 0,
    inviteLink: j['invite_link'] as String? ?? '',
    referrals: ((j['referrals'] as List?) ?? const [])
        .map((e) => ReferralEntry.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

class ReferralEntry {
  const ReferralEntry({
    required this.name,
    required this.status,
    required this.bonus,
    required this.currency,
    this.joinedAt,
  });

  /// `pending` · `qualified` · `rewarded` · `void`
  final String name;
  final String status;
  final double bonus;
  final String currency;
  final DateTime? joinedAt;

  bool get isRewarded => status == 'rewarded';
  bool get isJoined => status == 'qualified' || status == 'rewarded';

  factory ReferralEntry.fromJson(Map<String, dynamic> j) => ReferralEntry(
    name: j['referee_name'] as String? ?? '',
    status: j['status'] as String? ?? 'pending',
    bonus: double.tryParse('${j['referrer_bonus']}') ?? 0,
    currency: j['currency'] as String? ?? 'INR',
    joinedAt: DateTime.tryParse('${j['created_at']}')?.toLocal(),
  );
}

/// Transport for the referral programme. Throws [ApiException].
class ReferralsApi {
  ReferralsApi(this._dio);

  final Dio _dio;

  Future<ReferralOverview> overview() async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(ApiPaths.referrals);
      return ReferralOverview.fromJson(res.data ?? const {});
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}
