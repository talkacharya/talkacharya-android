import 'dart:async';

import 'package:share_plus/share_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:talkacharya_call/talkacharya_call.dart';
import 'package:talkacharya_chat/talkacharya_chat.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/realtime/realtime_client.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/util/money.dart';
import '../../../../core/sounds/app_sound_adapters.dart';
import '../../../../shared/widgets/settings_widgets.dart';
import '../../../auth/presentation/bloc/auth/auth_bloc.dart';
import '../widgets/astro_thread_card.dart';
import '../../data/call_adapters.dart';
import '../../data/chat_adapters.dart';
import '../../data/consultation_api.dart';
import '../../data/models/consultation.dart';
import '../../data/models/conversation.dart';
import '../cubit/chat_cubit.dart';
import '../room_presence.dart';
import '../widgets/consultation_style.dart';
import '../widgets/call_chart_panel.dart';
import '../widgets/quick_replies.dart';
import '../widgets/chat_room_skeleton.dart';

import 'package:talkacharya_ui/talkacharya_ui.dart';
part 'consultation_room_chat.dart';
part 'consultation_room_call.dart';

/// The astrologer's consultation room: the shared chat engine (or the shared
/// call screen) inside an astrologer shell — live session bar, the customer's
/// question, kundali, and ending the session.
class ConsultationRoomPage extends StatefulWidget {
  const ConsultationRoomPage({required this.consultationId, super.key});

  /// Either id: a push or a deep link carries a consultation's, the Chats tab
  /// carries the thread's.
  final String consultationId;

  @override
  State<ConsultationRoomPage> createState() => _ConsultationRoomPageState();
}

class _ConsultationRoomPageState extends State<ConsultationRoomPage> {
  late Future<Conversation> _thread = _resolve();

  Future<Conversation> _resolve() =>
      getIt<ConsultationApi>().conversation(widget.consultationId);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Conversation>(
      future: _thread,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: ChatRoomSkeleton()),
          );
        }
        final thread = snap.data;
        if (thread == null) {
          return Scaffold(
            appBar: AppBar(),
            body: ErrorView(
              message: context.l10n.roomLoadError,
              onRetry: () => setState(() => _thread = _resolve()),
            ),
          );
        }
        return _RoomScope(threadId: thread.id);
      },
    );
  }
}

/// Everything below is keyed on the thread: the chat engine, its realtime
/// channel and the outbox all outlive the session running inside it.
class _RoomScope extends StatelessWidget {
  const _RoomScope({required this.threadId});

  final String threadId;

  @override
  Widget build(BuildContext context) {
    final user = getIt<AuthBloc>().state.user;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ChatCubit(
            api: getIt<ConsultationApi>(),
            realtime: getIt<RealtimeClient>(),
            threadId: threadId,
          )..init(),
        ),
        BlocProvider(
          create: (_) => ChatController(
            threadId: threadId,
            transport: DioChatTransport(getIt(), threadId),
            realtime: RealtimeChatAdapter(getIt<RealtimeClient>()),
            identity: AstrologerChatIdentity(
              userId: user?.id ?? '',
              language: user?.preferredLanguage ?? 'en',
            ),
            pickImages: pickChatImages,
            outbox: SecureStorageChatOutbox(getIt()),
            sounds: const AppChatSounds(),
            recorder: DeviceVoiceRecorder(),
            voicePlayer: DeviceVoicePlayer(),
            media: getIt<ChatMediaStore>(),
          )..start(),
        ),
      ],
      child: _PresenceScope(consultationId: threadId, child: const _RoomView()),
    );
  }
}

/// Tells [RoomPresence] this room is on screen (hides the "live session"
/// banner, and keeps deep links from tearing a call down).
class _PresenceScope extends StatefulWidget {
  const _PresenceScope({required this.consultationId, required this.child});

  final String consultationId;
  final Widget child;

  @override
  State<_PresenceScope> createState() => _PresenceScopeState();
}

class _PresenceScopeState extends State<_PresenceScope> {
  RoomPresence get _presence => getIt<RoomPresence>();

  // `opened` and `closed` notify their listeners, and both of these run
  // inside a build phase — initState during the parent's, dispose during the
  // unmount. The live-session banner listens from above, so notifying here
  // marks an already-built ancestor dirty and Flutter drops the rebuild.
  @override
  void initState() {
    super.initState();
    final id = widget.consultationId;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _presence.opened(id, isCall: false);
    });
  }

  @override
  void dispose() {
    final id = widget.consultationId;
    final presence = _presence;
    // Not guarded on `mounted` — this one has to happen precisely because the
    // room is going away. `closed` ignores an id that is no longer the open
    // one, so a room opened in the meantime is safe.
    WidgetsBinding.instance.addPostFrameCallback((_) => presence.closed(id));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final session = context.select((ChatCubit c) => c.state.consultation);
    final live = context.select((ChatCubit c) => c.state.window).consultationId;
    // After the frame, never during it: `opened` notifies its listeners, and
    // the live-session banner listening from above would be marked dirty
    // mid-build. Flutter logs that and skips the rebuild, so the banner keeps
    // showing a session you are already looking at.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _presence.opened(
        widget.consultationId,
        isCall: session?.isCall ?? false,
        consultationId: live ?? session?.id,
      );
    });
    return widget.child;
  }
}

/// Asks before ending; returns true once the session is ended.
Future<bool> confirmEndConsultation(BuildContext context) async {
  final l = context.l10n;
  final cubit = context.read<ChatCubit>();
  final ok = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l.roomEndTitle),
      content: Text(l.roomEndBody),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(l.commonCancel),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: context.brand.live,
            minimumSize: const Size(0, 44),
          ),
          onPressed: () => Navigator.pop(context, true),
          child: Text(l.roomEnd),
        ),
      ],
    ),
  );
  if (ok != true) return false;
  final ended = await cubit.endConsultation();
  if (!ended && context.mounted) showToast(context, l.roomEndFailed);
  return ended;
}

