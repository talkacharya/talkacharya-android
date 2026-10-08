import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import 'package:talkacharya_ui/talkacharya_ui.dart';

/// The wizard's steps and the backend `onboarding_gaps` each one closes.
enum OnboardingStep {
  profile(['bio'], Icons.person_rounded, AstroPalette.career),
  expertise(
    ['skills', 'languages'],
    Icons.auto_awesome_rounded,
    AstroPalette.money,
  ),
  // Which documents are asked for is set in admin: every `kyc:` gap is this step's.
  identity(['kyc:'], Icons.verified_user_rounded, AstroPalette.health),
  bank(['bank_account'], Icons.account_balance_rounded, AstroPalette.air),
  review([], Icons.send_rounded, AstroPalette.love);

  const OnboardingStep(this.gaps, this.icon, this.hue);

  final List<String> gaps;
  final IconData icon;
  final AstroHue hue;

  /// Complete once none of its gaps remain (review is never "complete" here).
  bool isDone(List<String> remaining) =>
      this != review && !remaining.any(closes);

  /// Whether filling this step in is what closes [gap].
  bool closes(String gap) =>
      gaps.any((g) => g == gap || (g.endsWith(':') && gap.startsWith(g)));

  String title(AppLocalizations l) => switch (this) {
    profile => l.obStepProfile,
    expertise => l.obStepExpertise,
    identity => l.obStepIdentity,
    bank => l.obStepBank,
    review => l.obStepReview,
  };

  String subtitle(AppLocalizations l) => switch (this) {
    profile => l.obStepProfileSub,
    expertise => l.obStepExpertiseSub,
    identity => l.obStepIdentitySub,
    bank => l.obStepBankSub,
    review => l.obStepReviewSub,
  };

  /// First step with work left, else review.
  static OnboardingStep firstOpen(List<String> remaining) =>
      values.firstWhere((s) => s == review || !s.isDone(remaining));

  /// The step that closes [gap].
  static OnboardingStep forGap(String gap) =>
      values.firstWhere((s) => s.closes(gap), orElse: () => review);
}

/// Human label for a backend gap key.
String gapLabel(AppLocalizations l, String gap) => switch (gap) {
  'bio' => l.editBio,
  'skills' => l.editExpertise,
  'languages' => l.editLanguages,
  'kyc:pan' => l.kycPan,
  'kyc:photo' => l.kycPhoto,
  'kyc:aadhaar' => l.kycAadhaar,
  'kyc:bank_proof' => l.kycBankProof,
  'bank_account' => l.wizGapBank,
  _ => gap.startsWith('kyc:') ? l.kycOtherDocument : gap,
};
