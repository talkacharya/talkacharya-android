import 'package:flutter/material.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../data/earnings_api.dart';

class PayoutDetailPage extends StatelessWidget {
  const PayoutDetailPage({required this.payoutId, super.key});
  final String payoutId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payout')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: getIt<EarningsApi>().payout(payoutId),
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError || !snap.hasData) {
            return const ErrorView(message: 'Could not load this payout.');
          }
          final p = snap.data!;
          final entries = (p['entries'] as List? ?? const []);
          final docs = (p['documents'] as List? ?? const []);
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _row('Amount', '${p['currency']} ${p['net_amount']}'),
              _row('Status', '${p['status']}'),
              _row('Gross', '${p['currency']} ${p['gross']}'),
              _row('TDS', '${p['currency']} ${p['tds_amount']}'),
              if ((p['utr'] ?? '').toString().isNotEmpty) _row('UTR', '${p['utr']}'),
              _row('Paid at', '${p['paid_at'] ?? '—'}'),
              const Divider(height: 32),
              Text('Earning entries (${entries.length})',
                  style: Theme.of(context).textTheme.titleMedium),
              for (final e in entries)
                ListTile(
                  dense: true,
                  title: Text('${e['currency']} ${e['net_amount']}'),
                  subtitle: Text('${e['kind']}'),
                ),
              if (docs.isNotEmpty) ...[
                const Divider(height: 32),
                Text('Documents', style: Theme.of(context).textTheme.titleMedium),
                for (final d in docs)
                  ListTile(
                    dense: true,
                    leading: const Icon(Icons.picture_as_pdf_outlined),
                    title: Text('${d['kind']}'.replaceAll('_', ' ')),
                    subtitle: Text('${d['number']}'),
                  ),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _row(String k, String v) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(children: [
          SizedBox(width: 90, child: Text(k, style: const TextStyle(color: Colors.grey))),
          Expanded(child: Text(v)),
        ]),
      );
}
