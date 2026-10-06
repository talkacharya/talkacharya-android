import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../data/models/conversation.dart';
import '../cubit/chats_list_cubit.dart';

import 'package:talkacharya_ui/talkacharya_ui.dart';
/// The "Chats" tab: live consultations first, then recent ones. Tap to open the
/// room. Fed by the app-level [ChatsListCubit] so the bottom-nav badge and this
/// page stay in sync.
class ChatsListPage extends StatefulWidget {
  const ChatsListPage({super.key});

  @override
  State<ChatsListPage> createState() => _ChatsListPageState();
}

class _ChatsListPageState extends State<ChatsListPage>
    with WidgetsBindingObserver {
  late final ChatsListCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<ChatsListCubit>();
    WidgetsBinding.instance.addObserver(this);
    _cubit.startPolling();
    _cubit.load();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // The cubit is an app-level singleton; just pause its poll while off-screen.
    _cubit.stopPolling();
    super.dispose();
  }

  /// No point polling while the app is in the background; catch up on return.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _cubit.startPolling();
        _cubit.load();
      case AppLifecycleState.paused:
        _cubit.stopPolling();
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.chatsTitle)),
      body: BlocConsumer<ChatsListCubit, ChatsListState>(
        // A failed refresh while we already have rows used to be silent —
        // the list just stayed stale. Tell the person, keep the rows.
        listenWhen: (a, b) =>
            a.error != b.error && b.error != null && b.conversations.isNotEmpty,
        listener: (context, state) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(l10n.chatsLoadError),
                behavior: SnackBarBehavior.floating,
              ),
            );
        },
        builder: (context, state) {
          final hasData = state.conversations.isNotEmpty;

          if (state.loading && !hasData) {
            return const _ChatsListSkeleton();
          }

          // Empty and error views live inside the scroll view too, so
          // pull-to-refresh works from them (it didn't before: a
          // RefreshIndicator needs a scrollable child).
          final Widget? placeholder = hasData
              ? null
              : state.error != null
              ? ErrorView(
                  message: l10n.chatsLoadError,
                  onRetry: () => _cubit.load(force: true),
                )
              : EmptyState(
                  icon: Icons.chat_bubble_outline_rounded,
                  title: l10n.chatsEmptyTitle,
                  message: l10n.chatsEmptyBody,
                );

          final archivedUnread = state.archived.fold<int>(
            0,
            (sum, c) => sum + c.unread,
          );

          return RefreshIndicator(
            onRefresh: () => _cubit.load(force: true),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                if (placeholder != null)
                  SliverFillRemaining(hasScrollBody: false, child: placeholder)
                else ...[
                  if (state.live.isNotEmpty)
                    _Section(title: l10n.chatsSectionActive, items: state.live),
                  if (state.past.isNotEmpty)
                    _Section(title: l10n.chatsSectionRecent, items: state.past),
                  if (state.archived.isNotEmpty)
                    SliverToBoxAdapter(
                      child: ListTile(
                        leading: const Icon(Icons.archive_outlined),
                        title: Text(
                          l10n.chatArchivedRow(state.archived.length),
                        ),
                        // Archived threads can still be written to, so their
                        // unread count stays visible from out here.
                        trailing: archivedUnread > 0
                            ? _UnreadBadge(archivedUnread)
                            : const Icon(Icons.chevron_right_rounded),
                        onTap: () => _openArchived(context),
                      ),
                    ),
                  // Breathing room under the last row / above the system bar.
                  const SliverToBoxAdapter(child: SizedBox(height: 16)),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

void _openArchived(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => BlocProvider.value(
        value: context.read<ChatsListCubit>(),
        child: const _ArchivedChatsPage(),
      ),
    ),
  );
}

/// The threads the customer put away — the same rows, one tap down.
class _ArchivedChatsPage extends StatelessWidget {
  const _ArchivedChatsPage();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.chatArchivedTitle)),
      body: BlocBuilder<ChatsListCubit, ChatsListState>(
        buildWhen: (a, b) => a.archived != b.archived,
        builder: (context, state) {
          if (state.archived.isEmpty) {
            return EmptyState(
              icon: Icons.archive_outlined,
              title: l10n.chatArchivedTitle,
              message: '',
            );
          }
          return RefreshIndicator(
            onRefresh: () => context.read<ChatsListCubit>().load(force: true),
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: state.archived.length,
              itemBuilder: (_, i) {
                final c = state.archived[i];
                return _ChatTile(key: ValueKey(c.id), c: c);
              },
            ),
          );
        },
      ),
    );
  }
}

/// One titled group of rows: a header that pins to the top while its rows
/// scroll under it, then a lazily-built list. Lazy matters — the old
/// `ListView(children: [for ...])` built every row up front.
class _Section extends StatelessWidget {
  const _Section({required this.title, required this.items});

