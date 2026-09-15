import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/astro_palette.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/fade_slide_in.dart';
import '../../../../shared/widgets/skeleton.dart';
import '../../../wallet/data/wallet_api.dart';
import '../../data/models/order.dart';
import '../../data/models/product.dart';
import '../cubit/order_cubits.dart';
import '../cubit/store_payment.dart';
import '../widgets/order_widgets.dart';
import '../widgets/store_ui.dart';
import 'orders_page.dart' show BookingCard;

/// `/store/orders/:id` — what was bought, where it is, what to do next.
class OrderDetailPage extends StatelessWidget {
  const OrderDetailPage({this.justPlaced = false, super.key});

  /// Arrived straight from checkout — show the confirmation header.
  final bool justPlaced;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return BlocBuilder<OrderDetailCubit, OrderDetailState>(
      builder: (context, state) {
        final cubit = context.read<OrderDetailCubit>();
        final o = state.order.value;
        return Scaffold(
          backgroundColor: context.brand.canvas,
          appBar: AppBar(
            title: Text(
              o == null ? l.storeOrderTitle : l.storeOrderNumber(o.number),
            ),
            actions: const [CartButton()],
          ),
          body: state.order.isError && o == null
              ? ErrorView(message: state.order.error ?? '', onRetry: cubit.load)
              : o == null
              ? const _DetailSkeleton()
              : RefreshIndicator(
                  onRefresh: cubit.load,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
                    children: FadeSlideIn.list([
                      if (justPlaced && !o.awaitingPayment) ...[
                        _PlacedHeader(order: o),
                        const SizedBox(height: 14),
                      ],
                      if (o.awaitingPayment) ...[
                        _PayBanner(order: o, paying: state.paying),
                        const SizedBox(height: 14),
                      ],
                      _Overview(order: o),
                      const SizedBox(height: 14),
                      for (final s in o.subOrders) ...[
                        _SubOrderCard(order: o, sub: s, busy: state.busy),
                        const SizedBox(height: 12),
                      ],
                      if (o.addressLine.isNotEmpty) ...[
                        StoreSectionTitle(
                          l.storeDeliverTo,
                          hue: AstroPalette.money,
                        ),
                        StoreCard(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                color: AstroPalette.money.end,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if ('${o.shippingAddress['name'] ?? ''}'
                                        .isNotEmpty)
                                      Text(
                                        '${o.shippingAddress['name']}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w800,
                                            ),
                                      ),
                                    Text(
                                      o.addressLine,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                      ],
                      StoreSectionTitle(
                        l.storeBillDetails,
                        hue: AstroPalette.health,
                      ),
                      _Bill(order: o),
                      if (o.refunds.isNotEmpty) ...[
                        const SizedBox(height: 14),
                        StoreSectionTitle(
                          l.storeRefunds,
                          hue: AstroPalette.earth,
                        ),
                        for (final r in o.refunds) _RefundTile(refund: r),
                      ],
                      if (state.invoices.value?.isNotEmpty ?? false) ...[
                        const SizedBox(height: 14),
                        StoreSectionTitle(
                          l.storeInvoices,
                          hue: AstroPalette.career,
                        ),
                        for (final inv in state.invoices.value!)
                          _InvoiceTile(invoice: inv),
                      ],
                      if (o.awaitingPayment) ...[
                        const SizedBox(height: 18),
                        Center(
                          child: TextButton.icon(
                            style: TextButton.styleFrom(
                              foregroundColor: context.brand.live,
                            ),
                            onPressed: state.busy.contains(o.id)
                                ? null
                                : () => _cancelOrder(context, null),
                            icon: const Icon(Icons.cancel_outlined),
                            label: Text(l.storeCancelOrder),
                          ),
                        ),
                      ],
                    ]),
                  ),
                ),
        );
      },
    );
  }
}

