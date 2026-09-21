import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../../core/util/async_value.dart';
import '../../../../core/util/money.dart';
import '../../../auth/presentation/bloc/auth/auth_bloc.dart';
import '../../../../shared/widgets/app_bottom_sheet.dart';
import '../../../../shared/widgets/fade_slide_in.dart';
import '../../data/models/recharge_pack.dart';
import '../../data/models/wallet_transaction.dart';
import '../cubit/wallet_cubit.dart';
import 'recharge_sheet.dart';
import 'widgets/balance_card.dart';
import 'widgets/transaction_tile.dart';
import '../../../../core/l10n/api_error_l10n.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key, this.initialAmount});

  /// Optional amount to pre-fill and trigger the recharge sheet immediately.
  final int? initialAmount;

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  @override
  void initState() {
    super.initState();
    context.read<WalletCubit>().load();

    if (widget.initialAmount != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _recharge(amount: widget.initialAmount);
      });
    }
  }

  String get _currency =>
      context.read<AuthBloc>().state.user?.preferredCurrency ?? 'INR';

  Future<void> _recharge({int? amount}) async {
    final cubit = context.read<WalletCubit>();
    await showRechargeSheet(context, initialAmount: amount);
    await cubit.refresh();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => context.read<WalletCubit>().refresh(),
        child: BlocBuilder<WalletCubit, WalletState>(
          builder: (context, state) {
            final balance = state.primaryFor(_currency);
            final packs = state.packs.value;

            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  title: Text(l.walletTitle),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.help_outline_rounded),
                      tooltip: l.walletHowItWorksTitle,
                      onPressed: () => _howItWorks(context),
                    ),
                  ],
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
                  sliver: SliverList.list(
                    children: [
                      FadeSlideIn(
                        child: BalanceCard(
                          balance: balance,
                          loading: state.balances.isLoading,
                        ),
                      ),
                      const SizedBox(height: 16),
                      FadeSlideIn(
                        delay: const Duration(milliseconds: 60),
                        child: FilledButton.icon(
                          onPressed: () => _recharge(),
                          icon: const Icon(Icons.add_rounded),
                          label: Text(l.walletAddMoney),
                        ),
                      ),
                      if (packs != null && packs.packs.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        FadeSlideIn(
                          delay: const Duration(milliseconds: 110),
                          child: _AmountChips(
                            packs: packs.packs,
                            onPick: (a) => _recharge(amount: a),
                          ),
                        ),
                      ],
                      if (packs != null && packs.offers.isNotEmpty) ...[
                        const SizedBox(height: 14),
                        FadeSlideIn(
                          delay: const Duration(milliseconds: 150),
                          child: _OfferCard(
                            title: packs.offers.first.title,
                            onTap: () => _recharge(
                              amount: packs.offers.first.minRecharge?.round(),
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 14),
                      const FadeSlideIn(
                        delay: Duration(milliseconds: 180),
                        child: _CouponRow(),
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.lock_rounded,
                              size: 13,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              l.walletSecuredBy,
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),
                      _SectionHeader(
                        title: l.walletRecentActivity,
                        onSeeAll: () => context.push(Routes.walletTransactions),
                      ),
                      const SizedBox(height: 6),
                      _RecentList(recent: state.recent),
                      const SizedBox(height: 8),
                      _MenuRow(
                        icon: Icons.receipt_long_rounded,
                        label: l.walletGstInvoices,
                        subtitle: l.walletInvoicesSubtitle,
                        onTap: () => context.push(Routes.walletInvoices),
                      ),
                      const SizedBox(height: 20),
                      _TrustFooter(),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _howItWorks(BuildContext context) {
    final l = context.l10n;
    showAppSheet<void>(
      context: context,
      title: l.walletHowItWorksTitle,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.walletHowItWorksBody,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l.commonOk),
          ),
        ],
      ),
    );
  }
}

class _AmountChips extends StatelessWidget {
  const _AmountChips({required this.packs, required this.onPick});
  final List<RechargePack> packs;
  final void Function(int amount) onPick;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: packs.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final p = packs[i];
          final theme = Theme.of(context);
          return ActionChip(
            onPressed: () => onPick(p.amount),
            side: BorderSide(
              color: p.starter
                  ? theme.colorScheme.primary
                  : context.brand.hairline,
            ),
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(Money.format(p.amount, p.currency, locale: locale)),
                if (p.hasBonus) ...[
                  const SizedBox(width: 4),
                  Text(
                    '+${Money.format(p.bonus, p.currency, locale: locale)}',
                    style: const TextStyle(
                      color: Color(0xFF2E9E4F),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _OfferCard extends StatelessWidget {
  const _OfferCard({required this.title, required this.onTap});
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return Material(
      color: brand.tint,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Icon(Icons.local_offer_rounded, color: brand.onTint, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: brand.onTint,
                  ),
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: brand.onTint),
            ],
          ),
        ),
      ),
    );
  }
}

class _CouponRow extends StatefulWidget {
  const _CouponRow();
  @override
  State<_CouponRow> createState() => _CouponRowState();
}

class _CouponRowState extends State<_CouponRow> {
  bool _open = false;
  final _ctrl = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _apply() async {
    final code = _ctrl.text.trim();
    if (code.isEmpty) return;
    setState(() => _busy = true);
    final l = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final cubit = context.read<WalletCubit>();
    final locale = Localizations.localeOf(context).toLanguageTag();
    try {
      final res = await cubit.redeemPromo(code);
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            l.walletCouponApplied(
              Money.format(res.grantedAmount, 'INR', locale: locale),
            ),
          ),
        ),
      );
      _ctrl.clear();
      setState(() => _open = false);
      await cubit.refresh();
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(_couponError(l, e))));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    return AnimatedSize(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      alignment: Alignment.topCenter,
      child: _open
          ? Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _ctrl,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      hintText: l.walletCouponHint,
                      isDense: true,
                    ),
                    onSubmitted: (_) => _apply(),
                  ),
                ),
                const SizedBox(width: 8),
                _busy
                    ? const Padding(
                        padding: EdgeInsets.all(10),
                        child: SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : TextButton(onPressed: _apply, child: Text(l.commonApply)),
              ],
            )
          : InkWell(
              onTap: () => setState(() => _open = true),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: brand.hairline),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.confirmation_number_outlined,
                      size: 18,
                      color: brand.onTint,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      l.walletHaveCoupon,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  String _couponError(AppLocalizations l, Object e) => localizedErrorFor(l, e);
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.onSeeAll});
  final String title;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(fontSize: 19),
          ),
        ),
        if (onSeeAll != null)
          TextButton(
            onPressed: onSeeAll,
            child: Text(context.l10n.commonSeeAll),
          ),
      ],
    );
  }
}

class _RecentList extends StatelessWidget {
  const _RecentList({required this.recent});
  final AsyncValue<List<WalletTransaction>> recent;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return recent.when(
      idle: () => const SizedBox(height: 60),
      loading: () => const SizedBox(
        height: 80,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_) => const SizedBox.shrink(),
      data: (items) {
        if (items.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              l.walletNoTransactions,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          );
        }
        return Column(
          children: FadeSlideIn.list([
            for (final t in items.take(5))
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: TransactionTile(txn: t),
              ),
          ]),
        );
      },
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({
    required this.icon,
    required this.label,
    required this.onTap,
    this.subtitle,
  });
  final IconData icon;
  final String label;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: context.brand.onTint),
      title: Text(label),
      subtitle: subtitle == null ? null : Text(subtitle!),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: onTap,
    );
  }
}

class _TrustFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.brand.tint,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        context.l10n.walletHowItWorksBody,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
