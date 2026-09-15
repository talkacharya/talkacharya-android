import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/network/friendly_error.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../data/models/order.dart';
import '../../data/store_repository.dart';
import '../widgets/order_widgets.dart';
import '../widgets/store_ui.dart';

/// `/store/orders/:id/lines/:lineId/return` — pops `true` once the request is filed.
class ReturnRequestPage extends StatefulWidget {
  const ReturnRequestPage({
    required this.orderId,
    required this.lineId,
    this.line,
    super.key,
  });

  final String orderId;
  final String lineId;

  /// Passed as `extra` from order detail; absent when opened by URL.
  final OrderLine? line;

  @override
  State<ReturnRequestPage> createState() => _ReturnRequestPageState();
}

class _ReturnRequestPageState extends State<ReturnRequestPage> {
  final _details = TextEditingController();
  String? _reason;
  late int _quantity = 1;
  bool _saving = false;

  @override
  void dispose() {
    _details.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l = context.l10n;
    final reason = _reason;
    if (reason == null) {
      storeToast(context, l.storeReturnPickReason);
      return;
    }
    setState(() => _saving = true);
    final router = GoRouter.of(context);
    try {
      await getIt<StoreRepository>().requestReturn(
        widget.orderId,
        widget.lineId,
        reason: reason,
        quantity: _quantity,
        details: _details.text.trim(),
      );
      if (!mounted) return;
      storeToast(context, l.storeReturnRequested);
      router.pop(true);
    } catch (e) {
      if (!mounted) return;
      storeToast(context, friendlyError(e));
      setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final line = widget.line;
    final maxQty = line?.quantity ?? 1;
    return Scaffold(
      backgroundColor: context.brand.canvas,
      appBar: AppBar(title: Text(l.storeReturnItem)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          if (line != null) ...[
            StoreCard(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          line.productTitle,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        if (line.variantName.isNotEmpty)
                          Text(
                            line.variantName,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: context.brand.inkMuted,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (maxQty > 1)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: _quantity > 1
                              ? () => setState(() => _quantity--)
                              : null,
                          icon: const Icon(Icons.remove_rounded),
                        ),
                        Text('$_quantity', style: theme.textTheme.titleSmall),
                        IconButton(
                          onPressed: _quantity < maxQty
                              ? () => setState(() => _quantity++)
                              : null,
                          icon: const Icon(Icons.add_rounded),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
          StoreSectionTitle(l.storeReturnWhy),
          StoreCard(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: RadioGroup<String>(
              groupValue: _reason,
              onChanged: (v) => setState(() => _reason = v),
              child: Column(
                children: [
                  for (final r in kReturnReasons)
                    RadioListTile<String>(
                      value: r,
                      title: Text(returnReasonLabel(context, r)),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _details,
            maxLines: 4,
            maxLength: 1000,
            decoration: InputDecoration(labelText: l.storeReturnDetails),
          ),
          StoreNotice(tone: 'info', message: l.storeReturnNote),
          const SizedBox(height: 16),
          GoldButton(
            label: l.storeReturnSubmit,
            busy: _saving,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
