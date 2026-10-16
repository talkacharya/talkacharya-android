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
import '../../../shared/widgets/settings_widgets.dart';
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

/// The free, text-only chats customers started from this astrologer's
/// profile — the ones waiting on a reply marked.
class AssistantInboxPage extends StatefulWidget {
  const AssistantInboxPage({super.key});

  @override
  State<AssistantInboxPage> createState() => _AssistantInboxPageState();
}

class _AssistantInboxPageState extends State<AssistantInboxPage> {
  final _api = getIt<AssistantApi>();
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
      final rows = await _api.threads();
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
    final waiting = threads?.where((t) => t.awaitingYou).length ?? 0;
    return SubPageScaffold(
      title: l.assistantTitle,
      subtitle: waiting > 0
          ? l.assistantWaitingCount(waiting)
          : l.assistantInboxSubtitle,
      onRefresh: _load,
      children: [
        if (threads == null && _error == null)
          const Padding(
            padding: EdgeInsets.all(48),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (threads == null)
          ErrorView(message: _error!, onRetry: _load)
        else if (threads.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 32),
            child: EmptyState(
              icon: Icons.forum_rounded,
              title: l.assistantInboxEmptyTitle,
              message: l.assistantInboxEmptyBody,
            ),
          )
        else
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                for (var i = 0; i < threads.length; i++) ...[
                  if (i > 0)
                    Divider(
                      height: 1,
                      indent: 76,
                      color: context.brand.hairline,
                    ),
                  AssistantThreadTile(
                    thread: threads[i],
                    youPrefix: l.assistantYouPrefix,
                    onTap: () async {
                      await context.push(Routes.assistantRoom(threads[i].id));
                      unawaited(_load());
                    },
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }
}

/// One customer's assistant chat, answered by the astrologer.
class AssistantRoomPage extends StatefulWidget {
  const AssistantRoomPage({required this.threadId, super.key});

  final String threadId;

  @override
  State<AssistantRoomPage> createState() => _AssistantRoomPageState();
}

class _AssistantRoomPageState extends State<AssistantRoomPage> {
  late final AssistantRoomController _controller;

  @override
  void initState() {
    super.initState();
    final api = getIt<AssistantApi>();
    final id = widget.threadId;
    _controller = AssistantRoomController(
      myRole: 'astrologer',
      load: () => api.thread(id),
      loadAfter: (after) => api.messages(id, after: after),
      loadBefore: (before) => api.messages(id, before: before),
      send: (body) => api.send(id, body),
      incoming: assistantIncoming(),
      store: assistantStore(),
      threadId: id,
    )..start();
    AssistantPresence.opened(id);
  }

  @override
  void dispose() {
    AssistantPresence.closed(widget.threadId);
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
            builder: (context, _) => AssistantRoomHeader(
              name: _controller.thread?.otherName ?? '',
              avatar: _controller.thread?.otherAvatar,
              subtitle: l.assistantRoomSubtitleAstro,
            ),
          ),
          Expanded(
            child: AssistantRoomView(
              controller: _controller,
              errorText: (e) => friendlyError(e),
              labels: AssistantLabels(
                hint: l.assistantHintAstro,
                emptyTitle: l.assistantEmptyTitleAstro,
                emptyBody: l.assistantEmptyBodyAstro,
                waitForReply: l.assistantWaitForReply,
                blocked: l.assistantBlocked,
                disabled: l.assistantDisabled,
                notSent: l.assistantNotSent,
                retry: l.assistantRetry,
                discard: l.assistantDiscard,
                today: l.assistantToday,
                yesterday: l.assistantYesterday,
                loadFailed: l.commonLoadFailed,
                tryAgain: l.assistantRetry,
                intro: l.assistantIntroAstro,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
