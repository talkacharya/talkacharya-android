import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:talkacharya_ui/talkacharya_ui.dart';

import '../../../core/di/service_locator.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/network/friendly_error.dart';
import '../../../core/router/routes.dart';
import '../../../core/util/money.dart';
import '../../../core/util/time_format.dart';
import '../../../shared/widgets/cosmic_header.dart';
import '../../../shared/widgets/settings_widgets.dart';
import '../data/my_store_api.dart';
import '../data/my_store_models.dart';
import 'my_store_widgets.dart';

/// `/my-store` — the astrologer's own shop: set it up once, then their listings,
/// the orders that come in for them, and the services customers booked.
class MyStorePage extends StatefulWidget {
  const MyStorePage({this.initialTab = 0, super.key});

  /// 0 listings, 1 orders, 2 bookings.
  final int initialTab;

  @override
  State<MyStorePage> createState() => _MyStorePageState();
}

class _MyStorePageState extends State<MyStorePage>
    with SingleTickerProviderStateMixin {
  final _api = getIt<MyStoreApi>();
  late final _tabs = TabController(
    length: 3,
    vsync: this,
    initialIndex: widget.initialTab.clamp(0, 2),
  );

  StoreSetup? _setup;
  List<MyListing> _listings = const [];
  List<SellerOrder> _orders = const [];
  List<SellerBooking> _bookings = const [];
  String? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final setup = await _api.setup();
      var listings = const <MyListing>[];
      var orders = const <SellerOrder>[];
      var bookings = const <SellerBooking>[];
      if (setup.exists) {
        listings = await _api.listings();
      }
      if (setup.isActive) {
        // A store with nothing sold yet has nothing here; fine either way.
        orders = await _api.orders().catchError((_) => const <SellerOrder>[]);
        bookings = await _api.bookings().catchError(
          (_) => const <SellerBooking>[],
        );
      }
      if (!mounted) return;
      setState(() {
        _setup = setup;
        _listings = listings;
        _orders = orders;
        _bookings = bookings;
        _error = null;
        _loading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = friendlyError(e);
          _loading = false;
        });
      }
    }
  }

  Future<void> _open(String route) async {
    await context.push(route);
    if (mounted) await _load();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final setup = _setup;
    final ready = setup != null && setup.exists;
    final openOrders = _orders.where((o) => o.isOpen).length;
    final openBookings = _bookings.where((b) => b.isOpen).length;
    return Scaffold(
      backgroundColor: brand.canvas,
      floatingActionButton: ready && !setup.isSuspended
          ? AnimatedBuilder(
              animation: _tabs,
              builder: (context, _) => _tabs.index == 0
                  ? FloatingActionButton.extended(
                      onPressed: () => _open(Routes.myStoreNewListing),
                      icon: const Icon(Icons.add_rounded),
                      label: Text(l.msAddListing),
                    )
                  : const SizedBox.shrink(),
            )
          : null,
      body: Column(
        children: [
          CosmicTabHeader(
            leading: BackButton(color: brand.onCosmic),
            title: ready ? setup.displayName : l.msTitle,
            subtitle: ready ? l.msSubtitle : l.msSubtitleNew,
            actions: [
              if (ready)
                IconButton(
                  tooltip: l.msEditStore,
                  onPressed: () => _open(Routes.myStoreSetup),
                  icon: Icon(Icons.storefront_rounded, color: brand.onCosmic),
                ),
            ],
            bottom: ready
                ? PillTabBar(
                    controller: _tabs,
                    labels: [l.msTabListings, l.msTabOrders, l.msTabBookings],
                    counts: [0, openOrders, openBookings],
                  )
                : null,
          ),
          Expanded(child: _body(context)),
        ],
      ),
    );
  }

  Widget _body(BuildContext context) {
    final l = context.l10n;
    if (_loading) return const Center(child: CircularProgressIndicator());
    final setup = _setup;
    if (setup == null) {
      return ErrorView(message: _error ?? l.commonLoadFailed, onRetry: _load);
    }
    if (!setup.enabled && !setup.exists) {
      return EmptyState(
        icon: Icons.storefront_rounded,
        title: l.msUnavailableTitle,
        message: l.msUnavailableBody,
      );
    }
    if (!setup.exists) return _Intro(onStart: () => _open(Routes.myStoreSetup));
    return TabBarView(
      controller: _tabs,
      children: [
        _ListingsTab(
          setup: setup,
          items: _listings,
          onRefresh: _load,
          onOpen: (item) => _open(Routes.myStoreListing(item.id)),
        ),
        _OrdersTab(
          setup: setup,
          items: _orders,
          onRefresh: _load,
          onOpen: (o) => _open(Routes.myStoreOrder(o.id)),
        ),
        _BookingsTab(
          setup: setup,
          items: _bookings,
          onRefresh: _load,
          api: _api,
        ),
      ],
    );
  }
}