Future<void> _cancelOrder(BuildContext context, SubOrder? sub) async {
  final l = context.l10n;
  final cubit = context.read<OrderDetailCubit>();
  final reason = await askReason(
    context,
    title: sub == null
        ? l.storeCancelOrderQ
        : l.storeCancelPartQ(sub.seller.name),
    hint: l.storeCancelReasonHint,
    confirmLabel: l.storeCancel,
  );
  if (reason == null || !context.mounted) return;
  final err = await cubit.cancel(
    reason.isEmpty ? 'customer_request' : reason,
    sub: sub,
  );
  if (!context.mounted) return;
  storeToast(context, err ?? l.storeCancelled);
}

class _PlacedHeader extends StatelessWidget {
  const _PlacedHeader({required this.order});
  final StoreOrder order;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final hasPooja = order.bookings.isNotEmpty;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(colors: BrandColors.goldGradient),
        boxShadow: context.brand.shadowWarm,
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              color: Color(0xFF3A1A00),
              size: 32,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.storeOrderPlacedTitle,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: const Color(0xFF3A1A00),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  hasPooja ? l.storeOrderPlacedPooja : l.storeOrderPlacedBody,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF3A1A00),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PayBanner extends StatelessWidget {
  const _PayBanner({required this.order, required this.paying});

  final StoreOrder order;
  final bool paying;

  Future<void> _pay(BuildContext context) async {
    final l = context.l10n;
    final outcome = await context.read<OrderDetailCubit>().payNow(
      storePayer(context),
    );
    if (!context.mounted || outcome == null) return;
    final msg = switch (outcome) {
      GatewayPaid() => l.storePaymentDone,
      GatewayConfirming() => l.storePaymentConfirming,
      GatewayCancelled() => l.storePaymentCancelled,
      GatewayFailed(:final message) =>
        message.isEmpty ? l.storePaymentFailed : message,
    };
    storeToast(context, msg);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final amount = order.payment?.amount ?? order.gatewayAmount;
    return StoreCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.timer_outlined, color: AstroPalette.money.end),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l.storePaymentPendingTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                ),
              ),
              if (order.expiresAt != null) _Countdown(until: order.expiresAt!),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            l.storePaymentPendingBody,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: context.brand.inkMuted,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 12),
          GoldButton(
            icon: Icons.lock_outline_rounded,
            label: l.storePayAmount(
              storeMoney(context, amount, order.currency),
            ),
            busy: paying,
            onPressed: () => _pay(context),
          ),
        ],
      ),
    );
  }
}

/// mm:ss until [until]; reloads the order when it runs out.
class _Countdown extends StatefulWidget {
  const _Countdown({required this.until});
  final DateTime until;

  @override
  State<_Countdown> createState() => _CountdownState();
}

class _CountdownState extends State<_Countdown> {
  Timer? _timer;
  Duration _left = Duration.zero;

  @override
  void initState() {
    super.initState();
    _tick();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    final left = widget.until.difference(DateTime.now());
    if (left.isNegative) {
      _timer?.cancel();
      if (_left > Duration.zero) {
        context.read<OrderDetailCubit>().load(silent: true);
      }
      setState(() => _left = Duration.zero);
      return;
    }
    setState(() => _left = left);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final m = _left.inMinutes.toString().padLeft(2, '0');
    final s = (_left.inSeconds % 60).toString().padLeft(2, '0');
    return StoreStatusChip(
      label: '$m:$s',
      tone: _left.inMinutes < 3 ? 'bad' : 'warn',
    );
  }
}

class _Overview extends StatelessWidget {
  const _Overview({required this.order});
  final StoreOrder order;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final (label, tone) = orderStatusStyle(context, order.status);
    return StoreCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.storeOrderNumber(order.number),
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  l.storePlacedOn(
                    storeDate(context, order.createdAt, withTime: true),
                  ),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: context.brand.inkMuted,
                  ),
                ),
              ],
            ),
          ),
          StoreStatusChip(label: label, tone: tone),
        ],
      ),
    );
  }
}