  final String title;
  final List<Conversation> items;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SliverMainAxisGroup(
      slivers: [
        SliverPersistentHeader(
          pinned: true,
          delegate: _SectionHeaderDelegate(
            text: title,
            background: Theme.of(context).scaffoldBackgroundColor,
            color: scheme.onSurfaceVariant,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
        SliverList.builder(
          itemCount: items.length,
          itemBuilder: (_, i) {
            final c = items[i];
            // Keyed by id so a row keeps its state when the list reorders
            // (a thread moving from "recent" up to "active", say).
            return _ChatTile(key: ValueKey(c.id), c: c);
          },
        ),
      ],
    );
  }
}

class _SectionHeaderDelegate extends SliverPersistentHeaderDelegate {
  const _SectionHeaderDelegate({
    required this.text,
    required this.background,
    required this.color,
    required this.style,
  });

  final String text;
  final Color background;
  final Color color;
  final TextStyle? style;

  static const double _extent = 36;

  @override
  double get minExtent => _extent;

  @override
  double get maxExtent => _extent;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: background,
      alignment: AlignmentDirectional.bottomStart,
      padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 4),
      child: Text(
        text.toUpperCase(),
        style: style?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _SectionHeaderDelegate old) =>
      text != old.text ||
      background != old.background ||
      color != old.color ||
      style != old.style;
}

/// Mute / archive for one row, from a long press.
Future<void> _rowActions(BuildContext context, Conversation c) async {
  final l10n = context.l10n;
  final cubit = context.read<ChatsListCubit>();
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
            title: Text(c.muted ? l10n.chatUnmute : l10n.chatMute),
            onTap: () => Navigator.pop(sheet, 'mute'),
          ),
          if (!c.window.isLive)
            ListTile(
              leading: Icon(
                c.archived ? Icons.unarchive_outlined : Icons.archive_outlined,
              ),
              title: Text(c.archived ? l10n.chatUnarchive : l10n.chatArchive),
              onTap: () => Navigator.pop(sheet, 'archive'),
            ),
          const SizedBox(height: 8),
        ],
      ),
    ),
  );
  if (picked == null) return;
  await _togglePref(cubit, messenger, c, mute: picked == 'mute');
}

/// Flips mute (or archive) for one thread. Shared by the long-press sheet and
/// the swipe actions so both behave identically; takes the cubit and messenger
/// rather than a context so it is safe to call after an await.
Future<void> _togglePref(
  ChatsListCubit cubit,
  ScaffoldMessengerState messenger,
  Conversation c, {
  required bool mute,
}) async {
  final error = await cubit.setPreferences(
    c.id,
    muted: mute ? !c.muted : null,
    archived: mute ? null : !c.archived,
  );
  if (error != null) {
    messenger.showSnackBar(SnackBar(content: Text(error)));
  }
}

/// What shows behind a row while it is being swiped.
class _SwipeBackground extends StatelessWidget {
  const _SwipeBackground({
    required this.icon,
    required this.label,
    required this.alignment,
  });

  final IconData icon;
  final String label;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      color: scheme.secondaryContainer,
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: scheme.onSecondaryContainer),
          const SizedBox(height: 2),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: scheme.onSecondaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}

/// Unread count, capped so a long-neglected thread doesn't blow out the row.
class _UnreadBadge extends StatelessWidget {
  const _UnreadBadge(this.count);

  final int count;

  @override
  Widget build(BuildContext context) =>
      Badge(label: Text(count > 99 ? '99+' : '$count'));
}

class _ChatTile extends StatelessWidget {
  const _ChatTile({required this.c, super.key});

