import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../data/consultation_repository.dart';
import '../../data/models/consultation.dart';

class ConsultationsListPage extends StatefulWidget {
  const ConsultationsListPage({super.key});

  @override
  State<ConsultationsListPage> createState() => _ConsultationsListPageState();
}

class _ConsultationsListPageState extends State<ConsultationsListPage> {
  late Future<List<Consultation>> _future = _load();

  Future<List<Consultation>> _load() =>
      GetIt.I<ConsultationRepository>().list();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Consultations')),
      body: RefreshIndicator(
        onRefresh: () async => setState(() => _future = _load()),
        child: FutureBuilder<List<Consultation>>(
          future: _future,
          builder: (context, snap) {
            if (snap.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snap.hasError) {
              return ErrorView(
                message: 'Could not load your consultations.',
                onRetry: () => setState(() => _future = _load()),
              );
            }
            final all = snap.data ?? const <Consultation>[];
            if (all.isEmpty) {
              return const EmptyState(
                icon: Icons.chat_bubble_outline_rounded,
                title: 'No consultations yet',
                message:
                    'Find an astrologer and start a chat — it shows up here.',
              );
            }
            final live = all.where((c) => c.status.isLive).toList();
            final past = all.where((c) => !c.status.isLive).toList();
            return ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                if (live.isNotEmpty) ...[
                  const _Header('Active'),
                  for (final c in live) _Tile(c: c),
                ],
                if (past.isNotEmpty) ...[
                  const _Header('History'),
                  for (final c in past) _Tile(c: c),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
    child: Text(
      text.toUpperCase(),
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.6,
      ),
    ),
  );
}

class _Tile extends StatelessWidget {
  const _Tile({required this.c});
  final Consultation c;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: scheme.primaryContainer,
        foregroundImage:
            (c.astrologerAvatar != null && c.astrologerAvatar!.isNotEmpty)
            ? NetworkImage(c.astrologerAvatar!)
            : null,
        child: (c.astrologerAvatar == null || c.astrologerAvatar!.isEmpty)
            ? Icon(Icons.person_rounded, color: scheme.onPrimaryContainer)
            : null,
      ),
      title: Text(
        c.astrologerName.isEmpty ? 'Astrologer' : c.astrologerName,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(_subtitle(c)),
      trailing: c.unreadCount > 0
          ? Badge(label: Text('${c.unreadCount}'))
          : (c.status.isLive
                ? const Icon(Icons.circle, size: 10, color: Colors.green)
                : Text(
                    c.status.isTerminal ? '₹${c.gross.toStringAsFixed(0)}' : '',
                    style: Theme.of(context).textTheme.bodySmall,
                  )),
      onTap: () => context.push('/consultations/${c.id}'),
    );
  }

  static String _subtitle(Consultation c) => switch (c.status) {
    ConsultationStatus.requested => 'Waiting for the astrologer',
    ConsultationStatus.accepted ||
    ConsultationStatus.active => 'Live now · tap to open',
    ConsultationStatus.ended => '${c.billedMinutes} min · chat',
    ConsultationStatus.cancelled => 'Cancelled',
    ConsultationStatus.rejected => 'Not accepted',
    ConsultationStatus.expired => 'Expired',
    _ => 'Chat',
  };
}