/// Before the store exists: what it is and how it works, and the way in.
class _Intro extends StatelessWidget {
  const _Intro({required this.onStart});
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final steps = [
      (
        Icons.storefront_rounded,
        AstroPalette.money,
        l.msStep1Title,
        l.msStep1Body,
      ),
      (
        Icons.add_photo_alternate_rounded,
        AstroPalette.career,
        l.msStep2Title,
        l.msStep2Body,
      ),
      (
        Icons.verified_rounded,
        AstroPalette.health,
        l.msStep3Title,
        l.msStep3Body,
      ),
      (
        Icons.account_balance_wallet_rounded,
        AstroPalette.fire,
        l.msStep4Title,
        l.msStep4Body,
      ),
    ];
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
      children: [
        Text(
          l.msIntroTitle,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          l.msIntroBody,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: context.brand.inkMuted,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 18),
        for (final (icon, hue, title, body) in steps)
          SettingsCard(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HueIcon(hue: hue, icon: icon, size: 44, iconSize: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        body,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: context.brand.inkMuted,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 8),
        BusyButton(
          label: l.msSetUpStore,
          icon: Icons.arrow_forward_rounded,
          onPressed: onStart,
        ),
      ],
    );
  }
}

class _ListingsTab extends StatelessWidget {
  const _ListingsTab({
    required this.setup,
    required this.items,
    required this.onRefresh,
    required this.onOpen,
  });

  final StoreSetup setup;
  final List<MyListing> items;
  final Future<void> Function() onRefresh;
  final ValueChanged<MyListing> onOpen;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 96),
        children: [
          if (setup.isPending)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: NoteBox(
                title: l.msPendingTitle,
                text: l.msPendingBody,
                color: AstroPalette.career.end,
                icon: Icons.hourglass_top_rounded,
              ),
            ),
          if (setup.isSuspended)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: NoteBox(
                title: l.msSuspendedTitle,
                text: l.msSuspendedBody,
                color: const Color(0xFFCC0C39),
                icon: Icons.pause_circle_rounded,
              ),
            ),
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: EmptyState(
                icon: Icons.inventory_2_rounded,
                title: l.msNoListingsTitle,
                message: l.msNoListingsBody,
              ),
            )
          else
            for (final item in items)
              ListingCard(item: item, onTap: () => onOpen(item)),
        ],
      ),
    );
  }
}

class _OrdersTab extends StatelessWidget {
  const _OrdersTab({
    required this.setup,
    required this.items,
    required this.onRefresh,
    required this.onOpen,
  });

  final StoreSetup setup;
  final List<SellerOrder> items;
  final Future<void> Function() onRefresh;
  final ValueChanged<SellerOrder> onOpen;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    final open = items.where((o) => o.isOpen).toList();
    final rest = items.where((o) => !o.isOpen).toList();
    Widget row(SellerOrder o) => Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: o.isOpen ? brand.gold : brand.hairline),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => onOpen(o),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                HueIcon(
                  hue: o.fulfilment == 'service'
                      ? AstroPalette.fire
                      : AstroPalette.money,
                  icon: o.fulfilment == 'service'
                      ? Icons.temple_hindu_rounded
                      : Icons.local_shipping_rounded,
                  size: 44,
                  iconSize: 22,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        o.lines
                            .map((x) => '${x.quantity} × ${x.title}')
                            .join(', '),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        [
                          o.number,
                          if (o.paidAt != null)
                            TimeFormat.relative(l, o.paidAt),
                        ].join(' · '),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: brand.inkMuted,
                        ),
                      ),
                      const SizedBox(height: 6),
                      MsPill(
                        label: orderStatusLabel(l, o.status),
                        color: o.isOpen ? brand.gold : brand.inkMuted,
                      ),
                    ],
                  ),
                ),
                if (o.total != null)
                  Text(
                    Money.format(o.total!, 'INR'),
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 32),
        children: [
          if (!setup.isActive)
            NoteBox(
              title: l.msPendingTitle,
              text: l.msOrdersAfterApproval,
              color: AstroPalette.career.end,
              icon: Icons.hourglass_top_rounded,
            )
          else if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: EmptyState(
                icon: Icons.receipt_long_rounded,
                title: l.msNoOrdersTitle,
                message: l.msNoOrdersBody,
              ),
            )
          else ...[
            if (open.isNotEmpty) ...[
              _Heading(l.msOrdersToDo),
              for (final o in open) row(o),
            ],
            if (rest.isNotEmpty) ...[
              _Heading(l.msOrdersEarlier),
              for (final o in rest) row(o),
            ],
          ],
        ],
      ),
    );
  }
}

