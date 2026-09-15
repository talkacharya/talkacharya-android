import 'package:equatable/equatable.dart';

import 'product.dart';
import 'store_json.dart';

/// Backend `ConsultStatus`.
enum ConsultStatus {
  awaitingVerdict,
  verdictGiven,
  cancelled,
  expired;

  static ConsultStatus parse(String? s) => switch (s) {
    'verdict_given' => verdictGiven,
    'cancelled' => cancelled,
    'expired' => expired,
    _ => awaitingVerdict,
  };
}

/// Backend `ConsultVerdict`.
enum VerdictKind {
  suitable,
  notSuitable,
  alternative;

  static VerdictKind parse(String? s) => switch (s) {
    'not_suitable' => notSuitable,
    'alternative' => alternative,
    _ => suitable,
  };

  bool get positive => this != notSuitable;
}

class ConsultVerdict extends Equatable {
  const ConsultVerdict({
    required this.kind,
    this.label = '',
    this.note = '',
    this.at,
    this.recommendedVariantId,
    this.alternativeProduct,
    this.recommendationId,
  });

  final VerdictKind kind;
  final String label;
  final String note;
  final DateTime? at;
  final String? recommendedVariantId;
  final ProductCard? alternativeProduct;

  /// Pass to `cart/items` so the purchase counts as recommended.
  final String? recommendationId;

  factory ConsultVerdict.fromJson(Json j) => ConsultVerdict(
    kind: VerdictKind.parse(jStrOrNull(j['value'])),
    label: jStr(j['label']),
    note: jStr(j['note']),
    at: jDate(j['at']),
    recommendedVariantId: jStrOrNull(j['recommended_variant_id']),
    alternativeProduct: jMapOrNull(j['alternative_product']) == null
        ? null
        : ProductCard.fromJson(jMap(j['alternative_product'])),
    recommendationId: jStrOrNull(j['recommendation_id']),
  );

  @override
  List<Object?> get props => [kind, note, at, recommendationId];
}

/// A product discussed on a consultation (`StoreConsultSerializer`).
class StoreConsult extends Equatable {
  const StoreConsult({
    required this.id,
    required this.status,
    required this.consultationId,
    this.consultationChannel = 'video',
    this.consultationStatus = 'requested',
    this.consultationEndedAt,
    this.question = '',
    this.createdAt,
    this.astrologerId = '',
    this.astrologerName = '',
    this.astrologerAvatar,
    this.product,
    this.variantId,
    this.verdict,
  });

  final String id;
  final ConsultStatus status;
  final String consultationId;
  final String consultationChannel;
  final String consultationStatus;
  final DateTime? consultationEndedAt;
  final String question;
  final DateTime? createdAt;
  final String astrologerId;
  final String astrologerName;
  final String? astrologerAvatar;
  final ProductCard? product;
  final String? variantId;
  final ConsultVerdict? verdict;

  bool get callLive =>
      consultationStatus == 'requested' ||
      consultationStatus == 'accepted' ||
      consultationStatus == 'active';

  factory StoreConsult.fromJson(Json j) {
    final c = jMap(j['consultation']);
    final a = jMap(j['astrologer']);
    return StoreConsult(
      id: jStr(j['id']),
      status: ConsultStatus.parse(jStrOrNull(j['status'])),
      consultationId: jStr(c['id']),
      consultationChannel: jStr(c['channel'], 'video'),
      consultationStatus: jStr(c['status'], 'requested'),
      consultationEndedAt: jDate(c['ended_at']),
      question: jStr(j['question']),
      createdAt: jDate(j['created_at']),
      astrologerId: jStr(a['id']),
      astrologerName: jStr(a['name']),
      astrologerAvatar: jStrOrNull(a['avatar']),
      product: jMapOrNull(j['product']) == null
          ? null
          : ProductCard.fromJson(jMap(j['product'])),
      variantId: jStrOrNull(j['variant_id']),
      verdict: jMapOrNull(j['verdict']) == null
          ? null
          : ConsultVerdict.fromJson(jMap(j['verdict'])),
    );
  }

  @override
  List<Object?> get props => [id, status, consultationStatus, verdict];
}

/// An astrologer the customer can call about a product.
class ConsultAstrologer extends Equatable {
  const ConsultAstrologer({
    required this.id,
    required this.name,
    this.avatar,
    this.headline = '',
    this.yearsExperience = 0,
    this.ratingAvg = 0,
    this.ratingCount = 0,
    this.languages = const [],
    this.skills = const [],
    this.presence = 'offline',
    this.ratePerMinute = 0,
    this.skillMatch = false,
  });

  final String id;
  final String name;
  final String? avatar;
  final String headline;
  final int yearsExperience;
  final double ratingAvg;
  final int ratingCount;
  final List<String> languages;
  final List<String> skills;

  /// online | busy | away | offline
  final String presence;
  final double ratePerMinute;
  final bool skillMatch;

  bool get isOnline => presence == 'online';
  bool get canCallNow => presence == 'online';

  factory ConsultAstrologer.fromJson(Json j) => ConsultAstrologer(
    id: jStr(j['id']),
    name: jStr(j['name']),
    avatar: jStrOrNull(j['avatar']),
    headline: jStr(j['headline']),
    yearsExperience: jInt(j['years_experience']),
    ratingAvg: jNum(j['rating_avg']),
    ratingCount: jInt(j['rating_count']),
    languages: jStrings(j['languages']),
    skills: jStrings(j['skills']),
    presence: jStr(j['presence'], 'offline'),
    ratePerMinute: jNum(j['rate_per_minute']),
    skillMatch: jBool(j['skill_match']),
  );

  @override
  List<Object?> get props => [id, presence, ratePerMinute];
}

/// `GET /store/products/{slug}/consult`.
class ConsultOptions extends Equatable {
  const ConsultOptions({
    this.enabled = false,
    this.productId = '',
    this.channel = 'video',
    this.channels = const ['video'],
    this.currency = 'INR',
    this.required = false,
    this.offerCouponCode,
    this.question = '',
    this.preauthMinutes = 5,
    this.astrologers = const [],
  });

  final bool enabled;
  final String productId;
  final String channel;
  final List<String> channels;
  final String currency;
  final bool required;
  final String? offerCouponCode;
  final String question;
  final int preauthMinutes;
  final List<ConsultAstrologer> astrologers;

  factory ConsultOptions.fromJson(Json j) => ConsultOptions(
    enabled: jBool(j['enabled']),
    productId: jStr(j['product_id']),
    channel: jStr(j['channel'], 'video'),
    channels: jStrings(j['channels']).isEmpty
        ? const ['video']
        : jStrings(j['channels']),
    currency: jStr(j['currency'], 'INR'),
    required: jBool(j['required']),
    offerCouponCode: jStrOrNull(j['offer_coupon_code']),
    question: jStr(j['question']),
    preauthMinutes: jInt(j['preauth_minutes'], 5),
    astrologers: jList(j['astrologers'], ConsultAstrologer.fromJson),
  );

  @override
  List<Object?> get props => [enabled, channel, astrologers];
}
