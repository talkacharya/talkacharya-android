import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:talkacharya_assistant/talkacharya_assistant.dart';
import 'package:talkacharya_ui/talkacharya_ui.dart';

import '../../../core/di/service_locator.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/network/friendly_error.dart';
import '../../../core/realtime/realtime_client.dart';
import '../../../core/realtime/realtime_event.dart';
import '../../../core/router/routes.dart';
import '../../auth/presentation/bloc/auth/auth_bloc.dart';
import '../data/assistant_api.dart';

/// This account's assistant chats, kept on the phone — the server only
/// carries messages across and drops its copy after a few days.
AssistantStore assistantStore() => DeferredAssistantStore(() async {
  final id = getIt<AuthBloc>().state.user?.id;
  if (id == null || id.isEmpty) return MemoryAssistantStore();
  return SqliteAssistantStore.forUser(id);
});

/// Assistant frames on this person's channel, parsed.
Stream<AssistantIncoming> assistantIncoming() => getIt<RealtimeClient>().events
    .where((e) => e is AssistantFrame)
    .map((e) => AssistantIncoming.fromFrameData((e as AssistantFrame).data))
    .where((e) => e != null)
    .cast<AssistantIncoming>();

/// Every assistant chat this customer has, latest first.
class AssistantInboxPage extends StatefulWidget {
  const AssistantInboxPage({super.key});

  @override
  State<AssistantInboxPage> createState() => _AssistantInboxPageState();
}

class _AssistantInboxPageState extends State<AssistantInboxPage> {
  List<AssistantThread>? _threads;
  String? _error;
  StreamSubscription<AssistantIncoming>? _sub;

  @override
  void initState() {
    super.initState();
    _load();
    _sub = assistantIncoming().listen((_) => _load());
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final rows = await getIt<AssistantApi>().threads();
      if (mounted) {
        setState(() {
          _threads = rows;
          _error = null;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _error = friendlyError(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final threads = _threads;
    final Widget body;
    if (threads == null && _error == null) {
      body = const Center(child: CircularProgressIndicator());
    } else if (threads == null) {
      body = ErrorView(message: _error!, onRetry: _load);
    } else if (threads.isEmpty) {
      body = EmptyState(
        icon: Icons.forum_rounded,
        title: l.assistantInboxEmptyTitle,
        message: l.assistantInboxEmptyBody,
      );
    } else {
      body = RefreshIndicator(
        onRefresh: _load,
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: threads.length,
          separatorBuilder: (_, _) =>
              Divider(height: 1, indent: 76, color: context.brand.hairline),
          itemBuilder: (context, i) => AssistantThreadTile(
            thread: threads[i],
            youPrefix: l.assistantYouPrefix,
            onTap: () async {
              await context.push(Routes.assistantRoom(threads[i].id));
              unawaited(_load());
            },
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text(l.assistantTitle)),
      body: body,
    );
  }
}

/// A free, text-only chat with one astrologer. Opened either on a thread, or
/// on an astrologer (from their profile), in which case the thread is made
/// the first time.
class AssistantRoomPage extends StatefulWidget {
  const AssistantRoomPage({this.threadId, this.astrologerId, super.key})
    : assert(threadId != null || astrologerId != null);

  final String? threadId;
  final String? astrologerId;

  @override
  State<AssistantRoomPage> createState() => _AssistantRoomPageState();
}

class _AssistantRoomPageState extends State<AssistantRoomPage> {
  late final AssistantRoomController _controller;
  String? _threadId;

  @override
  void initState() {
    super.initState();
    final api = getIt<AssistantApi>();
    _threadId = widget.threadId;
    if (_threadId != null) AssistantPresence.opened(_threadId!);
    _controller = AssistantRoomController(
      myRole: 'customer',
      load: () async {
        final id = _threadId;
        final d = id == null
            ? await api.open(widget.astrologerId!)
            : await api.thread(id);
        if (_threadId == null) {
          _threadId = d.thread.id;
          AssistantPresence.opened(d.thread.id);
        }
        return d;
      },
      loadAfter: (after) => api.messages(_threadId!, after: after),
      loadBefore: (before) => api.messages(_threadId!, before: before),
      send: (body) => api.send(_threadId!, body),
      incoming: assistantIncoming(),
      store: assistantStore(),
      threadId: widget.threadId,
    )..start();
  }

  @override
  void dispose() {
    final id = _threadId;
    if (id != null) AssistantPresence.closed(id);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      backgroundColor: context.brand.canvas,
      body: Column(
        children: [
          ListenableBuilder(
            listenable: _controller,
            builder: (context, _) {
              final t = _controller.thread;
              return AssistantRoomHeader(
                name: t?.otherName ?? '',
                avatar: t?.otherAvatar,
                subtitle: l.assistantRoomSubtitle,
                onTapName: t == null || t.otherId.isEmpty
                    ? null
                    : () => context.push(Routes.astrologer(t.otherId)),
              );
            },
          ),
          Expanded(
            child: AssistantRoomView(
              controller: _controller,
              errorText: (e) => friendlyError(e),
              labels: AssistantLabels(
                hint: l.assistantHint,
                emptyTitle: l.assistantEmptyTitle,
                emptyBody: l.assistantEmptyBody,
                waitForReply: l.assistantWaitForReply,
                blocked: l.assistantBlocked,
                disabled: l.assistantDisabled,
                notSent: l.assistantNotSent,
                retry: l.assistantRetry,
                discard: l.assistantDiscard,
                today: l.assistantToday,
                yesterday: l.assistantYesterday,
                loadFailed: l.assistantLoadFailed,
                tryAgain: l.assistantRetry,
                intro: l.assistantIntro,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
