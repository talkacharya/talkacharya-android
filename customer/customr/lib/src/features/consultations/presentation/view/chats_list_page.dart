import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../data/models/consultation.dart';
import '../cubit/chats_list_cubit.dart';

/// The "Chats" tab: live consultations first, then recent ones. Tap to open the
/// room. Fed by the app-level [ChatsListCubit] so the bottom-nav badge and this
/// page stay in sync.
class ChatsListPage extends StatefulWidget {
  const ChatsListPage({super.key});

  @override
  State<ChatsListPage> createState() => _ChatsListPageState();
}

class _ChatsListPageState extends State<ChatsListPage> {
  late final ChatsListCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<ChatsListCubit>();
    _cubit.startPolling();
    _cubit.load();
  }

  @override
  void dispose() {
    // The cubit is an app-level singleton; just pause its poll while off-screen.
    _cubit.stopPolling();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.chatsTitle)),
      body: BlocBuilder<ChatsListCubit, ChatsListState>(
        builder: (context, state) {
          if (state.loading && state.consultations.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.error != null && state.consultations.isEmpty) {
            return ErrorView(
              message: l10n.chatsLoadError,
              onRetry: () => context.read<ChatsListCubit>().load(force: true),
            );
          }
          if (state.consultations.isEmpty) {
            return EmptyState(
              icon: Icons.chat_bubble_outline_rounded,
              title: l10n.chatsEmptyTitle,
              message: l10n.chatsEmptyBody,
            );
          }
          return RefreshIndicator(
            onRefresh: () => context.read<ChatsListCubit>().load(force: true),
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                if (state.live.isNotEmpty) ...[
                  _Header(l10n.chatsSectionActive),
                  for (final c in state.live) _ChatTile(c: c),
                ],
                if (state.past.isNotEmpty) ...[
                  _Header(l10n.chatsSectionRecent),
                  for (final c in state.past) _ChatTile(c: c),
                ],
              ],
            ),
          );
        },
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

class _ChatTile extends StatelessWidget {
  const _ChatTile({required this.c});
  final Consultation c;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;
    final avatar = c.astrologerAvatar;
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: scheme.primaryContainer,
        foregroundImage: (avatar != null && avatar.isNotEmpty)
            ? NetworkImage(avatar)
            : null,
        child: (avatar == null || avatar.isEmpty)
            ? Icon(Icons.person_rounded, color: scheme.onPrimaryContainer)
            : null,
      ),
      title: Text(
        c.astrologerName.isEmpty
            ? l10n.chatsAstrologerFallback
            : c.astrologerName,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        _subtitle(l10n, c),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: c.unreadCount > 0
          ? Badge(label: Text('${c.unreadCount}'))
          : (c.status.isLive
                ? Icon(Icons.circle, size: 10, color: scheme.tertiary)
                : (c.status == ConsultationStatus.ended
                      ? Text(
                          '${c.currency} ${c.gross.toStringAsFixed(0)}',
                          style: Theme.of(context).textTheme.bodySmall,
                        )
                      : const Icon(Icons.chevron_right_rounded))),
      onTap: () => context.push('/consultations/${c.id}'),
    );
  }

  static String _subtitle(AppLocalizations l10n, Consultation c) =>
      switch (c.status) {
        ConsultationStatus.requested => l10n.chatsStatusWaiting,
        ConsultationStatus.accepted ||
        ConsultationStatus.active => l10n.chatsStatusLive,
        ConsultationStatus.ended => l10n.chatsStatusEnded(c.billedMinutes),
        ConsultationStatus.cancelled => l10n.chatsStatusCancelled,
        ConsultationStatus.rejected => l10n.chatsStatusRejected,
        ConsultationStatus.expired => l10n.chatsStatusExpired,
        _ => l10n.chatsStatusGeneric,
      };
}