class _BookingsTab extends StatefulWidget {
  const _BookingsTab({
    required this.setup,
    required this.items,
    required this.onRefresh,
    required this.api,
  });

  final StoreSetup setup;
  final List<SellerBooking> items;
  final Future<void> Function() onRefresh;
  final MyStoreApi api;

  @override
  State<_BookingsTab> createState() => _BookingsTabState();
}

class _BookingsTabState extends State<_BookingsTab> {
  String? _busy;

  Future<void> _run(String id, Future<void> Function() action) async {
    setState(() => _busy = id);
    try {
      await action();
      await widget.onRefresh();
    } catch (e) {
      if (mounted) showToast(context, friendlyError(e));
    }
    if (mounted) setState(() => _busy = null);
  }

  Future<void> _addProof(SellerBooking b) async {
    final l = context.l10n;
    final kind = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (sheet) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_rounded),
              title: Text(l.msProofPhoto),
              onTap: () => Navigator.pop(sheet, 'photo'),
            ),
            ListTile(
              leading: const Icon(Icons.videocam_rounded),
              title: Text(l.msProofVideo),
              onTap: () => Navigator.pop(sheet, 'video'),
            ),
          ],
        ),
      ),
    );
    if (kind == null || !mounted) return;
    final picker = ImagePicker();
    final file = kind == 'video'
        ? await picker.pickVideo(source: ImageSource.gallery)
        : await picker.pickImage(
            source: ImageSource.gallery,
            maxWidth: 2000,
            imageQuality: 85,
          );
    if (file == null) return;
    await _run(b.id, () async {
      await widget.api.addProof(b.id, file.path, kind: kind);
      if (mounted) showToast(context, l.msProofShared);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    final items = widget.items;
    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 32),
        children: [
          if (!widget.setup.isActive)
            NoteBox(
              title: l.msPendingTitle,
              text: l.msOrdersAfterApproval,
              color: AstroPalette.career.end,
              icon: Icons.hourglass_top_rounded,
            )
          else if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: EmptyState(
                icon: Icons.temple_hindu_rounded,
                hue: AstroPalette.fire,
                title: l.msNoBookingsTitle,
                message: l.msNoBookingsBody,
              ),
            )
          else
            for (final b in items)
              SettingsCard(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            b.title,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        MsPill(
                          label: bookingStatusLabel(l, b.status),
                          color: b.isOpen ? brand.gold : brand.inkMuted,
                        ),
                      ],
                    ),
                    if (b.scheduledFor != null)
                      Text(
                        l.msBookingFor(TimeFormat.day(l, b.scheduledFor!)),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: brand.inkMuted,
                        ),
                      ),
                    if (b.sankalp.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      for (final e in b.sankalp.entries)
                        Text(
                          '${e.key.replaceAll('_', ' ')}: ${e.value}',
                          style: theme.textTheme.bodySmall,
                        ),
                    ],
                    if (b.isOpen) ...[
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          if (b.canMarkPerformed)
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: _busy == b.id
                                    ? null
                                    : () => _run(
                                        b.id,
                                        () => widget.api.markPerformed(b.id),
                                      ),
                                icon: const Icon(Icons.done_rounded, size: 18),
                                label: Text(l.msMarkPerformed),
                              ),
                            ),
                          if (b.canMarkPerformed && b.canAddProof)
                            const SizedBox(width: 8),
                          if (b.canAddProof)
                            Expanded(
                              child: FilledButton.icon(
                                onPressed: _busy == b.id
                                    ? null
                                    : () => _addProof(b),
                                icon: const Icon(
                                  Icons.upload_rounded,
                                  size: 18,
                                ),
                                label: Text(l.msShareProof),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
        ],
      ),
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(4, 6, 4, 8),
    child: Text(
      text.toUpperCase(),
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: context.brand.inkMuted,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.8,
      ),
    ),
  );
}
