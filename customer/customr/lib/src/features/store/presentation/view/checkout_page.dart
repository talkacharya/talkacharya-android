import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/astro_palette.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../../shared/widgets/app_bottom_sheet.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/skeleton.dart';
import '../../data/models/address.dart';
import '../../data/models/checkout.dart';
import '../cubit/checkout_cubit.dart';
import '../cubit/store_payment.dart';
import '../widgets/order_widgets.dart';
import 'addresses_pages.dart';
import '../widgets/store_ui.dart';

/// `/store/checkout` — pops the order id once an order exists (paid or not).
class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return BlocConsumer<CheckoutCubit, CheckoutState>(
      listenWhen: (a, b) =>
          a.stage != b.stage || (b.error != null && a.error != b.error),
      listener: (context, state) {
        if (state.error != null && state.stage == CheckoutStage.review) {
          storeToast(context, state.error!);
        }
        final order = state.order;
        if (state.stage == CheckoutStage.placed && order != null) {
          switch (state.outcome) {
            case GatewayCancelled():
              storeToast(context, l.storePaymentCancelled);
            case GatewayFailed(:final message):
              storeToast(
                context,
                message.isEmpty ? l.storePaymentFailed : message,
              );
            case _:
          }
          context.pop(order.id);
        }
      },
      builder: (context, state) {
        final cubit = context.read<CheckoutCubit>();
        final quote = state.quote.value;
        return PopScope(
          canPop: !state.busy,
          child: Scaffold(
            backgroundColor: context.brand.canvas,
            appBar: AppBar(title: Text(l.storeCheckout)),
            body: state.quote.isError && quote == null
                ? ErrorView(
                    message: state.quote.error ?? '',
                    onRetry: cubit.init,
                  )
                : quote == null
                ? const _CheckoutSkeleton()
                : RefreshIndicator(
                    onRefresh: cubit.requote,
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      children: [
                        for (final p in quote.orderProblems) ...[
                          StoreNotice(
                            message: p.message,
                            tone: 'bad',
                            icon: Icons.error_outline_rounded,
                          ),
                          const SizedBox(height: 10),
                        ],
                        if (quote.needsAddress) ...[
                          StoreSectionTitle(
                            l.storeDeliverTo,
                            hue: AstroPalette.money,
                          ),
                          _AddressSection(state: state),
                          const SizedBox(height: 18),
                        ],
                        StoreSectionTitle(
                          l.storeOrderSummary,
                          hue: AstroPalette.career,
                        ),
                        for (final s in quote.sellers) ...[
                          _SellerQuote(seller: s, currency: quote.currency),
                          const SizedBox(height: 10),
                        ],
                        const SizedBox(height: 8),
                        _WalletToggle(state: state, quote: quote),
                        const SizedBox(height: 18),
                        StoreSectionTitle(
                          l.storeBillDetails,
                          hue: AstroPalette.health,
                        ),
                        StoreCard(
                          child: Column(
                            children: [
                              BillRow(
                                label: l.storeSubtotal,
                                amount: quote.subtotal,
                                currency: quote.currency,
                              ),
                              BillRow(
                                label: l.storeShipping,
                                amount: quote.shipping,
                                currency: quote.currency,
                                valueText: quote.shipping <= 0
                                    ? l.storeFree
                                    : null,
                              ),
                              const Divider(height: 18),
                              BillRow(
                                label: l.storeGrandTotal,
                                amount: quote.grandTotal,
                                currency: quote.currency,
                                strong: true,
                              ),
                              if (quote.taxIncluded > 0)
                                Align(
                                  alignment: AlignmentDirectional.centerEnd,
                                  child: Text(
                                    l.storeTaxIncluded(
                                      storeMoney(
                                        context,
                                        quote.taxIncluded,
                                        quote.currency,
                                      ),
                                    ),
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          color: context.brand.inkMuted,
                                        ),
                                  ),
                                ),
                              if (quote.walletAmount > 0) ...[
                                const Divider(height: 18),
                                BillRow(
                                  label: l.storePaidFromWallet,
                                  amount: quote.walletAmount,
                                  currency: quote.currency,
                                  negative: true,
                                ),
                                BillRow(
                                  label: l.storeToPayNow,
                                  amount: quote.gatewayAmount,
                                  currency: quote.currency,
                                  strong: true,
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        TextField(
                          maxLines: 2,
                          maxLength: 300,
                          onChanged: cubit.setNote,
                          decoration: InputDecoration(
                            labelText: l.storeOrderNote,
                          ),
                        ),
                        StoreNotice(
                          icon: Icons.verified_user_outlined,
                          tone: 'info',
                          message: l.storeCheckoutTrust,
                        ),
                      ],
                    ),
                  ),
            bottomNavigationBar: quote == null
                ? null
                : StoreActionBar(
                    child: Row(
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              quote.payableByWalletOnly
                                  ? l.storeGrandTotal
                                  : l.storeToPayNow,
                              style: Theme.of(context).textTheme.labelMedium
                                  ?.copyWith(color: context.brand.inkMuted),
                            ),
                            Text(
                              storeMoney(
                                context,
                                quote.payableByWalletOnly
                                    ? quote.grandTotal
                                    : quote.gatewayAmount,
                                quote.currency,
                              ),
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: GoldButton(
                            icon: quote.payableByWalletOnly
                                ? Icons.account_balance_wallet_rounded
                                : Icons.lock_outline_rounded,
                            label: quote.payableByWalletOnly
                                ? l.storePlaceOrder
                                : l.storePayNow,
                            busy: state.busy,
                            onPressed: state.canPlace
                                ? () => cubit.placeOrder(storePayer(context))
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }
}

class _AddressSection extends StatelessWidget {
  const _AddressSection({required this.state});
  final CheckoutState state;

  Future<void> _add(BuildContext context) async {
    final cubit = context.read<CheckoutCubit>();
    final saved = await context.push<Address>(Routes.storeAddressNew);
    if (saved != null) await cubit.addressesChanged(select: saved.id);
  }

  Future<void> _pick(BuildContext context) async {
    final cubit = context.read<CheckoutCubit>();
    final list = state.addresses.value ?? const <Address>[];
    final l = context.l10n;
    final result = await showAppSheet<String>(
      context: context,
      title: l.storeDeliverTo,
      builder: (ctx) => ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(ctx).height * 0.6,
        ),
        child: ListView(
          shrinkWrap: true,
          children: [
            for (final a in list)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: AddressCard(
                  address: a,
                  selected: a.id == state.addressId,
                  onTap: () => Navigator.of(ctx).pop(a.id),
                ),
              ),
            OutlinedButton.icon(
              onPressed: () => Navigator.of(ctx).pop('__new'),
              icon: const Icon(Icons.add_location_alt_rounded),
              label: Text(l.storeAddAddress),
            ),
          ],
        ),
      ),
    );
    if (result == null || !context.mounted) return;
    if (result == '__new') {
      await _add(context);
    } else {
      await cubit.selectAddress(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final a = state.address;
    if (state.addresses.value == null) {
      return const AppShimmer(child: SkeletonBox(height: 90, radius: 18));
    }
    if (a == null) {
      return StoreCard(
        child: Row(
          children: [
            Icon(Icons.location_off_outlined, color: context.brand.inkMuted),
            const SizedBox(width: 12),
            Expanded(child: Text(l.storeNoAddressesBody)),
            FilledButton.tonal(
              onPressed: () => _add(context),
              child: Text(l.storeAddAddress),
            ),
          ],
        ),
      );
    }
    return AddressCard(
      address: a,
      onTap: () => _pick(context),
      trailing: TextButton(
        onPressed: () => _pick(context),
        child: Text(l.storeChange),
      ),
    );
  }
}

class _SellerQuote extends StatelessWidget {
  const _SellerQuote({required this.seller, required this.currency});

  final QuoteSeller seller;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    final s = seller;
    final days = switch ((s.deliveryMinDays, s.deliveryMaxDays)) {
      (final int a, final int b) when a != b => l.storeDeliveryDaysRange(a, b),
      (_, final int b) => l.storeDeliveryDays(b),
      (final int a, _) => l.storeDeliveryDays(a),
      _ => null,
    };
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
                  l.storeSoldBy(s.name),
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              if (days != null && s.fulfilment == 'physical')
                StoreStatusChip(label: days, tone: 'info'),
            ],
          ),
          const SizedBox(height: 8),
          for (final i in s.items) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    '${i.title}  ×${i.quantity}',
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
                Text(
                  storeMoney(
                    context,
                    i.total ?? i.unitPrice * i.quantity,
                    currency,
                  ),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            for (final p in i.problems)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  p,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: brand.live,
                  ),
                ),
              ),
            const SizedBox(height: 6),
          ],
          if (s.shipping > 0)
            Text(
              l.storeShippingAmount(storeMoney(context, s.shipping, currency)),
              style: theme.textTheme.labelSmall?.copyWith(
                color: brand.inkMuted,
              ),
            ),
        ],
      ),
    );
  }
}

class _WalletToggle extends StatelessWidget {
  const _WalletToggle({required this.state, required this.quote});

  final CheckoutState state;
  final CheckoutQuote quote;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final disabled = quote.walletAvailable <= 0 || state.busy;
    return StoreCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      child: SwitchListTile.adaptive(
        contentPadding: EdgeInsets.zero,
        secondary: const Icon(Icons.account_balance_wallet_rounded),
        value: state.useWallet && quote.walletAvailable > 0,
        onChanged: disabled ? null : context.read<CheckoutCubit>().setUseWallet,
        title: Text(
          l.storeUseWallet,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Text(
          l.storeWalletAvailable(
            storeMoney(context, quote.walletAvailable, quote.currency),
          ),
        ),
      ),
    );
  }
}

class _CheckoutSkeleton extends StatelessWidget {
  const _CheckoutSkeleton();

  @override
  Widget build(BuildContext context) => AppShimmer(
    child: ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        SkeletonBox(height: 90, radius: 18),
        SizedBox(height: 16),
        SkeletonBox(height: 140, radius: 18),
        SizedBox(height: 16),
        SkeletonBox(height: 60, radius: 18),
        SizedBox(height: 16),
        SkeletonBox(height: 120, radius: 18),
      ],
    ),
  );
}
