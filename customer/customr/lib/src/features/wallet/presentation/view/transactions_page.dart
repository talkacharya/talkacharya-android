import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/fade_slide_in.dart';
import '../../data/models/wallet_transaction.dart';
import '../cubit/transactions_cubit.dart';
import 'widgets/transaction_tile.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<TransactionsCubit>()..load(),
      child: const _TransactionsView(),
    );
  }
}

class _TransactionsView extends StatefulWidget {
  const _TransactionsView();
  @override
  State<_TransactionsView> createState() => _TransactionsViewState();
}

class _TransactionsViewState extends State<_TransactionsView> {
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 300) {
        context.read<TransactionsCubit>().loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.walletTransactions)),
      body: Column(
        children: [
          const _FilterBar(),
          Expanded(
            child: BlocBuilder<TransactionsCubit, TransactionsState>(
              builder: (context, state) {
                final cubit = context.read<TransactionsCubit>();
                if (state.status == TxnStatus.error && state.items.isEmpty) {
                  return ErrorView(
                    message: l.commonSomethingWentWrong,
                    onRetry: cubit.refresh,
                  );
                }
                if (state.status == TxnStatus.loading && state.items.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                final rows = state.visible;
                if (rows.isEmpty) {
                  return EmptyState(
                    icon: Icons.receipt_long_rounded,
                    title: l.walletNoTransactions,
                    message: l.walletNoTransactionsHint,
                  );
                }
                final grouped = _group(context, rows);
                return RefreshIndicator(
                  onRefresh: cubit.refresh,
                  child: ListView.builder(
                    controller: _scroll,
                    padding: const EdgeInsets.only(bottom: 24),
                    itemCount: grouped.length + 1,
                    itemBuilder: (context, i) {
                      if (i == grouped.length) {
                        return state.status == TxnStatus.loadingMore
                            ? const Padding(
                                padding: EdgeInsets.all(16),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : const SizedBox(height: 8);
                      }
                      final entry = grouped[i];
                      if (entry is String) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
                          child: Text(
                            entry,
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        );
                      }
                      return FadeSlideIn(
                        delay: Duration(milliseconds: 20 * (i % 8)),
                        child: TransactionTile(txn: entry as WalletTransaction),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Flatten into [dateHeader, txn, txn, dateHeader, txn, ...].
  List<Object> _group(BuildContext context, List<WalletTransaction> rows) {
    final l = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final out = <Object>[];
    String? lastKey;
    for (final t in rows) {
      final d = t.createdAt ?? now;
      final day = DateTime(d.year, d.month, d.day);
      final key = day.toIso8601String();
      if (key != lastKey) {
        lastKey = key;
        if (day == today) {
          out.add(l.commonToday);
        } else if (day == today.subtract(const Duration(days: 1))) {
          out.add(l.commonYesterday);
        } else {
          out.add(DateFormat.yMMMd(locale).format(d));
        }
      }
      out.add(t);
    }
    return out;
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final cubit = context.read<TransactionsCubit>();
    final active = context.select((TransactionsCubit c) => c.state.filter);
    final options = <(TxnFilter, String)>[
      (TxnFilter.all, l.walletFilterAll),
      (TxnFilter.added, l.walletFilterRecharge),
      (TxnFilter.consultation, l.walletFilterConsultation),
      (TxnFilter.refund, l.walletFilterRefund),
      (TxnFilter.bonus, l.walletFilterBonus),
    ];
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        itemCount: options.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final (value, label) = options[i];
          return ChoiceChip(
            label: Text(label),
            selected: value == active,
            showCheckmark: false,
            onSelected: (_) => cubit.setFilter(value),
          );
        },
      ),
    );
  }
}
