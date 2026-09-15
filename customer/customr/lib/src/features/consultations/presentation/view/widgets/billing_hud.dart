import 'package:flutter/material.dart';

import '../../../../../core/l10n/l10n.dart';
import '../../../../../core/theme/brand_colors.dart';
import '../../../data/models/consultation.dart';

/// Thin banner under the app bar during a live chat: money spent + minutes left.
/// When the balance is low it turns into a warning with an "Add money" action
/// ([onRecharge]) that opens the recharge sheet over the room.
class BillingHud extends StatelessWidget {
  const BillingHud({
    required this.consultation,
    required this.lowBalance,
    this.onRecharge,
    super.key,
  });

  final Consultation consultation;
  final bool lowBalance;
  final VoidCallback? onRecharge;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final brand = context.brand;
    final l10n = context.l10n;
    final runway = consultation.runwaySeconds;
    final mins = (runway / 60).floor();
    final warn = lowBalance || runway <= 120;

    return Material(
      color: warn ? brand.tint : scheme.surfaceContainerHighest,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 7, warn ? 6 : 16, 7),
        child: Row(
          children: [
            Icon(
              warn ? Icons.warning_amber_rounded : Icons.timer_outlined,
              size: 16,
              color: warn ? brand.onTint : scheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                warn
                    ? (runway <= 0
                          ? l10n.roomBalanceRunningOut
                          : l10n.roomMinLeftRecharge(mins))
                    : l10n.roomSpentMinLeft(
                        consultation.currency,
                        consultation.gross.toStringAsFixed(2),
                        mins,
                      ),
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: warn ? FontWeight.w700 : FontWeight.w500,
                  color: warn ? brand.onTint : scheme.onSurface,
                ),
              ),
            ),
            if (warn && onRecharge != null)
              TextButton(
                onPressed: onRecharge,
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  foregroundColor: brand.onTint,
                ),
                child: Text(l10n.roomAddMoney),
              )
            else
              Text(
                l10n.roomRatePerMinute(
                  consultation.currency,
                  consultation.ratePerMinute.toStringAsFixed(0),
                ),
                style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant),
              ),
          ],
        ),
      ),
    );
  }
}
