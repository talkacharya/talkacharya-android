import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:talkacharya_call/talkacharya_call.dart';
import 'package:talkacharya_chat/talkacharya_chat.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/realtime/realtime_client.dart';
import '../../../../core/router/routes.dart';
import '../../../auth/presentation/bloc/auth/auth_bloc.dart';
import '../../data/call_adapters.dart';
import '../../data/chat_adapters.dart';
import '../../data/consultation_api.dart';
import '../../data/models/consultation.dart';
import '../cubit/chat_cubit.dart';

/// The astrologer's consultation room: the shared chat engine + a shell for
/// billing, the client's kundali, and ending the session.
class ConsultationRoomPage extends StatelessWidget {
  const ConsultationRoomPage({required this.consultationId, super.key});
  final String consultationId;

  @override
  Widget build(BuildContext context) {
    final user = getIt<AuthBloc>().state.user;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ChatCubit(
            api: getIt<ConsultationApi>(),
            realtime: getIt<RealtimeClient>(),
            consultationId: consultationId,
          )..init(),
        ),
        BlocProvider(
          create: (_) => ChatController(
            consultationId: consultationId,
            transport: DioChatTransport(getIt(), consultationId),
            realtime: RealtimeChatAdapter(getIt<RealtimeClient>()),
            identity: AstrologerChatIdentity(
              userId: user?.id ?? '',
              language: user?.preferredLanguage ?? 'en',
            ),
            pickImages: pickChatImages,
            outbox: SecureStorageChatOutbox(getIt()),
          )..start(),
        ),
      ],
      child: const _RoomView(),
    );
  }
}

class _RoomView extends StatelessWidget {
  const _RoomView();

  void _viewKundali(BuildContext context) {
    final state = context.read<ChatCubit>().state;
    context.push(
      Routes.consultationKundali(context.read<ChatCubit>().consultationId),
      extra: state.consultation?.customerName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        final c = state.consultation;
        if (state.loading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (c != null && c.isEnded) return _Summary(c);
        if (c != null && c.isCall) {
          if (c.isTerminal) return _Summary(c);
          return _AstroCallRoom(
            consultation: c,
            clientLowBalance: state.clientLowBalance,
          );
        }

        return Scaffold(
          appBar: AppBar(
            titleSpacing: 0,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  c?.customerName ?? 'Consultation',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const ChatHeaderStatus(),
              ],
            ),
            actions: [
              _AutoTranslateToggle(),
              IconButton(
                icon: const Icon(Icons.auto_awesome_rounded),
                tooltip: 'Client kundali',
                onPressed: () => _viewKundali(context),
              ),
              if (c != null && c.isLive)
                TextButton(
                  onPressed: () => context.read<ChatCubit>().endConsultation(),
                  child: const Text('End'),
                ),
            ],
          ),
          body: Column(
            children: [
              if (c != null && c.isLive)
                _BillingHud(
                  minutes: c.billedMinutes,
                  earned: c.astrologerAmount,
                  currency: c.currency,
                  clientLowBalance: state.clientLowBalance,
                ),
              Expanded(child: ChatView(composerEnabled: c?.isLive ?? false)),
            ],
          ),
        );
      },
    );
  }
}

/// Voice consultation for the astrologer: the shared self-hosted WebRTC call
/// screen with earnings + the client's low-balance warning on top.
class _AstroCallRoom extends StatefulWidget {
  const _AstroCallRoom({
    required this.consultation,
    required this.clientLowBalance,
  });
  final Consultation consultation;
  final bool clientLowBalance;

  @override
  State<_AstroCallRoom> createState() => _AstroCallRoomState();
}

class _AstroCallRoomState extends State<_AstroCallRoom> {
  late final CallController _call;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<ChatCubit>();
    _call = CallController(
      backend: DioCallBackend(
        getIt(),
        widget.consultation.id,
        onEnd: cubit.endConsultation,
      ),
      signaling: RealtimeCallSignaling(getIt<RealtimeClient>()),
      engine: FlutterWebRtcEngine(),
      permissions: const PermissionHandlerCallPermissions(),
      keepAlive: ForegroundServiceCallKeepAlive(),
      keepAliveTitle: 'TalkAcharya Astrologer',
    );
    _maybeStart();
  }

  @override
  void didUpdateWidget(covariant _AstroCallRoom old) {
    super.didUpdateWidget(old);
    _maybeStart();
  }

  void _maybeStart() {
    if (widget.consultation.isLive && _call.state.phase == CallPhase.idle) {
      _call.start();
    }
  }

  @override
  void dispose() {
    _call.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.consultation;
    return BlocProvider.value(
      value: _call,
      child: CallScreen(
        peerName: c.customerName,
        accent: const Color(0xFF8B8CFF),
        strings: const CallStrings(
          endConfirmBody: 'The client stops being billed when the call ends.',
        ),
        top: c.status == 'active'
            ? ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: _BillingHud(
                  minutes: c.billedMinutes,
                  earned: c.astrologerAmount,
                  currency: c.currency,
                  clientLowBalance: widget.clientLowBalance,
                ),
              )
            : null,
        onEnded: () => context.read<ChatCubit>().refresh(),
      ),
    );
  }
}

class _AutoTranslateToggle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatController, ChatSessionState>(
      buildWhen: (a, b) => a.autoTranslate != b.autoTranslate,
      builder: (context, state) => IconButton(
        tooltip: 'Auto-translate',
        icon: Icon(
          state.autoTranslate
              ? Icons.translate_rounded
              : Icons.translate_outlined,
          color: state.autoTranslate
              ? Theme.of(context).colorScheme.primary
              : null,
        ),
        onPressed: () => context.read<ChatController>().setAutoTranslate(
          !state.autoTranslate,
        ),
      ),
    );
  }
}

class _BillingHud extends StatelessWidget {
  const _BillingHud({
    required this.minutes,
    required this.earned,
    required this.currency,
    this.clientLowBalance = false,
  });
  final int minutes;
  final String earned;
  final String currency;
  final bool clientLowBalance;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Container(
          width: double.infinity,
          color: scheme.primaryContainer,
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
          child: Text(
            '$minutes min · earned $currency $earned',
            textAlign: TextAlign.center,
          ),
        ),
        if (clientLowBalance)
          Container(
            width: double.infinity,
            color: scheme.errorContainer,
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  size: 15,
                  color: scheme.onErrorContainer,
                ),
                const SizedBox(width: 6),
                Text(
                  "Client's balance is low — wrap up soon",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: scheme.onErrorContainer,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary(this.c);
  final dynamic c;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Consultation')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Icon(Icons.check_circle_outline_rounded, size: 56),
          const SizedBox(height: 12),
          Center(
            child: Text(
              'Consultation ended',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          const SizedBox(height: 24),
          _row(context, 'Billed', '${c.billedMinutes} min'),
          _row(context, 'Rate', '${c.currency} ${c.rateSnapshot}/min'),
          _row(context, 'You earned', '${c.currency} ${c.astrologerAmount}'),
        ],
      ),
    );
  }

  Widget _row(BuildContext context, String k, String v) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        Expanded(
          child: Text(
            k,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Text(v),
      ],
    ),
  );
}
