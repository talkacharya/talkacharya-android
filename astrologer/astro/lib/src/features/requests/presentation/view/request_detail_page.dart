import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/router/routes.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../consultations/data/consultation_api.dart';
import '../../../consultations/data/models/consultation.dart';

/// Opened from a History row or an incoming-request push. Shows the consultation
/// and — while it's still `requested` — an Accept / Decline bar. If it's already
/// live, it bounces straight into the room.
class RequestDetailPage extends StatefulWidget {
  const RequestDetailPage({required this.consultationId, super.key});
  final String consultationId;

  @override
  State<RequestDetailPage> createState() => _RequestDetailPageState();
}

class _RequestDetailPageState extends State<RequestDetailPage> {
  late Future<Consultation> _future = getIt<ConsultationApi>().detail(
    widget.consultationId,
  );
  bool _busy = false;

  void _reload() => setState(
    () => _future = getIt<ConsultationApi>().detail(widget.consultationId),
  );

  Future<void> _accept() async {
    setState(() => _busy = true);
    try {
      final c = await getIt<ConsultationApi>().accept(widget.consultationId);
      if (!mounted) return;
      // chat and voice both live in the room (voice renders the call screen)
      context.pushReplacement(Routes.chatRoom(c.id));
    } catch (e) {
      if (mounted) {
        setState(() => _busy = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$e')));
      }
    }
  }

  Future<void> _decline() async {
    setState(() => _busy = true);
    try {
      await getIt<ConsultationApi>().reject(
        widget.consultationId,
        'unavailable',
      );
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        setState(() => _busy = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Consultation')),
      body: FutureBuilder<Consultation>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError || !snap.hasData) {
            return ErrorView(
              message: 'Could not load this consultation.',
              onRetry: _reload,
            );
          }
          final c = snap.data!;
          // Already live → the room is the right place.
          if (c.isLive) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                context.pushReplacement(Routes.chatRoom(widget.consultationId));
              }
            });
            return const Center(child: CircularProgressIndicator());
          }
          final pending = c.status == 'requested';
          return Column(
            children: [
              Expanded(
                child: ListView(
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
                ),
              ),
              if (pending)
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _busy ? null : _decline,
                            child: const Text('Decline'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton(
                            onPressed: _busy ? null : _accept,
                            child: _busy
                                ? const SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text('Accept'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
        SizedBox(
          width: 110,
          child: Text(k, style: const TextStyle(color: Colors.grey)),
        ),
        Expanded(child: Text(v)),
      ],
    ),
  );
}
