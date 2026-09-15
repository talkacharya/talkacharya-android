import 'package:flutter/material.dart' show IconData, Icons;

import '../models/prediction_enums.dart';

/// English fallback labels for the predictions UI (like `KundaliInsights`). The
/// customer app localises `title` / `blurb` / status via ARB; these are the base.
class PredictionLabels {
  const PredictionLabels._();

  static const areaOrder = <PredictionArea>[
    PredictionArea.career,
    PredictionArea.marriageLove,
    PredictionArea.finance,
    PredictionArea.health,
    PredictionArea.education,
    PredictionArea.general,
  ];

  static String areaTitle(PredictionArea a) => switch (a) {
    PredictionArea.career => 'Career & work',
    PredictionArea.marriageLove => 'Marriage & love',
    PredictionArea.finance => 'Money & finance',
    PredictionArea.health => 'Health & energy',
    PredictionArea.education => 'Study & learning',
    PredictionArea.general => 'Life overview',
  };

  static String areaBlurb(PredictionArea a) => switch (a) {
    PredictionArea.career => 'Direction, changes, recognition and timing at work.',
    PredictionArea.marriageLove => 'Relationships, commitment and the road ahead.',
    PredictionArea.finance => 'Earning, saving, investments and money flow.',
    PredictionArea.health => 'Vitality, stress and what to look after.',
    PredictionArea.education => 'Focus, exams, admissions and results.',
    PredictionArea.general => 'The main themes across every area of life.',
  };

  static IconData areaIcon(PredictionArea a) => switch (a) {
    PredictionArea.career => Icons.work_outline_rounded,
    PredictionArea.marriageLove => Icons.favorite_outline_rounded,
    PredictionArea.finance => Icons.savings_outlined,
    PredictionArea.health => Icons.monitor_heart_outlined,
    PredictionArea.education => Icons.school_outlined,
    PredictionArea.general => Icons.auto_awesome_outlined,
  };

  static String periodTitle(PredictionPeriod p) => switch (p) {
    PredictionPeriod.month => 'The month ahead',
    PredictionPeriod.quarter => 'The next 3 months',
    PredictionPeriod.year => 'The year ahead',
  };

  static String statusLabel(PredictionStatus s) => switch (s) {
    PredictionStatus.requested => 'Requested',
    PredictionStatus.drafting => 'Being written',
    PredictionStatus.inReview => 'In review',
    PredictionStatus.delivered => 'Ready to read',
    PredictionStatus.rejected => 'Not available',
    PredictionStatus.refunded => 'Refunded',
  };

  /// A colour role for the status chip — the app maps it to its palette.
  /// `pending` | `done` | `warn`.
  static String statusRole(PredictionStatus s) => switch (s) {
    PredictionStatus.delivered => 'done',
    PredictionStatus.rejected || PredictionStatus.refunded => 'warn',
    _ => 'pending',
  };
}
