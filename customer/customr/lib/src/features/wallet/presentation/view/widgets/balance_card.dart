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
              amount: b.available,
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
                  child: Text(
                    l.walletOnHoldReason(
                      Money.format(b.held, b.currency, locale: locale),
                    ),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: const Color(0xFFE7C7B2),
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
