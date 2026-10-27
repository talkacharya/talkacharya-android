import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/util/money.dart';
import '../../../../core/util/time_format.dart';
import '../../../home/data/dashboard_models.dart';
import '../../../notifications/presentation/view/notification_bell.dart';
import '../../data/earnings_models.dart';
import '../../data/received_gift.dart';
import '../cubit/earnings_cubit.dart';
import '../widgets/earnings_widgets.dart';
import '../widgets/earnings_trend_card.dart';
import '../widgets/statement_widgets.dart';

import 'package:talkacharya_ui/talkacharya_ui.dart';

class EarningsPage extends StatelessWidget {
  const EarningsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<EarningsCubit>()..load(),
      child: const _EarningsView(),
    );
  }
}

class _EarningsView extends StatefulWidget {
  const _EarningsView();

  @override
  State<_EarningsView> createState() => _EarningsViewState();
}

class _EarningsViewState extends State<_EarningsView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs = TabController(length: 4, vsync: this);

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          l.navEarnings,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: false,
        actions: [
          NotificationBell(color: theme.colorScheme.onSurface),
          const SizedBox(width: 4),
        ],
        bottom: TabBar(
          controller: _tabs,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          labelStyle: const TextStyle(fontWeight: FontWeight.w800),
          unselectedLabelColor: brand.inkMuted,
          dividerColor: brand.hairline,
          tabs: [
            Tab(text: l.earnTabCycle),
            Tab(text: l.earnTabPayouts),
            Tab(text: l.earnTabGifts),
            Tab(text: l.earnTabDocuments),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: const [
          _CycleTab(),
          _PayoutsTab(),
          _GiftsTab(),
          _DocumentsTab(),
        ],
      ),
    );
  }
}

/// The cycle running now, in one compact card: the payout and when, its status,
/// and three small figures under it — what is still clearing, lifetime, the cycle.
class _PayoutSummary extends StatelessWidget {
  const _PayoutSummary({required this.statement, required this.summary});

  final EarningsStatement statement;
  final PayoutSummary? summary;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    final st = statement;
    final accent = theme.colorScheme.primary;

    Widget stat(String label, String value) => Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelSmall?.copyWith(color: brand.inkMuted),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accent.withValues(alpha: 0.10),
            accent.withValues(alpha: 0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: accent.withValues(alpha: 0.16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      st.paysOn != null
                          ? l.earnNextPayout(shortDate(context, st.paysOn!))
                          : l.dashAvailable,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: brand.inkMuted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    TweenAnimationBuilder<double>(
                      tween: Tween(end: st.totals.payout),
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOutCubic,
                      builder: (_, v, _) => Text(
                        Money.format(v, st.currency),
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              StatementStatusChip(status: st.status),
            ],
          ),
          const SizedBox(height: 12),
          Divider(height: 1, color: brand.hairline),
          const SizedBox(height: 10),
          Row(
            children: [
              stat(
                l.earnClearing,
                Money.format(st.totals.clearing, st.currency),
              ),
              stat(
                l.earnLifetime,
                summary == null
                    ? '—'
                    : Money.format(summary!.lifetime, summary!.currency),
              ),
              stat(l.earnPaidEveryLabel, l.earnDays(st.cycleDays)),
            ],
          ),
        ],
      ),
    );
  }
}

// --- tabs --------------------------------------------------------------------

/// Scrollable tab body: pull-to-refresh, centred empty /
/// error states, and a load-more trigger near the bottom.
class _TabList extends StatelessWidget {
  const _TabList({
    required this.children,
    this.placeholder,
    this.onNearEnd,
    this.footerLoading = false,
  });

  final List<Widget> children;

