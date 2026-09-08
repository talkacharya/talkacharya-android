import 'package:flutter/material.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../consultations/data/consultation_api.dart';
import '../../../consultations/data/models/consultation.dart';

class RequestDetailPage extends StatelessWidget {
  const RequestDetailPage({required this.consultationId, super.key});
  final String consultationId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Consultation')),
      body: FutureBuilder<Consultation>(
        future: getIt<ConsultationApi>().detail(consultationId),
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError || !snap.hasData) {
            return const ErrorView(message: 'Could not load this consultation.');
          }
          final c = snap.data!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _row('Customer', c.customerName),
              _row('Channel', c.channel),
              _row('Status', c.status),
              if (c.question.isNotEmpty) _row('Question', c.question),
              const Divider(height: 32),
              _row('Billed', '${c.billedMinutes} min'),
              _row('Rate', '${c.currency} ${c.rateSnapshot}/min'),
              _row('You earned', '${c.currency} ${c.astrologerAmount}'),
              if (c.rating != null) _row('Rating', '${c.rating} / 5'),
            ],
          );
        },
      ),
    );
  }

  Widget _row(String k, String v) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 110, child: Text(k, style: const TextStyle(color: Colors.grey))),
            Expanded(child: Text(v)),
          ],
        ),
      );
}