class _SubOrderCard extends StatelessWidget {
  const _SubOrderCard({
    required this.order,
    required this.sub,
    required this.busy,
  });

  final StoreOrder order;
  final SubOrder sub;
  final Set<String> busy;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    final s = sub;
    final (label, tone) = subOrderStyle(context, s.status);
    final paid = !order.awaitingPayment && !order.status.isClosed;
    return StoreCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.storefront_rounded,
                size: 18,
                color: AstroPalette.money.end,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  l.storeSoldBy(s.seller.name),
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              if (paid) StoreStatusChip(label: label, tone: tone),
            ],
          ),
          if (paid &&
              s.hasGoods &&
              s.status != SubOrderStage.cancelled &&
              s.status != SubOrderStage.returned) ...[
            const SizedBox(height: 14),
            _Stepper(stage: s.status),
          ],
          if (s.shipment != null) ...[
            const SizedBox(height: 12),
            _ShipmentBox(shipment: s.shipment!),
          ],
          const Divider(height: 22),
          for (final line in s.lines)
            _LineTile(order: order, line: line, busy: busy),
          if (s.canCancel && !order.awaitingPayment)
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton(
                style: TextButton.styleFrom(foregroundColor: brand.live),
                onPressed: busy.contains(s.id)
                    ? null
                    : () => _cancelOrder(context, s),
                child: Text(l.storeCancelThisPart),
              ),
            ),
        ],
      ),
    );
  }
}

class _Stepper extends StatelessWidget {
  const _Stepper({required this.stage});
  final String stage;

  @override
  Widget build(BuildContext context) {
    const steps = SubOrderStage.goodsSteps;
    final reached = stage == SubOrderStage.completed
        ? steps.length - 1
        : steps.indexOf(stage);
    final brand = context.brand;
    final done = AstroPalette.health.end;
    return Row(
      children: [
        for (var i = 0; i < steps.length; i++) ...[
          if (i > 0)
            Expanded(
              child: Container(
                height: 3,
                margin: const EdgeInsets.only(bottom: 18),
                color: i <= reached ? done : brand.hairline,
              ),
            ),
          Column(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: i <= reached ? done : Colors.transparent,
                  border: Border.all(
                    color: i <= reached ? done : brand.hairline,
                    width: 2,
                  ),
                ),
                child: i <= reached
                    ? const Icon(
                        Icons.check_rounded,
                        size: 14,
                        color: Colors.white,
                      )
                    : null,
              ),
              const SizedBox(height: 4),
              Text(
                subOrderStyle(context, steps[i]).$1,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontSize: 10,
                  fontWeight: i == reached ? FontWeight.w800 : FontWeight.w500,
                  color: i <= reached ? null : brand.inkMuted,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _ShipmentBox extends StatelessWidget {
  const _ShipmentBox({required this.shipment});
  final Shipment shipment;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    final sh = shipment;
    final last = sh.events.isEmpty ? null : sh.events.first;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: (sh.hasIssue ? brand.live : AstroPalette.career.end).withValues(
          alpha: 0.06,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(
            Icons.local_shipping_rounded,
            color: sh.hasIssue ? brand.live : AstroPalette.career.end,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  shipmentLabel(context, sh.status),
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (sh.courierName.isNotEmpty || sh.awb.isNotEmpty)
                  Text(
                    [
                      sh.courierName,
                      if (sh.awb.isNotEmpty) l.storeAwb(sh.awb),
                    ].where((x) => x.isNotEmpty).join(' · '),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: brand.inkMuted,
                    ),
                  ),
                if (last != null)
                  Text(
                    [
                      last.location,
                      storeDate(context, last.at, withTime: true),
                    ].where((x) => x.isNotEmpty).join(' · '),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: brand.inkMuted,
                    ),
                  ),
              ],
            ),
          ),
          if (sh.trackingUrl != null)
            TextButton(
              onPressed: () => launchUrl(
                Uri.parse(sh.trackingUrl!),
                mode: LaunchMode.externalApplication,
              ),
              child: Text(l.storeTrack),
            ),
        ],
      ),
    );
  }
}

