import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../shared/widgets/app_scaffold.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../cubit/earnings_cubit.dart';

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

class _EarningsView extends StatelessWidget {
  const _EarningsView();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: AppScaffold(
        title: 'Earnings',
        child: BlocBuilder<EarningsCubit, EarningsState>(
          builder: (context, state) {
            if (state.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            final cur = state.byCurrency.isNotEmpty ? state.byCurrency.first : const {};
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(children: [
                    _Tile('Available',
                        '${cur['currency'] ?? 'INR'} ${cur['available_to_pay'] ?? '0'}'),
                    const SizedBox(width: 12),
                    _Tile('Pending',
                        '${cur['currency'] ?? 'INR'} ${cur['pending_clearance'] ?? '0'}'),
                    const SizedBox(width: 12),
                    _Tile('Lifetime',
                        '${cur['currency'] ?? 'INR'} ${cur['lifetime_net'] ?? '0'}'),
                  ]),
                ),
                const TabBar(tabs: [
                  Tab(text: 'Ledger'),
                  Tab(text: 'Payouts'),
                  Tab(text: 'Documents'),
                ]),
                Expanded(
                  child: TabBarView(children: [
                    _Ledger(state.entries),
                    _Payouts(state.payouts),
                    _Documents(state.documents),
                  ]),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile(this.label, this.value);
  final String label, value;
  @override
  Widget build(BuildContext context) => Expanded(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
            child: Column(children: [
              Text(value,
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center),
              Text(label, style: Theme.of(context).textTheme.labelSmall),
            ]),
          ),
        ),
      );
}

class _Ledger extends StatelessWidget {
  const _Ledger(this.rows);
  final List<Map<String, dynamic>> rows;
  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) {
      return const EmptyState(icon: Icons.receipt_long_outlined, title: 'No earnings yet');
    }
    return ListView.builder(
      itemCount: rows.length,
      itemBuilder: (context, i) {
        final r = rows[i];
        return ListTile(
          title: Text('${r['currency']} ${r['net_amount']}'),
          subtitle: Text('${r['kind']} · available ${r['available_on'] ?? '—'}'),
          trailing: Text('gross ${r['gross_amount']}',
              style: Theme.of(context).textTheme.labelSmall),
        );
      },
    );
  }
}

class _Payouts extends StatelessWidget {
  const _Payouts(this.rows);
  final List<Map<String, dynamic>> rows;
  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) {
      return const EmptyState(icon: Icons.payments_outlined, title: 'No payouts yet');
    }
    return ListView.builder(
      itemCount: rows.length,
      itemBuilder: (context, i) {
        final r = rows[i];
        return ListTile(
          title: Text('${r['currency']} ${r['net_amount']}'),
          subtitle: Text('${r['status']} · ${r['period_start'] ?? ''}–${r['period_end'] ?? ''}'),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: () => context.push('/earnings/payouts/${r['public_id']}'),
        );
      },
    );
  }
}

class _Documents extends StatelessWidget {
  const _Documents(this.rows);
  final List<Map<String, dynamic>> rows;
  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) {
      return const EmptyState(icon: Icons.description_outlined, title: 'No documents yet');
    }
    return ListView.builder(
      itemCount: rows.length,
      itemBuilder: (context, i) {
        final r = rows[i];
        return ListTile(
          leading: const Icon(Icons.picture_as_pdf_outlined),
          title: Text('${r['kind']}'.replaceAll('_', ' ')),
          subtitle: Text('${r['number']} · ${r['currency']} ${r['total_amount']}'),
        );
      },
    );
  }
}
