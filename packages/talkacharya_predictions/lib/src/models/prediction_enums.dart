/// Wire values match ``apps/predictions/models.py``.
enum PredictionArea {
  career,
  marriageLove,
  finance,
  health,
  education,
  general;

  static PredictionArea fromWire(String v) => switch (v) {
    'career' => PredictionArea.career,
    'marriage_love' => PredictionArea.marriageLove,
    'finance' => PredictionArea.finance,
    'health' => PredictionArea.health,
    'education' => PredictionArea.education,
    _ => PredictionArea.general,
  };

  String get wire => switch (this) {
    PredictionArea.career => 'career',
    PredictionArea.marriageLove => 'marriage_love',
    PredictionArea.finance => 'finance',
    PredictionArea.health => 'health',
    PredictionArea.education => 'education',
    PredictionArea.general => 'general',
  };
}

enum PredictionPeriod {
  month,
  quarter,
  year;

  static PredictionPeriod fromWire(String v) => switch (v) {
    'month' => PredictionPeriod.month,
    'quarter' => PredictionPeriod.quarter,
    _ => PredictionPeriod.year,
  };

  String get wire => name;
}

enum PredictionStatus {
  requested,
  drafting,
  inReview,
  delivered,
  rejected,
  refunded;

  static PredictionStatus fromWire(String v) => switch (v) {
    'requested' => PredictionStatus.requested,
    'drafting' => PredictionStatus.drafting,
    'in_review' => PredictionStatus.inReview,
    'delivered' => PredictionStatus.delivered,
    'rejected' => PredictionStatus.rejected,
    'refunded' => PredictionStatus.refunded,
    _ => PredictionStatus.requested,
  };

  bool get isOpen =>
      this == PredictionStatus.requested ||
      this == PredictionStatus.drafting ||
      this == PredictionStatus.inReview;

  bool get isDelivered => this == PredictionStatus.delivered;
}

enum SubscriptionStatus {
  none,
  active,
  paused,
  cancelled;

  static SubscriptionStatus fromWire(String? v) => switch (v) {
    'active' => SubscriptionStatus.active,
    'paused' => SubscriptionStatus.paused,
    'cancelled' => SubscriptionStatus.cancelled,
    _ => SubscriptionStatus.none,
  };
}
