import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../auth/presentation/bloc/auth/auth_bloc.dart';
import '../../data/models/order.dart';
import '../cubit/store_payment.dart';
import 'store_ui.dart';

/// Payer details for the Razorpay sheet, from the signed-in customer.
PayerInfo storePayer(BuildContext context) {
  final user = context.read<AuthBloc>().state.user;
  final l = context.l10n;
  return (
    appName: l.appName,
    description: l.storePayDescription,
    contact: user?.phone,
    email: user?.email.isNotEmpty == true ? user?.email : null,
  );
}

/// (label, tone) for an order's overall status.
(String, String) orderStatusStyle(BuildContext context, OrderStatus s) {
  final l = context.l10n;
  return switch (s) {
    OrderStatus.pendingPayment => (l.storeOrderPendingPayment, 'warn'),
    OrderStatus.paid => (l.storeOrderPaid, 'info'),
    OrderStatus.completed => (l.storeOrderCompleted, 'good'),
    OrderStatus.cancelled => (l.storeOrderCancelled, 'bad'),
    OrderStatus.expired => (l.storeOrderExpired, 'neutral'),
    OrderStatus.refunded => (l.storeOrderRefunded, 'neutral'),
  };
}

/// (label, tone) for a seller's part of the order.
(String, String) subOrderStyle(BuildContext context, String stage) {
  final l = context.l10n;
  return switch (stage) {
    SubOrderStage.pending => (l.storeStagePending, 'warn'),
    SubOrderStage.awaitingApproval => (l.storeStageAwaitingApproval, 'warn'),
    SubOrderStage.confirmed => (l.storeStageConfirmed, 'info'),
    SubOrderStage.processing => (l.storeStageProcessing, 'info'),
    SubOrderStage.shipped => (l.storeStageShipped, 'info'),
    SubOrderStage.delivered => (l.storeStageDelivered, 'good'),
    SubOrderStage.completed => (l.storeStageCompleted, 'good'),
    SubOrderStage.cancelled => (l.storeStageCancelled, 'bad'),
    SubOrderStage.returned => (l.storeStageReturned, 'neutral'),
    _ => (stage.replaceAll('_', ' '), 'neutral'),
  };
}

(String, String) bookingStyle(BuildContext context, String status) {
  final l = context.l10n;
  return switch (status) {
    'pending' => (l.storeStagePending, 'warn'),
    'confirmed' => (l.storeBookingConfirmed, 'info'),
    'performed' => (l.storeBookingPerformed, 'good'),
    'proof_uploaded' => (l.storeBookingProofReady, 'good'),
    'completed' => (l.storeStageCompleted, 'good'),
    'cancelled' => (l.storeStageCancelled, 'bad'),
    _ => (status.replaceAll('_', ' '), 'neutral'),
  };
}

String shipmentLabel(BuildContext context, String status) {
  final l = context.l10n;
  return switch (status) {
    'created' => l.storeShipCreated,
    'picked_up' => l.storeShipPickedUp,
    'in_transit' => l.storeShipInTransit,
    'out_for_delivery' => l.storeShipOutForDelivery,
    'delivered' => l.storeStageDelivered,
    'ndr' => l.storeShipAttemptFailed,
    'rto' => l.storeShipReturning,
    'lost' => l.storeShipLost,
    _ => status.replaceAll('_', ' '),
  };
}

String returnReasonLabel(BuildContext context, String reason) {
  final l = context.l10n;
  return switch (reason) {
    'damaged' => l.storeReasonDamaged,
    'wrong_item' => l.storeReasonWrongItem,
    'not_as_described' => l.storeReasonNotAsDescribed,
    'authenticity_concern' => l.storeReasonAuthenticity,
    'size_issue' => l.storeReasonSize,
    'changed_mind' => l.storeReasonChangedMind,
    _ => l.storeReasonOther,
  };
}

/// "Label ........ ₹123" row for bill summaries.
class BillRow extends StatelessWidget {
  const BillRow({
    required this.label,
    required this.amount,
    this.currency,
    this.strong = false,
    this.negative = false,
    this.valueText,
    super.key,
  });

  final String label;
  final double amount;
  final String? currency;
  final bool strong;
  final bool negative;

  /// Overrides the formatted amount (e.g. "Free").
  final String? valueText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = strong
        ? theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)
        : theme.textTheme.bodyMedium?.copyWith(color: context.brand.inkMuted);
    final value =
        valueText ??
        '${negative ? '− ' : ''}${storeMoney(context, amount, currency)}';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(child: Text(label, style: style)),
          Text(
            value,
            style: style?.copyWith(
              color: negative
                  ? context.brand.online
                  : (strong ? null : theme.colorScheme.onSurface),
              fontWeight: strong ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Warning / info banner (quote problems, payment pending, delivery issues).
class StoreNotice extends StatelessWidget {
  const StoreNotice({
    required this.message,
    this.icon = Icons.info_outline_rounded,
    this.tone = 'warn',
    this.action,
    super.key,
  });

  final String message;
  final IconData icon;

  /// warn | bad | info | good
  final String tone;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final color = switch (tone) {
      'bad' => brand.live,
      'good' => brand.online,
      'info' => Theme.of(context).colorScheme.primary,
      _ => const Color(0xFFB7791F),
    };
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.28)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w700,
                height: 1.35,
              ),
            ),
          ),
          ?action,
        ],
      ),
    );
  }
}

/// Asks for a free-text reason (cancel). Returns null when dismissed.
Future<String?> askReason(
  BuildContext context, {
  required String title,
  required String hint,
  required String confirmLabel,
}) {
  final controller = TextEditingController();
  return showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: TextField(
        controller: controller,
        autofocus: true,
        maxLines: 3,
        maxLength: 300,
        decoration: InputDecoration(hintText: hint),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: Text(ctx.l10n.storeKeep),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: ctx.brand.live),
          onPressed: () => Navigator.of(ctx).pop(controller.text.trim()),
          child: Text(confirmLabel),
        ),
      ],
    ),
  ).whenComplete(controller.dispose);
}

void storeToast(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(behavior: SnackBarBehavior.floating, content: Text(message)),
    );
}
