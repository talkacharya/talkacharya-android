import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/astro_palette.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/hue_widgets.dart';
import '../../../../shared/widgets/skeleton.dart';
import '../../data/models/order.dart';

import '../cubit/order_cubits.dart';
import '../widgets/order_widgets.dart';
import '../widgets/store_ui.dart';

/// `/store/orders` (`?tab=poojas` opens the bookings tab).
class OrdersPage extends StatefulWidget {
  const OrdersPage({this.initialTab = 0, super.key});
  final int initialTab;

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage>
    with SingleTickerProviderStateMixin {
  late final _tabs = TabController(
    length: 2,
    vsync: this,
    initialIndex: widget.initialTab,
  )..addListener(_onTab);

  @override
  void initState() {
    super.initState();
    final cubit = context.read<OrdersCubit>();
    cubit.loadOrders();
    if (widget.initialTab == 1) cubit.loadBookings();
  }

  void _onTab() {
    final cubit = context.read<OrdersCubit>();
    if (_tabs.index == 1 &&
        cubit.state.bookings.value == null &&
        !cubit.state.bookings.isLoading) {
      cubit.loadBookings();
    }
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      backgroundColor: context.brand.canvas,
      appBar: AppBar(
        title: Text(l.storeOrdersTitle),
        actions: const [CartButton()],
        bottom: TabBar(
          controller: _tabs,
          tabs: [
            Tab(text: l.storeTabAll),
            Tab(text: l.storeTabPoojas),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: const [_OrdersTab(), _BookingsTab()],
      ),
    );
  }
}

class _OrdersTab extends StatelessWidget {
  const _OrdersTab();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return BlocBuilder<OrdersCubit, OrdersState>(
      buildWhen: (a, b) =>
          a.orders != b.orders || a.loadingMore != b.loadingMore,
      builder: (context, state) {
        final cubit = context.read<OrdersCubit>();
        final list = state.orders.value;
        if (state.orders.isError && list == null) {
          return ErrorView(
            message: state.orders.error ?? '',
            onRetry: cubit.loadOrders,
          );
        }
        if (list == null) return const _ListSkeleton();
        if (list.isEmpty) {
          return EmptyState(
            icon: Icons.receipt_long_outlined,
            title: l.storeNoOrdersTitle,
            message: l.storeNoOrdersBody,
            action: FilledButton.tonal(
              onPressed: () => context.push(Routes.store),
              child: Text(l.storeExplore),
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: cubit.loadOrders,
          child: NotificationListener<ScrollNotification>(
            onNotification: (n) {
              if (n.metrics.extentAfter < 400) cubit.loadMore();
              return false;
            },
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
              itemCount: list.length + (state.hasMore ? 1 : 0),
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                if (i >= list.length) {
                  return const Padding(
                    padding: EdgeInsets.all(12),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                return _OrderCard(order: list[i]);
              },
            ),
          ),
        );
      },
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order});
  final OrderSummary order;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    final (label, tone) = orderStatusStyle(context, order.status);
    final first = order.items.firstOrNull;
    final more = order.items.length - 1;
    final hue = order.hasService ? AstroPalette.fire : AstroPalette.money;
    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => context.push(Routes.storeOrder(order.id)),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: brand.hairline),
          ),
          child: Row(
            children: [
              HueIcon(
                hue: hue,
                icon: order.hasService
                    ? Icons.local_fire_department_rounded
                    : Icons.shopping_bag_rounded,
                size: 46,
                iconSize: 22,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      first == null
                          ? l.storeOrderNumber(order.number)
                          : more > 0
                          ? l.storeItemAndMore(first.title, more)
                          : first.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '#${order.number} · ${storeDate(context, order.createdAt)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: brand.inkMuted,
                      ),
                    ),
                    const SizedBox(height: 6),
                    StoreStatusChip(label: label, tone: tone),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    storeMoney(context, order.grandTotal, order.currency),
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Icon(Icons.chevron_right_rounded, color: brand.inkMuted),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BookingsTab extends StatelessWidget {
  const _BookingsTab();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return BlocBuilder<OrdersCubit, OrdersState>(
      buildWhen: (a, b) => a.bookings != b.bookings,
      builder: (context, state) {
        final cubit = context.read<OrdersCubit>();
        final list = state.bookings.value;
        if (state.bookings.isError && list == null) {
          return ErrorView(
            message: state.bookings.error ?? '',
            onRetry: cubit.loadBookings,
          );
        }
        if (list == null) return const _ListSkeleton();
        if (list.isEmpty) {
          return EmptyState(
            icon: Icons.local_fire_department_outlined,
            title: l.storeNoPoojasTitle,
            message: l.storeNoPoojasBody,
            action: FilledButton.tonal(
              onPressed: () => context.push(
                Routes.storeProductsWith({'fulfilment': 'service'}),
              ),
              child: Text(l.storeBrowsePoojas),
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: cubit.loadBookings,
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
            itemCount: list.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, i) => BookingCard(
              booking: list[i],
              onTap: list[i].orderId.isEmpty
                  ? null
                  : () => context.push(Routes.storeOrder(list[i].orderId)),
            ),
          ),
        );
      },
    );
  }
}

/// A pooja booking: date, venue, status, proof availability.
class BookingCard extends StatelessWidget {
  const BookingCard({
    required this.booking,
    this.onTap,
    this.showTitle = true,
    super.key,
  });

  final ServiceBooking booking;
  final VoidCallback? onTap;
  final bool showTitle;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    final b = booking;
    final (label, tone) = bookingStyle(context, b.status);
    final when = b.when;
    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: brand.hairline),
          ),
          child: Row(
            children: [
              _DateBadge(date: when),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showTitle)
                      Text(
                        b.productTitle.isEmpty
                            ? (b.event?.title ?? '')
                            : b.productTitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    if (b.event?.venue.isNotEmpty ?? false)
                      Text(
                        b.event!.venue,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: brand.inkMuted,
                        ),
                      ),
                    Text(
                      when == null
                          ? l.storeDateToBeAnnounced
                          : storeDate(context, when, withTime: true),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: brand.inkMuted,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        StoreStatusChip(label: label, tone: tone),
                        if (b.hasProof)
                          StoreStatusChip(
                            label: l.storeVideoReady,
                            tone: 'good',
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              if (onTap != null)
                Icon(Icons.chevron_right_rounded, color: brand.inkMuted),
            ],
          ),
        ),
      ),
    );
  }
}

class _DateBadge extends StatelessWidget {
  const _DateBadge({required this.date});
  final DateTime? date;

  @override
  Widget build(BuildContext context) {
    final d = date?.toLocal();
    final locale = Localizations.localeOf(context).toLanguageTag();
    return Container(
      width: 54,
      height: 58,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: AstroPalette.fire.linear(),
      ),
      child: d == null
          ? const Icon(Icons.local_fire_department_rounded, color: Colors.white)
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${d.day}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                ),
                Text(
                  DateFormat('MMM', locale).format(d),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
    );
  }
}

class _ListSkeleton extends StatelessWidget {
  const _ListSkeleton();

  @override
  Widget build(BuildContext context) => AppShimmer(
    child: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        for (var i = 0; i < 5; i++)
          const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: SkeletonBox(height: 86, radius: 18),
          ),
      ],
    ),
  );
}
