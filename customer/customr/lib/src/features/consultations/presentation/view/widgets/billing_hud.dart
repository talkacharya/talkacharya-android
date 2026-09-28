import 'dart:async';

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
    this.awaitingPaymentUntil,
    this.onRecharge,
    super.key,
  });

  final Consultation consultation;
  final bool lowBalance;

  /// Set while the consultation is being held open for a payment in flight.
  final DateTime? awaitingPaymentUntil;
  final VoidCallback? onRecharge;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final brand = context.brand;
    final l10n = context.l10n;
    final runway = consultation.runwaySeconds;
    final mins = (runway / 60).floor();
    final warn = lowBalance || runway <= 180;

    if (awaitingPaymentUntil != null) {
      return _HeldForPayment(until: awaitingPaymentUntil!);
    }

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
                          // Under two minutes, whole minutes stop being
                          // useful: "1 min left" held for sixty seconds tells
                          // nobody how long they really have.
                          : runway < 120
                          ? l10n.roomTimeLeftRecharge(
                              '${(runway ~/ 60).toString().padLeft(2, '0')}:'
                              '${(runway % 60).toString().padLeft(2, '0')}',
                            )
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

/// The consultation is out of money but still connected, because a payment is
/// on its way. It counts down so the customer knows this is not forever, and
/// it deliberately does not look like an error: nothing has gone wrong yet.
class _HeldForPayment extends StatefulWidget {
  const _HeldForPayment({required this.until});
  final DateTime until;

  @override
  State<_HeldForPayment> createState() => _HeldForPaymentState();
}

class _HeldForPaymentState extends State<_HeldForPayment> {
  Timer? _tick;

  @override
  void initState() {
    super.initState();
    _tick = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tick?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final left = widget.until.difference(DateTime.now());
    final seconds = left.isNegative ? 0 : left.inSeconds;
    return Material(
      color: scheme.tertiaryContainer,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 7, 16, 7),
        child: Row(
          children: [
            SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: scheme.onTertiaryContainer,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                l10n.roomHeldForPayment(
                  '${(seconds ~/ 60).toString().padLeft(2, '0')}:'
                  '${(seconds % 60).toString().padLeft(2, '0')}',
                ),
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: scheme.onTertiaryContainer,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
