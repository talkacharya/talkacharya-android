import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/routes.dart';
import '../../../consultations/data/models/conversation.dart';
import '../../../consultations/presentation/widgets/consultation_style.dart';
import '../../../notifications/presentation/view/notification_bell.dart';
import '../cubit/chats_cubit.dart';

import 'package:talkacharya_ui/talkacharya_ui.dart';
import '../../../../shared/widgets/cosmic_header.dart';

/// Chats tab: one permanent thread per customer — live sessions first, then
/// the rest, searchable by name. Backed by the app-level [ChatsCubit].
class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  late final ChatsCubit _cubit = context.read<ChatsCubit>();

  @override
  void initState() {
    super.initState();
    _cubit
      ..load()
      ..startPolling();
  }

  @override
  void dispose() {
    // App-level singleton: only pause the poll.
    _cubit.stopPolling();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    return Scaffold(
      body: BlocBuilder<ChatsCubit, ChatsState>(
        builder: (context, state) {
          return Column(
            children: [
              CosmicTabHeader(
                title: l.navChats,
                subtitle: l.chatsSubtitle(state.totalUnread),
                actions: [NotificationBell(color: brand.onCosmic)],
                bottom: CosmicSearchField(
                  hint: l.chatsSearch,
                  onChanged: _cubit.search,
                ),
              ),
              Expanded(child: _body(context, state)),
            ],
          );
        },
      ),
    );
  }

  Widget _body(BuildContext context, ChatsState state) {
    final l = context.l10n;
    if (state.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.all.isEmpty && state.error != null) {
      return ErrorView(message: l.chatsLoadError, onRetry: _cubit.load);
    }
    final live = state.live;
    final recent = state.recent;
    final Widget? empty = state.all.isEmpty && state.archived.isEmpty
        ? EmptyState(
            icon: Icons.chat_bubble_outline_rounded,
            title: l.chatsEmptyTitle,
            message: l.chatsEmptyBody,
          )
        : (live.isEmpty && recent.isEmpty && state.archived.isEmpty)
        ? EmptyState(
            icon: Icons.search_off_rounded,
            hue: AstroPalette.air,
            title: l.chatsNoMatch(state.query.trim()),
          )
        : null;

    return RefreshIndicator(
      onRefresh: _cubit.load,
      child: LayoutBuilder(
        builder: (context, box) => ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(0, 12, 0, 24),
          children: empty != null
              ? [SizedBox(height: box.maxHeight - 36, child: empty)]
              : [
                  if (live.isNotEmpty)
                    _Section(title: l.requestsLiveNow, items: live, live: true),
                  if (recent.isNotEmpty)
                    _Section(title: l.chatsRecent, items: recent),
                  if (state.archived.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        child: ListTile(
                          leading: const Icon(Icons.archive_outlined),
                          title: Text(
                            l.chatArchivedRow(state.archived.length),
                          ),
                          // Archived threads still take messages, so their
                          // unread count stays visible from out here.
                          trailing: _archivedUnread(state) > 0
                              ? Badge(label: Text('${_archivedUnread(state)}'))
                              : const Icon(Icons.chevron_right_rounded),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => BlocProvider.value(
                                value: _cubit,
                                child: const _ArchivedChatsPage(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.items, this.live = false});

  final String title;
  final List<Conversation> items;
  final bool live;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 4, 24, 8),
          child: Row(
            children: [
              if (live) ...[
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: brand.online,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
              ],
              Text(
                title.toUpperCase(),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: live ? brand.online : brand.inkMuted,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                for (var i = 0; i < items.length; i++) ...[
                  if (i > 0)
                    Divider(height: 1, indent: 76, color: brand.hairline),
                  GestureDetector(
                    onLongPress: () => _rowActions(context, items[i]),
                    child: ConversationTile(
                      conversation: items[i],
                      onTap: () => context.push(Routes.chatRoom(items[i].id)),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

int _archivedUnread(ChatsState s) =>
    s.archived.fold(0, (sum, c) => sum + c.unread);

/// The threads the astrologer put away — finished readings they are done
/// with — one tap down, still openable and still taking messages.
class _ArchivedChatsPage extends StatelessWidget {
  const _ArchivedChatsPage();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.chatArchivedTitle)),
      body: BlocBuilder<ChatsCubit, ChatsState>(
        builder: (context, state) => ListView(
          padding: const EdgeInsets.only(top: 12),
          children: [
            if (state.archived.isNotEmpty)
              _Section(title: l.chatArchivedTitle, items: state.archived),
          ],
        ),
      ),
    );
  }
}

/// Mute / archive for one row, from a long press.
Future<void> _rowActions(BuildContext context, Conversation c) async {
  final l = context.l10n;
  final cubit = context.read<ChatsCubit>();
  final messenger = ScaffoldMessenger.of(context);
  final picked = await showModalBottomSheet<String>(
    context: context,
    showDragHandle: true,
    builder: (sheet) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(
              c.muted
                  ? Icons.notifications_active_outlined
                  : Icons.notifications_off_outlined,
            ),
            title: Text(c.muted ? l.chatUnmute : l.chatMute),
            onTap: () => Navigator.pop(sheet, 'mute'),
          ),
          if (!c.isLive)
            ListTile(
              leading: Icon(
                c.archived ? Icons.unarchive_outlined : Icons.archive_outlined,
              ),
              title: Text(c.archived ? l.chatUnarchive : l.chatArchive),
              onTap: () => Navigator.pop(sheet, 'archive'),
            ),
          const SizedBox(height: 8),
        ],
      ),
    ),
  );
  if (picked == null) return;
  final error = await cubit.setPreferences(
    c.id,
    muted: picked == 'mute' ? !c.muted : null,
    archived: picked == 'archive' ? !c.archived : null,
  );
  if (error != null) {
    messenger.showSnackBar(SnackBar(content: Text(error)));
  }
}
