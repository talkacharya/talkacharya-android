import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:talkacharya_call/talkacharya_call.dart';
import 'package:talkacharya_chat/talkacharya_chat.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/realtime/realtime_client.dart';
import '../../../../core/router/routes.dart';
import '../../../../features/auth/presentation/bloc/auth/auth_bloc.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../gifting/data/models/gift.dart';
import '../../../gifting/presentation/view/gift_sheet.dart';
import '../../../gifting/presentation/widgets/gift_prompt_card.dart';
import '../../../wallet/presentation/view/recharge_sheet.dart';
import '../../data/call_adapters.dart';
import '../../data/chat_adapters.dart';
import '../../data/consultation_repository.dart';
import '../../data/models/consultation.dart';
import '../cubit/chat_cubit.dart';
import 'book_consultation_sheet.dart';
import 'widgets/billing_hud.dart';

/// One route (`/consultations/:id`) that renders whichever face the consultation
/// is in: waiting for accept → live chat → ended summary. The live chat surface
/// is the shared `talkacharya_chat` engine; this page owns the shell (billing,
/// status, end/review).
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
            repo: getIt<ConsultationRepository>(),
            realtime: getIt<RealtimeClient>(),
            consultationId: consultationId,
          )..init(),
        ),
        BlocProvider(
          create: (_) => ChatController(
            consultationId: consultationId,
            transport: DioChatTransport(getIt(), consultationId),
            realtime: RealtimeChatAdapter(getIt<RealtimeClient>()),
            identity: CustomerChatIdentity(
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

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit, ChatState>(
      listenWhen: (a, b) => a.error != b.error && b.error != null,
      listener: (context, state) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(state.error!),
              behavior: SnackBarBehavior.floating,
            ),
          );
      },
      builder: (context, state) {
        if (state.loading && state.consultation == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
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
        if (c.status.isTerminal) return _SummaryView(consultation: c);
        if (c.channel != 'chat') {
          return _CallRoom(consultation: c, lowBalance: state.lowBalance);
        }
        if (c.status == ConsultationStatus.requested) {
          return _WaitingView(consultation: c);
        }
        return _ChatShell(consultation: c, lowBalance: state.lowBalance);
      },
    );
  }
}

// --- waiting -------------------------------------------------------------

class _WaitingView extends StatelessWidget {
  const _WaitingView({required this.consultation});
  final Consultation consultation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 46,
                height: 46,
                child: CircularProgressIndicator(strokeWidth: 3),
              ),
              const SizedBox(height: 24),
              Text(
                l10n.roomWaitingTitle(consultation.astrologerName),
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.roomWaitingBody,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 28),
              OutlinedButton(
                onPressed: () async {
                  await context.read<ChatCubit>().cancelRequest();
                  if (context.mounted) context.pop();
                },
                child: Text(l10n.roomCancelRequest),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- voice call -----------------------------------------------------------

/// Voice consultation: one full-screen call surface from "waiting for accept"
/// through ringing, the live call (with the billing HUD) to hang-up. Media is
/// self-hosted WebRTC (`package:talkacharya_call`); the room owns the lifecycle.
class _CallRoom extends StatefulWidget {
  const _CallRoom({required this.consultation, required this.lowBalance});
  final Consultation consultation;
  final bool lowBalance;

  @override
  State<_CallRoom> createState() => _CallRoomState();
}

class _CallRoomState extends State<_CallRoom> {
  late final CallController _call;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<ChatCubit>();
    _call = CallController(
      backend: DioCallBackend(
        getIt(),
        widget.consultation.id,
        onEnd: () => cubit.state.status == ConsultationStatus.requested
            ? cubit.cancelRequest()
            : cubit.endConsultation(),
      ),
      signaling: RealtimeCallSignaling(getIt<RealtimeClient>()),
      engine: FlutterWebRtcEngine(),
      permissions: const PermissionHandlerCallPermissions(),
      keepAlive: ForegroundServiceCallKeepAlive(),
      keepAliveTitle: 'TalkAcharya',
    );
    _maybeStart();
  }

  @override
  void didUpdateWidget(covariant _CallRoom old) {
    super.didUpdateWidget(old);
    _maybeStart();
  }

  void _maybeStart() {
    final s = widget.consultation.status;
    final joinable =
        s == ConsultationStatus.accepted || s == ConsultationStatus.active;
    if (joinable && _call.state.phase == CallPhase.idle) _call.start();
  }

  @override
  void dispose() {
    _call.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = widget.consultation;
    final waiting = c.status == ConsultationStatus.requested;
    return BlocProvider.value(
      value: _call,
      child: CallScreen(
        peerName: c.astrologerName,
        peerAvatarUrl: c.astrologerAvatar,
        strings: callStrings(l),
        statusOverride: waiting ? l.callWaitingAccept(c.astrologerName) : null,
        top: c.status == ConsultationStatus.active
            ? ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: BillingHud(
                  consultation: c,
                  lowBalance: widget.lowBalance,
                  onRecharge: () => showRechargeSheet(context),
                ),
              )
            : null,
        onEnded: () => context.read<ChatCubit>().refresh(),
      ),
    );
  }
}