  /// Shown instead of [children] (skeleton / empty / error).
  final Widget? placeholder;
  final VoidCallback? onNearEnd;
  final bool footerLoading;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: context.read<EarningsCubit>().load,
      child: NotificationListener<ScrollNotification>(
        onNotification: (n) {
          if (onNearEnd != null && n.metrics.extentAfter < 400) onNearEnd!();
          return false;
        },
        child: LayoutBuilder(
          builder: (context, box) => ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(top: 12, bottom: 24),
            children: [
              if (placeholder != null)
                SizedBox(
                  height: (box.maxHeight - 36).clamp(240, double.infinity),
                  child: placeholder,
                )
              else ...[
                ...children,
                if (footerLoading)
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ListSkeleton extends StatelessWidget {
  const _ListSkeleton();

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Column(
        children: [
          for (var i = 0; i < 5; i++)
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                children: [
                  SkeletonBox(width: 40, height: 40, radius: 12),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SkeletonBox(width: 120),
                        SizedBox(height: 6),
                        SkeletonBox(width: 180, height: 10),
                      ],
                    ),
                  ),
                  SkeletonBox(width: 60),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _GroupCard extends StatelessWidget {
  const _GroupCard({required this.label, required this.children});

  final String label;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (label.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 4, 24, 8),
            child: Text(
              label.toUpperCase(),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: brand.inkMuted,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                for (var i = 0; i < children.length; i++) ...[
                  if (i > 0)
                    Divider(height: 1, indent: 68, color: brand.hairline),
                  children[i],
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// The cycle running now: where the money came from, service by service, and
/// what comes off it down to the payout. Each service opens its items.
class _CycleTab extends StatelessWidget {
  const _CycleTab();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final cubit = context.read<EarningsCubit>();
    final statement = context.select((EarningsCubit c) => c.state.statement);
    final summary = context.select((EarningsCubit c) => c.state.summary);
    final st = statement.value;

    Widget? placeholder;
    if (st == null) {
      placeholder = statement.isError
          ? ErrorView(message: l.earnLoadError, onRetry: cubit.loadStatement)
          : const _ListSkeleton();
    }

    Widget card(String title, Widget child, {Widget? trailing}) => Card(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                ?trailing,
              ],
            ),
            const SizedBox(height: 4),
            child,
          ],
        ),
      ),
    );

    return _TabList(
      placeholder: placeholder,
      children: st == null
          ? const []
          : [
              _PayoutSummary(statement: st, summary: summary.value),
              EarningsTrendCard(currency: st.currency),
              card(l.earnFromTitle, StatementServicesCard(statement: st)),
              card(
                l.earnDeductionsTitle,
                StatementDeductionsCard(statement: st),
              ),
            ],
    );
  }
}

class _PayoutsTab extends StatelessWidget {
  const _PayoutsTab();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final cubit = context.read<EarningsCubit>();
    final payouts = context.select((EarningsCubit c) => c.state.payouts);

    Widget? placeholder;
    if (payouts.items.isEmpty) {
      placeholder = payouts.loading
          ? const _ListSkeleton()
          : payouts.error
          ? ErrorView(message: l.earnLoadError, onRetry: cubit.load)
          : EmptyState(
              icon: Icons.account_balance_rounded,
              hue: AstroPalette.health,
              title: l.earnPayoutsEmptyTitle,
              message: l.earnPayoutsEmptyBody,
            );
    }

    return _TabList(
      placeholder: placeholder,
      onNearEnd: cubit.loadMorePayouts,
      footerLoading: payouts.loadingMore,
      children: [
        for (final p in payouts.items)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: PayoutCard(
              payout: p,
              onTap: () => context.push(Routes.payout(p.id)),
            ),
          ),
      ],
    );
  }
}

class _GiftsTab extends StatelessWidget {
  const _GiftsTab();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final cubit = context.read<EarningsCubit>();
    final gifts = context.select((EarningsCubit c) => c.state.gifts);

    Widget? placeholder;
    if (gifts.items.isEmpty) {
      placeholder = gifts.loading
          ? const _ListSkeleton()
          : gifts.error
          ? ErrorView(message: l.earnLoadError, onRetry: cubit.load)
          : EmptyState(
              icon: Icons.card_giftcard_rounded,
              hue: AstroPalette.fire,
              title: l.earnGiftsEmptyTitle,
              message: l.earnGiftsEmptyBody,
            );
    }

    return _TabList(
      placeholder: placeholder,
      onNearEnd: cubit.loadMoreGifts,
      footerLoading: gifts.loadingMore,
      children: [
        for (final g in gifts.items)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: _GiftCard(gift: g),
          ),
      ],
    );
  }
}

/// One gift. Who sent it, from where, and what it was worth.
class _GiftCard extends StatelessWidget {
  const _GiftCard({required this.gift});
  final ReceivedGift gift;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AstroPalette.fire.tint(0.18),
              child: const Icon(Icons.card_giftcard_rounded, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    gift.giftName.isEmpty ? gift.giftSlug : gift.giftName,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    [
                      if (gift.senderName.isNotEmpty) gift.senderName,
                      if (gift.context == 'livestream')
                        l.earnGiftFromLive
                      else if (gift.context == 'consultation')
                        l.earnGiftFromConsultation,
                      TimeFormat.relative(l, gift.createdAt),
                    ].where((t) => t.isNotEmpty).join(' · '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: brand.inkMuted,
                    ),
                  ),
                  if (gift.message.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      gift.message,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  Money.format(gift.grossAmount, gift.currency),
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    // A refunded gift still happened, but it is not money.
                    decoration: gift.isRefunded
                        ? TextDecoration.lineThrough
                        : null,
                    color: gift.isRefunded ? brand.inkMuted : null,
                  ),
                ),
                if (gift.quantity > 1)
                  Text(
                    '×${gift.quantity}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: brand.inkMuted,
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

class _DocumentsTab extends StatelessWidget {
  const _DocumentsTab();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final cubit = context.read<EarningsCubit>();
    final docs = context.select((EarningsCubit c) => c.state.documents);
    final items = docs.value ?? const <TaxDocument>[];

    Widget? placeholder;
    if (items.isEmpty) {
      placeholder = docs.isError
          ? ErrorView(message: l.earnLoadError, onRetry: cubit.load)
          : docs.hasValue
          ? EmptyState(
              icon: Icons.description_rounded,
              hue: AstroPalette.fire,
              title: l.earnDocsEmptyTitle,
              message: l.earnDocsEmptyBody,
            )
          : const _ListSkeleton();
    }

    return _TabList(
      placeholder: placeholder,
      children: [
        if (items.isNotEmpty)
          _GroupCard(
            label: '',
            children: [for (final d in items) TaxDocumentTile(document: d)],
          ),
      ],
    );
  }
}
