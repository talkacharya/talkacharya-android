import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/l10n/l10n.dart';
import '../../../../../core/theme/brand_colors.dart';
import '../../../../../core/util/money.dart';
import '../../../data/models/wallet_transaction.dart';

class TransactionTile extends StatelessWidget {
  const TransactionTile({required this.txn, this.onTap, super.key});

  final WalletTransaction txn;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = context.brand;
    final l = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final credit = txn.isCredit;
    final (icon, tint) = _iconFor(txn.kind, brand);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: tint.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 18, color: tint),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    txn.reason.isNotEmpty ? txn.reason : _label(l, txn),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _when(context, txn.createdAt),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  Money.signed(txn.signedAmount, txn.currency, locale: locale),
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: credit
                        ? const Color(0xFF2E7D46)
                        : const Color(0xFFC7442E),
                  ),
                ),
                Text(
                  l.walletBalanceAfter(
                    Money.format(
                      txn.balanceAfter,
                      txn.currency,
                      locale: locale,
                    ),
                  ),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _label(AppLocalizations l, WalletTransaction t) {
    return switch (t.kind) {
      'recharge' => l.kindRecharge,
      'consultation_charge' => l.kindConsultationCharge,
      'consultation_refund' => l.kindConsultationRefund,
      'promo_credit' => l.kindPromoCredit,
      'coupon_discount' => l.kindCouponDiscount,
      'signup_bonus' => l.kindSignupBonus,
      'referral_bonus' => l.kindReferralBonus,
      'adjustment_credit' || 'adjustment_debit' => l.kindAdjustment,
      'gift_spend' => l.kindGiftSpend,
      'hold_capture' || 'hold_release' => l.kindHold,
      'chargeback' => l.kindChargeback,
      _ => t.kindLabel,
    };
  }

  (IconData, Color) _iconFor(String kind, BrandColors brand) {
    return switch (kind) {
      'recharge' => (Icons.south_rounded, const Color(0xFF2E7D46)),
      'consultation_charge' ||
      'hold_capture' => (Icons.chat_bubble_rounded, const Color(0xFFC7442E)),
      'consultation_refund' ||
      'hold_release' ||
      'chargeback' => (Icons.replay_rounded, const Color(0xFF2E7D46)),
      'promo_credit' ||
      'coupon_discount' ||
      'signup_bonus' ||
      'referral_bonus' => (Icons.card_giftcard_rounded, brand.onTint),
      'gift_spend' => (
        Icons.volunteer_activism_rounded,
        const Color(0xFFC7442E),
      ),
      _ => (Icons.tune_rounded, brand.onTint),
    };
  }

  String _when(BuildContext context, DateTime? dt) {
    if (dt == null) return '';
    final l = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final now = DateTime.now();
    final day = DateTime(dt.year, dt.month, dt.day);
    final todayDay = DateTime(now.year, now.month, now.day);
    final time = DateFormat.jm(locale).format(dt);
    if (day == todayDay) return '${l.commonToday}, $time';
    if (day == todayDay.subtract(const Duration(days: 1))) {
      return '${l.commonYesterday}, $time';
    }
    return DateFormat.MMMd(locale).format(dt);
  }
}
