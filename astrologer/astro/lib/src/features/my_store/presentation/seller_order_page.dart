import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:talkacharya_ui/talkacharya_ui.dart';

import '../../../core/di/service_locator.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/network/friendly_error.dart';
import '../../../core/util/money.dart';
import '../../../core/util/time_format.dart';
import '../../../shared/widgets/settings_widgets.dart';
import '../data/my_store_api.dart';
import '../data/my_store_models.dart';
import 'my_store_widgets.dart';

/// `/my-store/orders/:id` — one order for the astrologer's store: what was
/// bought (with what the customer filled in), where it goes, and the next
/// step — start preparing, mark it shipped with the courier's tracking, or
/// cancel with a reason.
class SellerOrderPage extends StatefulWidget {
  const SellerOrderPage({required this.orderId, super.key});

  final String orderId;

  @override
  State<SellerOrderPage> createState() => _SellerOrderPageState();
}

class _SellerOrderPageState extends State<SellerOrderPage> {
  final _api = getIt<MyStoreApi>();
  SellerOrder? _order;
  String? _error;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final order = await _api.order(widget.orderId);
      if (mounted) {
        setState(() {
          _order = order;
          _error = null;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _error = friendlyError(e));
    }
  }

  Future<void> _act(
    String action, [
    Map<String, dynamic> data = const {},
  ]) async {
    setState(() => _busy = true);
    try {
      final order = await _api.orderAction(widget.orderId, action, data: data);
      if (mounted) setState(() => _order = order);
    } catch (e) {
      if (mounted) showToast(context, friendlyError(e));
    }
    if (mounted) setState(() => _busy = false);
  }

  Future<void> _ship() async {
    final l = context.l10n;
    final courier = TextEditingController();
    final awb = TextEditingController();
    final url = TextEditingController();
    final ok = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheet) => Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          0,
          16,
          16 + MediaQuery.viewInsetsOf(sheet).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l.msShipTitle,
              style: Theme.of(
                sheet,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            Text(l.msShipHint, style: Theme.of(sheet).textTheme.bodySmall),
            TextField(
              controller: courier,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(labelText: l.msCourier),
            ),
            TextField(
              controller: awb,
              decoration: InputDecoration(labelText: l.msAwb),
            ),
            TextField(
              controller: url,
              keyboardType: TextInputType.url,
              decoration: InputDecoration(labelText: l.msTrackingLink),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => Navigator.pop(sheet, true),
              child: Text(l.msMarkShipped),
            ),
          ],
        ),
      ),
    );
    if (ok == true) {
      await _act('ship', {
        'courier_name': courier.text.trim(),
        'awb': awb.text.trim(),
        'tracking_url': url.text.trim(),
      });
    }
    courier.dispose();
    awb.dispose();
    url.dispose();
  }

  Future<void> _cancel() async {
    final l = context.l10n;
    final reason = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (d) => AlertDialog(
        title: Text(l.msCancelOrderTitle),
        content: TextField(
          controller: reason,
          maxLength: 240,
          decoration: InputDecoration(labelText: l.msCancelReason),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(d, false),
            child: Text(l.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(d, true),
            child: Text(l.msCancelOrder),
          ),
        ],
      ),
    );
    final text = reason.text.trim();
    reason.dispose();
    if (ok == true && text.isNotEmpty) await _act('cancel', {'reason': text});
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    final o = _order;
    return SubPageScaffold(
      title: o == null ? l.msOrder : l.msOrderNumber(o.number),
      onRefresh: _load,
      bottomBar: o == null || !(o.canStart || o.canShip)
          ? null
          : StickyActionBar(
              child: o.canShip && o.status == 'processing'
                  ? BusyButton(
                      label: l.msMarkShipped,
                      icon: Icons.local_shipping_rounded,
                      busy: _busy,
                      onPressed: _ship,
                    )
                  : BusyButton(
                      label: l.msStartPreparing,
                      icon: Icons.inventory_rounded,
                      busy: _busy,
                      onPressed: () => _act('processing'),
                    ),
            ),
      children: [
        if (o == null && _error != null)
          ErrorView(message: _error!, onRetry: _load)
        else if (o == null)
          const Padding(
            padding: EdgeInsets.all(48),
            child: Center(child: CircularProgressIndicator()),
          )
        else ...[
          SettingsCard(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                MsPill(
                  label: orderStatusLabel(l, o.status),
                  color: o.isOpen ? brand.gold : brand.inkMuted,
                ),
                const Spacer(),
                if (o.paidAt != null)
                  Text(
                    TimeFormat.relative(l, o.paidAt),
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: brand.inkMuted,
                    ),
                  ),
              ],
            ),
          ),
          SettingsCard(
            title: l.msItems,
            icon: Icons.shopping_bag_rounded,
            hue: AstroPalette.money,
            child: Column(
              children: [
                for (final line in o.lines)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${line.quantity} × ${line.title}'
                                '${line.variantName.isEmpty ? '' : ' (${line.variantName})'}',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            if (line.lineTotal != null)
                              Text(Money.format(line.lineTotal!, 'INR')),
                          ],
                        ),
                        for (final e in line.inputs.entries)
                          Text(
                            '${e.key.replaceAll('_', ' ')}: ${e.value}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: brand.inkMuted,
                            ),
                          ),
                      ],
                    ),
                  ),
                if (o.total != null)
                  Row(
                    children: [
                      Text(l.msOrderTotal, style: theme.textTheme.labelLarge),
                      const Spacer(),
                      Text(
                        Money.format(o.total!, 'INR'),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          if (o.addressText.isNotEmpty)
            SettingsCard(
              title: l.msShipTo,
              icon: Icons.location_on_rounded,
              hue: AstroPalette.career,
              trailing: IconButton(
                tooltip: l.msCopyAddress,
                icon: const Icon(Icons.copy_rounded, size: 18),
                onPressed: () {
                  Clipboard.setData(
                    ClipboardData(
                      text: [
                        o.addressText,
                        o.contactPhone,
                      ].where((s) => s.isNotEmpty).join('\n'),
                    ),
                  );
                  showToast(context, l.msCopied);
                },
              ),
              child: Text(
                [
                  o.addressText,
                  o.contactPhone,
                ].where((s) => s.isNotEmpty).join('\n'),
                style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
              ),
            ),
          for (final s in o.shipments)
            SettingsCard(
              title: l.msShipment,
              icon: Icons.local_shipping_rounded,
              hue: AstroPalette.health,
              child: Text(
                [
                  if (s.courierName.isNotEmpty) s.courierName,
                  if (s.awb.isNotEmpty) 'AWB ${s.awb}',
                  if (s.trackingUrl.isNotEmpty) s.trackingUrl,
                ].join('\n'),
              ),
            ),
          if (o.canCancel)
            TextButton.icon(
              onPressed: _busy ? null : _cancel,
              icon: const Icon(Icons.cancel_outlined),
              label: Text(l.msCancelOrder),
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.error,
              ),
            ),
        ],
      ],
    );
  }
}