/// Localised copy for the shared call screen.
CallStrings callStrings(AppLocalizations l) => CallStrings(
  calling: l.callCalling,
  ringing: l.callRinging,
  connecting: l.callConnecting,
  reconnecting: l.callReconnecting,
  callEnded: l.callEnded,
  poorConnection: l.callPoorConnection,
  mute: l.callMute,
  speaker: l.callSpeaker,
  endCall: l.callEnd,
  encrypted: l.callEncrypted,
  micTitle: l.callMicTitle,
  micBody: l.callMicBody,
  micBlockedBody: l.callMicBlockedBody,
  openSettings: l.callOpenSettings,
  tryAgain: l.callTryAgain,
  failedTitle: l.callFailedTitle,
  endConfirmTitle: l.callEndConfirmTitle,
  endConfirmBody: l.callEndConfirmBody,
  endConfirmYes: l.callEndConfirmYes,
  endConfirmNo: l.callEndConfirmNo,
);

// --- chat ---------------------------------------------------------------

class _ChatShell extends StatelessWidget {
  const _ChatShell({required this.consultation, required this.lowBalance});
  final Consultation consultation;
  final bool lowBalance;

  Future<void> _confirmEnd(BuildContext context) async {
    final l10n = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.roomEndConfirmTitle),
        content: Text(l10n.roomEndConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n.roomKeepTalking),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(l10n.roomEnd),
          ),
        ],
      ),
    );
    if ((ok ?? false) && context.mounted) {
      await context.read<ChatCubit>().endConsultation();
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = consultation;
    final canChat = c.status.canChat;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: scheme.primaryContainer,
              foregroundImage:
                  (c.astrologerAvatar != null && c.astrologerAvatar!.isNotEmpty)
                  ? NetworkImage(c.astrologerAvatar!)
                  : null,
              child: (c.astrologerAvatar == null || c.astrologerAvatar!.isEmpty)
                  ? Text(
                      c.astrologerName.isEmpty
                          ? '★'
                          : c.astrologerName.characters.first.toUpperCase(),
                      style: TextStyle(
                        color: scheme.onPrimaryContainer,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    c.astrologerName,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const ChatHeaderStatus(),
                ],
              ),
            ),
            _AutoTranslateToggle(),
          ],
        ),
        actions: [
          IconButton(
            tooltip: context.l10n.giftAction,
            icon: const Icon(Icons.card_giftcard_rounded),
            onPressed: canChat
                ? () => showGiftSheet(
                    context,
                    target: ConsultationGiftTarget(
                      consultationId: c.id,
                      astrologerName: c.astrologerName,
                      currency: c.currency,
                    ),
                  )
                : null,
          ),
          TextButton(
            onPressed: () => _confirmEnd(context),
            child: Text(context.l10n.roomEnd),
          ),
        ],
      ),
      body: Column(
        children: [
          BillingHud(
            consultation: c,
            lowBalance: lowBalance,
            onRecharge: () => showRechargeSheet(context),
          ),
          Expanded(child: ChatView(composerEnabled: canChat)),
        ],
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
        tooltip: state.autoTranslate
            ? context.l10n.roomAutoTranslateOn
            : context.l10n.roomAutoTranslateOff,
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

// --- summary ----------------------------------------------------------

class _SummaryView extends StatefulWidget {
  const _SummaryView({required this.consultation});
  final Consultation consultation;

  @override
  State<_SummaryView> createState() => _SummaryViewState();
}

class _SummaryViewState extends State<_SummaryView> {
  int _rating = 0;
  bool _submitted = false;

  @override
  Widget build(BuildContext context) {
    final c = widget.consultation;
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final ended = c.status == ConsultationStatus.ended;
    final ranOut = ended && c.endReason == 'balance_exhausted';
    return Scaffold(
      appBar: AppBar(title: Text(l10n.roomAppBarTitle)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Icon(
            ranOut
                ? Icons.account_balance_wallet_outlined
                : (ended ? Icons.check_circle_rounded : Icons.info_rounded),
            size: 48,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 12),
          Text(
            ranOut
                ? l10n.roomBalanceOutTitle
                : (ended ? l10n.roomEndedTitle : _statusLine(l10n, c.status)),
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge,
          ),
          if (ranOut) ...[
            const SizedBox(height: 8),
            Text(
              l10n.roomBalanceOutBody(c.astrologerName),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => showRechargeSheet(context),
              icon: const Icon(Icons.add_rounded),
              label: Text(l10n.roomRechargeWallet),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => showBookConsultationSheet(
                context,
                astrologerId: c.astrologerId,
                astrologerName: c.astrologerName,
                ratePerMinute: c.ratePerMinute,
                currency: c.currency,
              ),
              child: Text(l10n.roomStartAgain(c.astrologerName)),
            ),
          ],
          const SizedBox(height: 20),
          if (ended)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _row(l10n.roomRowAstrologer, c.astrologerName),
                    _row(
                      l10n.roomRowDuration,
                      l10n.roomMinutes(c.billedMinutes),
                    ),
                    _row(
                      l10n.roomRowAmount,
                      '${c.currency} ${c.gross.toStringAsFixed(2)}',
                    ),
                    _row(
                      l10n.roomRowRate,
                      l10n.roomRatePerMinute(
                        c.currency,
                        c.ratePerMinute.toStringAsFixed(0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (ended && c.rating == null && !_submitted) ...[
            const SizedBox(height: 20),
            Text(
              l10n.roomRateQuestion,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 1; i <= 5; i++)
                  IconButton(
                    onPressed: () => setState(() => _rating = i),
                    icon: Icon(
                      i <= _rating
                          ? Icons.star_rounded
                          : Icons.star_border_rounded,
                      color: const Color(0xFFF2A93B),
                      size: 34,
                    ),
                  ),
              ],
            ),
            FilledButton(
              onPressed: _rating == 0
                  ? null
                  : () async {
                      try {
                        await context.read<ChatCubit>().submitReview(_rating);
                        if (mounted) setState(() => _submitted = true);
                      } catch (_) {}
                    },
              child: Text(l10n.roomSubmitRating),
            ),
          ],
          if (_submitted)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(l10n.roomRatingThanks, textAlign: TextAlign.center),
            ),
          if (_canThank(c)) ...[
            const SizedBox(height: 20),
            GiftPromptCard(
              target: ConsultationGiftTarget(
                consultationId: c.id,
                astrologerName: c.astrologerName,
                currency: c.currency,
              ),
            ),
          ],
          const SizedBox(height: 24),
          OutlinedButton(
            onPressed: () => context.go('/home'),
            child: Text(l10n.roomBackHome),
          ),
          if (ended && c.billedSeconds > 0)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: TextButton.icon(
                onPressed: () => context.push(Routes.reportIssue(c.id)),
                icon: const Icon(Icons.flag_outlined, size: 18),
                label: Text(l10n.roomReportProblem),
                style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _row(String k, String v) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          k,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        Text(v, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    ),
  );

  /// A session that really happened can be thanked with a gift for a while
  /// after it ends (backend `GIFTING.POST_SESSION_WINDOW_HOURS`, default 72h —
  /// the server is the authority; this only hides a card that would bounce).
  static bool _canThank(Consultation c) =>
      c.status == ConsultationStatus.ended &&
      c.billedSeconds > 0 &&
      (c.endedAt == null ||
          DateTime.now().difference(c.endedAt!) < const Duration(hours: 72));

  static String _statusLine(AppLocalizations l10n, ConsultationStatus s) =>
      switch (s) {
        ConsultationStatus.rejected => l10n.roomStatusRejected,
        ConsultationStatus.cancelled => l10n.roomStatusCancelled,
        ConsultationStatus.expired => l10n.roomStatusExpired,
        ConsultationStatus.noShow => l10n.roomStatusNoShow,
        _ => l10n.roomStatusClosed,
      };
}