class _LineTile extends StatelessWidget {
  const _LineTile({
    required this.order,
    required this.line,
    required this.busy,
  });

  final StoreOrder order;
  final OrderLine line;
  final Set<String> busy;

  Future<void> _download(BuildContext context, String accessId) async {
    final l = context.l10n;
    try {
      final url = await context.read<OrderDetailCubit>().downloadUrl(accessId);
      if (url == null) throw StateError('no url');
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (_) {
      if (context.mounted) storeToast(context, l.storeDownloadFailed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    final ln = line;
    final booking = ln.booking;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: InkWell(
                  onTap: ln.productSlug.isEmpty
                      ? null
                      : () => context.push(Routes.storeProduct(ln.productSlug)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ln.productTitle,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          decoration: ln.isActive
                              ? null
                              : TextDecoration.lineThrough,
                        ),
                      ),
                      Text(
                        [
                          if (ln.variantName.isNotEmpty) ln.variantName,
                          l.storeQty(ln.quantity),
                        ].join(' · '),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: brand.inkMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    storeMoney(context, ln.lineTotal, order.currency),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (!ln.isActive)
                    StoreStatusChip(
                      label: ln.status == 'returned'
                          ? l.storeStageReturned
                          : l.storeStageCancelled,
                      tone: 'neutral',
                    ),
                ],
              ),
            ],
          ),
          if (ln.refundedAmount > 0)
            Text(
              l.storeRefundedAmount(
                storeMoney(context, ln.refundedAmount, order.currency),
              ),
              style: theme.textTheme.labelSmall?.copyWith(
                color: brand.online,
                fontWeight: FontWeight.w700,
              ),
            ),
          if (booking != null) ...[
            const SizedBox(height: 8),
            BookingCard(booking: booking, showTitle: false),
            if (booking.proofs.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final p in booking.proofs)
                    ActionChip(
                      avatar: Icon(
                        p.isVideo
                            ? Icons.play_circle_fill_rounded
                            : Icons.image_rounded,
                        size: 18,
                      ),
                      label: Text(
                        p.caption.isEmpty ? l.storeWatchPooja : p.caption,
                      ),
                      onPressed: () => launchUrl(
                        Uri.parse(p.url),
                        mode: LaunchMode.externalApplication,
                      ),
                    ),
                ],
              ),
            ],
          ],
          if (ln.downloads.isNotEmpty && !order.awaitingPayment) ...[
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final d in ln.downloads)
                  ActionChip(
                    avatar: busy.contains(d.id)
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.download_rounded, size: 18),
                    label: Text(d.title.isEmpty ? l.storeDownload : d.title),
                    onPressed: busy.contains(d.id)
                        ? null
                        : () => _download(context, d.id),
                  ),
              ],
            ),
          ],
          if (ln.canReturn && ln.fulfilment == Fulfilment.physical)
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton.icon(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                ),
                onPressed: () async {
                  final cubit = context.read<OrderDetailCubit>();
                  final ok = await context.push<bool>(
                    Routes.storeReturn(order.id, ln.id),
                    extra: ln,
                  );
                  if (ok ?? false) await cubit.load(silent: true);
                },
                icon: const Icon(Icons.assignment_return_outlined, size: 18),
                label: Text(
                  ln.returnableUntil == null
                      ? l.storeReturnItem
                      : l.storeReturnUntil(
                          storeDate(context, ln.returnableUntil),
                        ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Bill extends StatelessWidget {
  const _Bill({required this.order});
  final StoreOrder order;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final o = order;
    return StoreCard(
      child: Column(
        children: [
          BillRow(
            label: l.storeSubtotal,
            amount: o.subtotal,
            currency: o.currency,
          ),
          BillRow(
            label: l.storeShipping,
            amount: o.shippingTotal,
            currency: o.currency,
            valueText: o.shippingTotal <= 0 ? l.storeFree : null,
          ),
          const Divider(height: 18),
          BillRow(
            label: l.storeGrandTotal,
            amount: o.grandTotal,
            currency: o.currency,
            strong: true,
          ),
          if (o.taxTotal > 0)
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Text(
                l.storeTaxIncluded(storeMoney(context, o.taxTotal, o.currency)),
                style: Theme.of(
                  context,
                ).textTheme.labelSmall?.copyWith(color: context.brand.inkMuted),
              ),
            ),
          if (o.walletAmount > 0 || o.gatewayAmount > 0)
            const Divider(height: 18),
          if (o.walletAmount > 0)
            BillRow(
              label: l.storePaidFromWallet,
              amount: o.walletAmount,
              currency: o.currency,
            ),
          if (o.gatewayAmount > 0)
            BillRow(
              label: l.storePaidOnline,
              amount: o.gatewayAmount,
              currency: o.currency,
            ),
          if (o.refundedTotal > 0)
            BillRow(
              label: l.storeRefunded,
              amount: o.refundedTotal,
              currency: o.currency,
              negative: true,
            ),
        ],
      ),
    );
  }
}

