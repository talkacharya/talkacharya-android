import 'package:flutter/material.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/network/friendly_error.dart';
import '../../../../core/util/money.dart';
import '../../../../shared/widgets/settings_widgets.dart';
import '../../../earnings/presentation/widgets/earnings_widgets.dart';
import '../../../earnings/presentation/widgets/statement_widgets.dart';
import '../../data/remedies_api.dart';

import 'package:talkacharya_ui/talkacharya_ui.dart';

/// Everything sold through the astrologer's suggestions — products and poojas —
/// with their share of each, where the order stands and, once paid in, where
/// the share is in their earnings.
class RecommendedSalesPage extends StatefulWidget {
  const RecommendedSalesPage({super.key});

  @override
  State<RecommendedSalesPage> createState() => _RecommendedSalesPageState();
}

class _RecommendedSalesPageState extends State<RecommendedSalesPage> {
  RecommendedSales? _sales;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final sales = await getIt<RemediesApi>().recommendedSales();
      if (mounted) {
        setState(() {
          _sales = sales;
          _error = null;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _error = friendlyError(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final sales = _sales;
    return SubPageScaffold(
      title: l.salesTitle,
      onRefresh: _load,
      children: [
        if (sales == null && _error != null)
          ErrorView(message: _error!, onRetry: _load)
        else if (sales == null)
          const Padding(
            padding: EdgeInsets.all(48),
            child: Center(child: CircularProgressIndicator()),
          )
        else ...[
          _Totals(sales: sales),
          const SizedBox(height: 12),
          if (sales.items.isEmpty)
            EmptyState(
              icon: Icons.shopping_bag_outlined,
              hue: AstroPalette.money,
              title: l.salesEmpty,
            )
          else
            for (final s in sales.items) _SaleCard(sale: s),
        ],
      ],
    );
  }
}

class _Totals extends StatelessWidget {
  const _Totals({required this.sales});

  final RecommendedSales sales;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    Widget tile(String label, double value, Color color) => Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(color: brand.inkMuted, fontSize: 12)),
            const SizedBox(height: 4),
            Text(
              Money.format(value, 'INR'),
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w900,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
    return Row(
      children: [
        tile(l.salesEarned, sales.earned, brand.online),
        const SizedBox(width: 10),
        tile(l.salesOnTheWay, sales.expected, AstroPalette.money.end),
      ],
    );
  }
}

String _statusLabel(BuildContext context, String status) {
  final l = context.l10n;
  return switch (status) {
    'on_the_way' => l.salesStatusOnTheWay,
    'delivered' => l.salesStatusDelivered,
    'booked' => l.salesStatusBooked,
    'performed' => l.salesStatusPerformed,
    'cancelled' => l.salesStatusCancelled,
    'returned' => l.salesStatusReturned,
    _ => l.salesStatusOrdered,
  };
}

String _pct(double v) =>
    v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(1);

class _SaleCard extends StatelessWidget {
  const _SaleCard({required this.sale});

  final RecommendedSale sale;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    final s = sale;
    final gone = s.status == 'cancelled' || s.status == 'returned';
    final title = [
      s.product,
      if (s.variant.isNotEmpty) s.variant,
      if (s.quantity > 1) '× ${s.quantity}',
    ].join(' · ');
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(
                  s.kind == 'service'
                      ? Icons.temple_hindu_rounded
                      : Icons.shopping_bag_rounded,
                  size: 18,
                  color: AstroPalette.money.end,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              [
                s.customerName,
                if (s.orderedAt != null) shortDate(context, s.orderedAt!),
                _statusLabel(context, s.status),
              ].where((x) => x.isNotEmpty).join(' · '),
              style: theme.textTheme.bodySmall?.copyWith(color: brand.inkMuted),
            ),
            const SizedBox(height: 10),
            if (s.ownProduct)
              Text(
                l.salesOwnProduct,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: brand.inkMuted,
                ),
              )
            else
              Row(
                children: [
                  Text(
                    Money.format(s.amount, 'INR'),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: brand.inkMuted,
                      decoration: gone ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l.salesYourShare(_pct(s.commissionPercent)),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: brand.inkMuted,
                    ),
                  ),
                  const Spacer(),
                  if (s.earningStatus != null) ...[
                    StatementStatusChip(status: s.earningStatus!),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    Money.format(s.commission, 'INR'),
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: gone ? brand.inkMuted : brand.online,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
