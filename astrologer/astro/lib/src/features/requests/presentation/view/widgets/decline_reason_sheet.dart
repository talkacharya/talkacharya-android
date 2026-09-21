import 'package:flutter/material.dart';

import '../../../../../core/l10n/l10n.dart';
import '../../../../../core/theme/brand_colors.dart';

/// Asks why a request is being declined. Returns the reason code sent to
/// `POST /astro/consultations/{id}/reject`, or `null` if dismissed.
Future<String?> showDeclineReasonSheet(BuildContext context) {
  return showModalBottomSheet<String>(
    context: context,
    showDragHandle: true,
    builder: (context) {
      final l = context.l10n;
      final brand = context.brand;
      final reasons = [
        ('busy', Icons.hourglass_top_rounded, l.requestsDeclineBusy),
        ('unavailable', Icons.event_busy_rounded, l.requestsDeclineUnavailable),
        (
          'outside_expertise',
          Icons.psychology_alt_rounded,
          l.requestsDeclineExpertise,
        ),
      ];
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Text(
                  l.requestsDeclineTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              for (final (code, icon, label) in reasons)
                ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  leading: Icon(icon, color: brand.inkMuted),
                  title: Text(label),
                  onTap: () => Navigator.of(context).pop(code),
                ),
            ],
          ),
        ),
      );
    },
  );
}
