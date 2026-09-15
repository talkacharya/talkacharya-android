import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/astro_palette.dart';
import '../../data/models/dispute.dart';

/// Labels, icons and colours for reports — one place so the hub, the form and
/// the detail page always describe a report the same way.
extension DisputeTypeUi on DisputeType {
  String label(AppLocalizations l) => switch (this) {
    DisputeType.billing => l.reportTypeBilling,
    DisputeType.quality => l.reportTypeQuality,
    DisputeType.conduct => l.reportTypeConduct,
    DisputeType.noShow => l.reportTypeNoShow,
    DisputeType.technical => l.reportTypeTechnical,
  };

  String hint(AppLocalizations l) => switch (this) {
    DisputeType.billing => l.reportTypeBillingHint,
    DisputeType.quality => l.reportTypeQualityHint,
    DisputeType.conduct => l.reportTypeConductHint,
    DisputeType.noShow => l.reportTypeNoShowHint,
    DisputeType.technical => l.reportTypeTechnicalHint,
  };

  IconData get icon => switch (this) {
    DisputeType.billing => Icons.receipt_long_rounded,
    DisputeType.quality => Icons.sentiment_dissatisfied_rounded,
    DisputeType.conduct => Icons.report_gmailerrorred_rounded,
    DisputeType.noShow => Icons.person_off_rounded,
    DisputeType.technical => Icons.wifi_off_rounded,
  };

  AstroHue get hue => switch (this) {
    DisputeType.billing => AstroPalette.money,
    DisputeType.quality => AstroPalette.career,
    DisputeType.conduct => AstroPalette.love,
    DisputeType.noShow => AstroPalette.fire,
    DisputeType.technical => AstroPalette.air,
  };
}

extension DisputeStatusUi on DisputeStatus {
  String label(AppLocalizations l) => switch (this) {
    DisputeStatus.open => l.disputeStatusOpen,
    DisputeStatus.investigating => l.disputeStatusInvestigating,
    DisputeStatus.resolved => l.disputeStatusResolved,
    DisputeStatus.rejected => l.disputeStatusRejected,
  };

  String headline(AppLocalizations l) => switch (this) {
    DisputeStatus.open => l.disputeHeadlineOpen,
    DisputeStatus.investigating => l.disputeHeadlineInvestigating,
    DisputeStatus.resolved => l.disputeHeadlineResolved,
    DisputeStatus.rejected => l.disputeHeadlineRejected,
  };

  IconData get icon => switch (this) {
    DisputeStatus.open => Icons.mark_email_read_rounded,
    DisputeStatus.investigating => Icons.manage_search_rounded,
    DisputeStatus.resolved => Icons.verified_rounded,
    DisputeStatus.rejected => Icons.task_alt_rounded,
  };

  AstroHue get hue => switch (this) {
    DisputeStatus.open => AstroPalette.money,
    DisputeStatus.investigating => AstroPalette.career,
    DisputeStatus.resolved => AstroPalette.health,
    DisputeStatus.rejected => AstroPalette.air,
  };
}

String disputeStepLabel(AppLocalizations l, String type) => switch (type) {
  'raised' => l.disputeStepRaised,
  'reviewing' => l.disputeStepReviewing,
  'resolved' => l.disputeStepResolved,
  'rejected' => l.disputeStepRejected,
  _ => type,
};

/// "12 Sep 2026" / "12 Sep, 4:30 pm" in the app locale.
String disputeDate(BuildContext context, DateTime? at, {bool time = false}) {
  if (at == null) return '';
  final locale = Localizations.localeOf(context).toLanguageTag();
  final local = at.toLocal();
  return time
      ? DateFormat('d MMM, h:mm a', locale).format(local)
      : DateFormat('d MMM yyyy', locale).format(local);
}

/// Small rounded status pill.
class DisputeStatusChip extends StatelessWidget {
  const DisputeStatusChip({required this.status, super.key});

  final DisputeStatus status;

  @override
  Widget build(BuildContext context) {
    final hue = status.hue;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: hue.tint(0.13),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status.label(context.l10n),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: hue.end,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
