import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/astro/onboarding_store.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/astro_palette.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../../core/util/money.dart';
import '../../../../core/util/time_format.dart';
import '../../../../shared/widgets/cosmic_header.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/skeleton.dart';
import '../../../home/data/dashboard_models.dart';
import '../../../notifications/presentation/view/notification_bell.dart';
import '../../data/earnings_models.dart';
import '../cubit/earnings_cubit.dart';
import '../widgets/earnings_widgets.dart';

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
  late final TabController _tabs = TabController(length: 3, vsync: this);

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final summary = context.select((EarningsCubit c) => c.state.summary);
    return Scaffold(
      body: Column(
        children: [
          CosmicTabHeader(
            title: l.navEarnings,
            actions: [NotificationBell(color: brand.onCosmic)],
            bottom: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _BalanceHero(summary: summary.value),
                const SizedBox(height: 16),
                PillTabBar(
                  controller: _tabs,
                  labels: [
                    l.earnTabLedger,
                    l.earnTabPayouts,
                    l.earnTabDocuments,
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabs,
              children: const [_LedgerTab(), _PayoutsTab(), _DocumentsTab()],
            ),
          ),
        ],
      ),
    );
  }
}

/// Gold available balance, clearing + lifetime tiles, and the payout terms.
class _BalanceHero extends StatelessWidget {
  const _BalanceHero({required this.summary});

  final PayoutSummary? summary;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    final s = summary;
    final commission = getIt<OnboardingStore>().profile?.commission;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l.dashAvailable,
          style: theme.textTheme.labelLarge?.copyWith(
            color: brand.onCosmicMuted,
          ),
        ),
        SizedBox(
          height: 44,
          child: s == null
              ? const Align(
                  alignment: Alignment.centerLeft,
                  child: _DarkSkeleton(width: 160, height: 32),
                )
              : ShaderMask(
                  shaderCallback: (r) => const LinearGradient(
                    colors: BrandColors.goldGradient,
                  ).createShader(r),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(end: s.available),
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOutCubic,
                    builder: (_, v, _) => Text(
                      Money.format(v.roundToDouble(), s.currency),
                      style: theme.textTheme.displaySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _GlassStat(
                icon: Icons.hourglass_top_rounded,
                label: l.earnClearing,
                value: s == null ? null : Money.format(s.pending, s.currency),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _GlassStat(
                icon: Icons.auto_graph_rounded,
                label: l.earnLifetime,
                value: s == null ? null : Money.format(s.lifetime, s.currency),
              ),
            ),
          ],
        ),
        if (commission != null) ...[
          const SizedBox(height: 10),
          Text(
            l.earnCycle(
              commission.payoutCycleDays,
              _trimPct(commission.platformPercentage),
            ),
            style: theme.textTheme.bodySmall?.copyWith(
              color: brand.onCosmicMuted,
            ),
          ),
        ],
      ],
    );
  }

  static String _trimPct(String raw) {
    final v = double.tryParse(raw);
    if (v == null) return raw;
    return v == v.roundToDouble() ? v.toStringAsFixed(0) : '$v';
  }
}

class _GlassStat extends StatelessWidget {
  const _GlassStat({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: brand.glowAccent),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(color: brand.onCosmicMuted, fontSize: 12),
                ),
                if (value == null)
                  const Padding(
                    padding: EdgeInsets.only(top: 3),
                    child: _DarkSkeleton(width: 70, height: 14),
                  )
                else
                  Text(
                    value!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: brand.onCosmic,
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
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

/// Faint placeholder block for the dark header.
class _DarkSkeleton extends StatelessWidget {
  const _DarkSkeleton({required this.width, required this.height});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) => Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.10),
      borderRadius: BorderRadius.circular(6),
    ),
  );
}

// --- tabs --------------------------------------------------------------------

/// Scrollable tab body: pull-to-refresh, optional header, centred empty /
/// error states, and a load-more trigger near the bottom.
class _TabList extends StatelessWidget {
  const _TabList({
    required this.children,
    this.header,
    this.placeholder,
    this.onNearEnd,
    this.footerLoading = false,
  });

  final List<Widget> children;
  final Widget? header;

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
              ?header,
              if (placeholder != null)
                SizedBox(
                  height: (box.maxHeight - (header == null ? 36 : 96)).clamp(
                    240,
                    double.infinity,
                  ),
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

class _LedgerTab extends StatelessWidget {
  const _LedgerTab();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final cubit = context.read<EarningsCubit>();
    final (kind, ledger) = context.select(
      (EarningsCubit c) => (c.state.kind, c.state.ledger),
    );

    final groups = <String, List<EarningEntry>>{};
    for (final e in ledger.items) {
      final key = e.createdAt == null ? '' : TimeFormat.day(l, e.createdAt!);
      groups.putIfAbsent(key, () => []).add(e);
    }

    Widget? placeholder;
    if (ledger.items.isEmpty) {
      placeholder = ledger.loading
          ? const _ListSkeleton()
          : ledger.error
          ? ErrorView(message: l.earnLoadError, onRetry: cubit.load)
          : kind != null
          ? EmptyState(
              icon: Icons.filter_alt_off_rounded,
              hue: AstroPalette.air,
              title: l.earnLedgerFilteredEmpty,
            )
          : EmptyState(
              icon: Icons.receipt_long_rounded,
              hue: AstroPalette.money,
              title: l.earnLedgerEmptyTitle,
              message: l.earnLedgerEmptyBody,
            );
    }

    return _TabList(
      header: _KindFilter(value: kind, onChanged: cubit.setKind),
      placeholder: placeholder,
      onNearEnd: cubit.loadMoreLedger,
      footerLoading: ledger.loadingMore,
      children: [
        for (final MapEntry(key: day, value: list) in groups.entries)
          _GroupCard(
            label: day,
            children: [
              for (final e in list)
                EarningEntryTile(
                  entry: e,
                  onTap: e.consultationId == null
                      ? null
                      : () => context.push(
                          Routes.requestDetail(e.consultationId!),
                        ),
                ),
            ],
          ),
      ],
    );
  }
}

class _KindFilter extends StatelessWidget {
  const _KindFilter({required this.value, required this.onChanged});

  final String? value;
  final ValueChanged<String?> onChanged;

  static const _kinds = <String?>[
    null,
    EarningKinds.consultation,
    EarningKinds.gift,
    EarningKinds.prediction,
    EarningKinds.storeSale,
    EarningKinds.affiliate,
    EarningKinds.bonus,
  ];

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
        itemCount: _kinds.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final k = _kinds[i];
          final style = k == null ? null : earningKindStyle(context, k);
          final selected = k == value;
          return ChoiceChip(
            selected: selected,
            showCheckmark: false,
            avatar: style == null
                ? null
                : Icon(
                    style.icon,
                    size: 16,
                    color: selected ? scheme.onPrimary : style.hue.end,
                  ),
            label: Text(style?.label ?? l.earnKindAll),
            labelStyle: TextStyle(
              fontWeight: FontWeight.w700,
              color: selected ? scheme.onPrimary : null,
            ),
            selectedColor: scheme.primary,
            onSelected: (_) => onChanged(k),
          );
        },
      ),
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
