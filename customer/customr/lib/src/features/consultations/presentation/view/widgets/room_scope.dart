import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talkacharya_call/talkacharya_call.dart';
import 'package:talkacharya_chat/talkacharya_chat.dart';
import 'package:talkacharya_chat_store/talkacharya_chat_store.dart';

import '../../../../../core/di/service_locator.dart';
import '../../../../../core/l10n/l10n.dart';
import '../../../../../core/realtime/realtime_client.dart';
import '../../../../../core/sounds/app_sound_adapters.dart';
import '../../../../auth/presentation/bloc/auth/auth_bloc.dart';
import '../../../data/chat_adapters.dart';
import '../../../data/consultation_repository.dart';
import '../../cubit/chat_cubit.dart';
import '../../room_presence.dart';
import 'call_room.dart';
import 'chat_shell.dart';

import 'package:talkacharya_ui/talkacharya_ui.dart';
import 'chat_room_skeleton.dart';
class RoomScope extends StatelessWidget {
  const RoomScope({required this.threadId, super.key});

  final String threadId;

  @override
  Widget build(BuildContext context) {
    final user = getIt<AuthBloc>().state.user;
    final consultationId = threadId;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ChatCubit(
            repo: getIt<ConsultationRepository>(),
            realtime: getIt<
                RealtimeClient>(),
            consultationId: consultationId,
          )..init(),
        ),
        BlocProvider(
          create: (_) => ChatController(
            threadId: consultationId,
            transport: DioChatTransport(getIt(), consultationId),
            realtime: RealtimeChatAdapter(getIt<RealtimeClient>()),
            identity: CustomerChatIdentity(
              userId: user?.id ?? '',
              language: user?.preferredLanguage ?? 'en',
            ),
            pickImages: pickChatImages,
            outbox: SecureStorageChatOutbox(getIt()),
            store: getIt<FloorChatStore>(),
            sounds: const AppChatSounds(),
            // No recorder: a customer writes and sends photos, but does not
            // send voice messages. The player stays, so the astrologer's
            // voice messages can still be heard.
            voicePlayer: DeviceVoicePlayer(),
            media: getIt<ChatMediaStore>(),
          )..start(),
        ),
      ],
      child: PresenceScope(
        consultationId: consultationId,
        child: const RoomView(),
      ),
    );
  }
}

/// Tells [RoomPresence] this room is on screen, so the app-wide "live
/// consultation" banner hides and deep links don't tear a call down.
class PresenceScope extends StatefulWidget {
  const PresenceScope({required this.consultationId, required this.child, super.key});

  final String consultationId;
  final Widget child;

  @override
  State<PresenceScope> createState() => _PresenceScopeState();
}

class _PresenceScopeState extends State<PresenceScope> {
  RoomPresence get _presence => getIt<RoomPresence>();

  // What was last reported, so a rebuild that changes nothing schedules
  // nothing.
  bool? _lastIsCall;
  String? _lastLive;

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
    final live = context
        .select((ChatCubit c) => c.state.window)
        .consultationId;
    final isCall = session != null && session.channel != 'chat';
    final liveId = live ?? session?.id;

    // Only when something actually changed — and after the frame, never
    // during it: `opened` notifies its listeners, and the live-session banner
    // listening from above would be marked dirty mid-build. Flutter logs that
    // and skips the rebuild, so the banner keeps showing a session you are
    // already looking at.
    if (_lastIsCall != isCall || _lastLive != liveId) {
      _lastIsCall = isCall;
      _lastLive = liveId;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _presence.opened(
          widget.consultationId,
          isCall: isCall,
          consultationId: liveId,
        );
      });
    }
    return widget.child;
  }
}

class RoomView extends StatelessWidget {
  const RoomView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit, ChatState>(
      listenWhen: (a, b) =>
          (a.error != b.error && b.error != null) ||
          (a.consultation?.status != b.consultation?.status),
      listener: (context, state) {
        if (state.error != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.error!),
                behavior: SnackBarBehavior.floating,
              ),
            );
        }
        final c = state.consultation;
        if (c != null && c.status.isTerminal) {
          final hub = getIt<CallHub>();
          if (hub.isFor(c.id)) {
            unawaited(hub.release());
          }
        }
      },
      builder: (context, state) {
        // Loading covers both requests now — the thread and the session in
        // it — so the room never renders its failure while one is in flight.
        if (state.loading && state.consultation == null) {
          return const Scaffold(
            body: Center(child: ChatRoomSkeleton()),
          );
        }
        final c = state.consultation;
        if (c == null) {
          return Scaffold(
            appBar: AppBar(),
            body: ErrorView(
              message: state.error ?? context.l10n.roomOpenError,
              onRetry: () => context.read<ChatCubit>().init(),
            ),
          );
        }
        // A finished session — ended, declined, missed, cancelled, a chat or a
        // call — keeps the room. The thread is permanent: it says what happened
        // in its own lines, and the card at the end of it carries the rating
        // and the way to start again. A separate summary screen used to
        // replace all of that, and hid the conversation behind a receipt.
        if (c.status.isTerminal) {
          return ChatShell(consultation: c, lowBalance: state.lowBalance);
        }
        if (c.channel != 'chat') {
          // When the call is minimized (hub.expanded == false) switch to the
          // chat shell so the user sees the conversation thread — the mini-bar
          // at the top lets them tap back into the call. When expanded again,
          // this builder re-runs and returns CallRoom.
          final hub = getIt<CallHub>();
          return ListenableBuilder(
            listenable: hub,
            builder: (context, _) {
              if (!hub.expanded && hub.isFor(c.id)) {
                return ChatShell(consultation: c, lowBalance: state.lowBalance);
              }
              return CallRoom(consultation: c, lowBalance: state.lowBalance);
            },
          );
        }
        return ChatShell(consultation: c, lowBalance: state.lowBalance);
      },
    );
  }
}
