import 'package:flutter/material.dart';

import '../../../../../core/l10n/l10n.dart';
import '../../../../../core/util/money.dart';
import '../../../data/models/wallet_balance.dart';
import 'count_up_text.dart';

/// The wallet hero — a warm gradient card showing the spendable balance, with a
/// quiet "on hold" line while a call is running.
class BalanceCard extends StatelessWidget {
  const BalanceCard({required this.balance, required this.loading, super.key});

  final WalletBalance? balance;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = context.l10n;
    final b = balance;
    final locale = Localizations.localeOf(context).toLanguageTag();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const RadialGradient(
          center: Alignment.topLeft,
          radius: 1.4,
          colors: [Color(0xFF7E2C0C), Color(0xFF2A1206)],
          stops: [0.0, 0.7],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2A1206).withValues(alpha: 0.28),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l.walletAvailableBalance,
            style: theme.textTheme.labelMedium?.copyWith(
              color: const Color(0xFFE7C7B2),
            ),
          ),
          const SizedBox(height: 6),
          if (b == null)
            _Skeleton(loading: loading)
          else
            CountUpText(
              amount: b.spendable,
              currency: b.currency,
              style: theme.textTheme.displaySmall?.copyWith(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.w600,
                height: 1.05,
              ),
            ),
          const SizedBox(height: 8),
          Row(
            children: [
              if (b != null && b.hasHold)
                Expanded(
                  // Balance and hold together, so the headline figure adds up in
                  // front of the customer instead of looking like money missing.
                  child: _HoldLine(
                    text: l.walletHeldBreakdown(
                      Money.format(b.cached, b.currency, locale: locale),
                      Money.format(b.held, b.currency, locale: locale),
                    ),
                  ),
                )
              else
                const Spacer(),
              Text(
                b?.currency ?? '',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: const Color(0xFFC79A80),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// The breakdown under the headline. Tapping it says what a hold is — the
/// question every customer asks the first time they see one.
class _HoldLine extends StatelessWidget {
  const _HoldLine({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = context.l10n;
    return InkWell(
      onTap: () => showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l.walletHeldExplainerTitle),
          content: Text(l.walletHeldExplainerBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l.commonOk),
            ),
          ],
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              text,
              style: theme.textTheme.labelSmall?.copyWith(
                color: const Color(0xFFE7C7B2),
              ),
            ),
          ),
          const SizedBox(width: 4),
          const Icon(
            Icons.info_outline_rounded,
            size: 13,
            color: Color(0xFFC79A80),
          ),
        ],
      ),
    );
  }
}

class _Skeleton extends StatelessWidget {
  const _Skeleton({required this.loading});
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: loading ? 1 : 0.4,
      duration: const Duration(milliseconds: 400),
      child: Container(
        width: 150,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