  final Conversation c;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;
    final avatar = c.peerAvatar;
    final name = c.peerName.isEmpty ? l10n.chatsAstrologerFallback : c.peerName;
    final hasUnread = c.unread > 0;
    final tile = ListTile(
      leading: _Avatar(name: name, url: avatar, scheme: scheme),
      title: Row(
        children: [
          Flexible(
            child: Text(
              c.peerName.isEmpty ? l10n.chatsAstrologerFallback : c.peerName,
              style: TextStyle(
                fontWeight: hasUnread ? FontWeight.w700 : FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (c.muted) ...[
            const SizedBox(width: 6),
            Icon(
              Icons.notifications_off_outlined,
              size: 15,
              color: scheme.onSurfaceVariant,
            ),
          ],
        ],
      ),
      subtitle: Text(
        _previewText(l10n, c),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        // Unread rows read as unread: heavier, full-contrast preview.
        style: hasUnread
            ? TextStyle(color: scheme.onSurface, fontWeight: FontWeight.w600)
            : null,
      ),
      trailing: hasUnread
          ? _UnreadBadge(c.unread)
          : (c.window.isLive
                ? Icon(
                    Icons.circle,
                    size: 10,
                    color: scheme.tertiary,
                    semanticLabel: l10n.chatsStatusLive,
                  )
                : const Icon(Icons.chevron_right_rounded)),
      // The thread's own id: the room is the conversation now, and it opens
      // whether or not a consultation is running inside it.
      onTap: () => context.push('/consultations/${c.id}'),
      onLongPress: () => _rowActions(context, c),
    );

    // Swipe is a shortcut for what long-press already offers, so nothing is
    // lost if someone never finds it. Right: mute / unmute. Left: archive /
    // unarchive — not offered on a live thread, same as the long-press sheet.
    final canArchive = !c.window.isLive;
    return Dismissible(
      key: ValueKey('swipe-${c.id}'),
      direction: canArchive
          ? DismissDirection.horizontal
          : DismissDirection.startToEnd,
      background: _SwipeBackground(
        alignment: AlignmentDirectional.centerStart,
        icon: c.muted
            ? Icons.notifications_active_outlined
            : Icons.notifications_off_outlined,
        label: c.muted ? l10n.chatUnmute : l10n.chatMute,
      ),
      secondaryBackground: canArchive
          ? _SwipeBackground(
              alignment: AlignmentDirectional.centerEnd,
              icon: c.archived
                  ? Icons.unarchive_outlined
                  : Icons.archive_outlined,
              label: c.archived ? l10n.chatUnarchive : l10n.chatArchive,
            )
          : null,
      // Never actually dismisses: the row snaps back and the cubit's next
      // state moves it (or flips its muted icon). That way a failed request
      // can't leave a row missing from the list.
      confirmDismiss: (direction) async {
        final cubit = context.read<ChatsListCubit>();
        final messenger = ScaffoldMessenger.of(context);
        unawaited(
          _togglePref(
            cubit,
            messenger,
            c,
            mute: direction == DismissDirection.startToEnd,
          ),
        );
        return false;
      },
      child: tile,
    );
  }
}

/// The last thing said, the way every other chat app does it — a status
/// line told you about a session, which is not what someone scanning their
/// chats is looking for. Falls back to a status line only when nothing has
/// been said yet.
String _previewText(AppLocalizations l10n, Conversation c) {
  final last = c.lastMessage;
  if (last == null || last.body.isEmpty) {
    return switch (c.window.reason) {
      'consultation' => l10n.chatsStatusLive,
      // NOTE: the 0 is the minutes argument and is hard-coded; see notes.
      'follow_up' => l10n.chatsStatusEnded(0),
      _ => l10n.chatsStatusGeneric,
    };
  }
  return last.isMine ? l10n.chatsLastMessageMine(last.body) : last.body;
}

/// Peer avatar with cached-image loading and a graceful initial fallback.
class _Avatar extends StatelessWidget {
  const _Avatar({
    required this.name,
    required this.url,
    required this.scheme,
  });

  final String name;
  final String? url;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    final hasUrl = url != null && url!.isNotEmpty;
    final trimmed = name.trim();
    final initial = Text(
      trimmed.isEmpty ? '★' : trimmed.characters.first.toUpperCase(),
      style: TextStyle(
        color: scheme.onPrimaryContainer,
        fontWeight: FontWeight.w700,
        fontSize: 16,
      ),
    );

    if (!hasUrl) {
      return CircleAvatar(
        radius: 20,
        backgroundColor: scheme.primaryContainer,
        child: initial,
      );
    }

    return SizedBox(
      width: 40,
      height: 40,
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: url!,
          fit: BoxFit.cover,
          placeholder: (_, _) => CircleAvatar(
            backgroundColor: scheme.primaryContainer,
            child: initial,
          ),
          errorWidget: (_, _, _) => CircleAvatar(
            backgroundColor: scheme.primaryContainer,
            child: initial,
          ),
        ),
      ),
    );
  }
}

class _ChatsListSkeleton extends StatelessWidget {
  const _ChatsListSkeleton();

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 8,
        separatorBuilder: (_, _) => const SizedBox(height: 4),
        itemBuilder: (_, _) => const _ChatTileSkeleton(),
      ),
    );
  }
}

class _ChatTileSkeleton extends StatelessWidget {
  const _ChatTileSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          SkeletonBox(width: 40, height: 40, radius: 20),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SkeletonBox(width: 130, height: 14, radius: 4),
                SizedBox(height: 8),
                SkeletonBox(width: 210, height: 12, radius: 4),
              ],
            ),
          ),
          SizedBox(width: 12),
          SkeletonBox(width: 16, height: 16, radius: 4),
        ],
      ),
    );
  }
}