class _RefundTile extends StatelessWidget {
  const _RefundTile({required this.refund});
  final StoreRefund refund;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final r = refund;
    final toWallet = r.amount - r.toSourceAmount;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: StoreCard(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(Icons.currency_exchange_rounded, color: context.brand.online),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    storeMoney(context, r.amount, r.currency),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    [
                      if (toWallet > 0)
                        l.storeRefundToWallet(
                          storeMoney(context, toWallet, r.currency),
                        ),
                      if (r.toSourceAmount > 0)
                        l.storeRefundToSource(
                          storeMoney(context, r.toSourceAmount, r.currency),
                        ),
                      storeDate(context, r.createdAt),
                    ].where((s) => s.isNotEmpty).join(' · '),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: context.brand.inkMuted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InvoiceTile extends StatefulWidget {
  const _InvoiceTile({required this.invoice});
  final StoreInvoice invoice;

  @override
  State<_InvoiceTile> createState() => _InvoiceTileState();
}

class _InvoiceTileState extends State<_InvoiceTile> {
  bool _busy = false;

  Future<void> _open() async {
    final l = context.l10n;
    final inv = widget.invoice;
    setState(() => _busy = true);
    try {
      final bytes = await getIt<WalletApi>().invoicePdf(inv.id);
      await Share.shareXFiles([
        XFile.fromData(
          Uint8List.fromList(bytes),
          mimeType: 'application/pdf',
          name:
              '${inv.isCreditNote ? 'credit-note' : 'invoice'}-${inv.number}.pdf',
        ),
      ]);
    } catch (_) {
      if (mounted) storeToast(context, l.storeDownloadFailed);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final inv = widget.invoice;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: StoreCard(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(
            inv.isCreditNote
                ? Icons.receipt_outlined
                : Icons.receipt_long_rounded,
          ),
          title: Text(
            inv.isCreditNote
                ? l.storeCreditNote(inv.number)
                : l.storeTaxInvoice(inv.number),
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          subtitle: Text(
            '${storeMoney(context, inv.totalAmount, inv.currency)} · ${storeDate(context, inv.issuedAt)}',
          ),
          trailing: _busy
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.ios_share_rounded),
          onTap: _busy ? null : _open,
        ),
      ),
    );
  }
}

class _DetailSkeleton extends StatelessWidget {
  const _DetailSkeleton();

  @override
  Widget build(BuildContext context) => AppShimmer(
    child: ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        SkeletonBox(height: 70, radius: 18),
        SizedBox(height: 14),
        SkeletonBox(height: 220, radius: 18),
        SizedBox(height: 14),
        SkeletonBox(height: 140, radius: 18),
      ],
    ),
  );
}
