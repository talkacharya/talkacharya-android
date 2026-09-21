import 'dart:async';

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
import '../../../follows/presentation/widgets/follow_widgets.dart';
import '../../../gifting/data/models/gift.dart';
import '../../../gifting/presentation/view/gift_sheet.dart';
import '../../../gifting/presentation/widgets/gift_prompt_card.dart';
import '../../../wallet/presentation/view/recharge_sheet.dart';
import '../../data/call_adapters.dart';
import '../../data/chat_adapters.dart';
import '../../data/consultation_repository.dart';
import '../../data/models/consultation.dart';
import '../cubit/chat_cubit.dart';
import '../room_presence.dart';
import 'book_consultation_sheet.dart';
import 'widgets/billing_hud.dart';
import 'widgets/share_details_sheet.dart';
import '../../../../core/config/config_repository.dart';
import '../../../../core/sounds/app_sound_adapters.dart';
import '../../../store/presentation/view/consults_pages.dart';

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
            sounds: const AppChatSounds(),
          )..start(),
        ),
      ],
      child: _PresenceScope(
        consultationId: consultationId,
        child: const _RoomView(),
      ),
    );
  }
}

/// Tells [RoomPresence] this room is on screen, so the app-wide "live
/// consultation" banner hides and deep links don't tear a call down.
class _PresenceScope extends StatefulWidget {
  const _PresenceScope({required this.consultationId, required this.child});

  final String consultationId;
  final Widget child;

  @override
  State<_PresenceScope> createState() => _PresenceScopeState();
}

class _PresenceScopeState extends State<_PresenceScope> {
  RoomPresence get _presence => getIt<RoomPresence>();

  @override
  void initState() {
    super.initState();
    _presence.opened(widget.consultationId, isCall: false);
  }

  @override
  void dispose() {
    _presence.closed(widget.consultationId);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isCall = context.select(
      (ChatCubit c) => c.state.consultation?.channel != 'chat',
    );
    _presence.opened(widget.consultationId, isCall: isCall);
    return widget.child;
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
        // A finished chat session keeps its room: the conversation is still
        // there to read, composer disabled, with the wrap-up (duration,
        // rating, recharge if it ran out) folded in rather than replacing it.
        // Every other terminal case (rejected/cancelled/expired/no-show, or a
        // call) never had a chat worth preserving, so it keeps the summary.
        if (c.status.isTerminal) {
          if (c.channel == 'chat' && c.status == ConsultationStatus.ended) {
            return _ChatShell(consultation: c, lowBalance: state.lowBalance);
          }
          return _SummaryView(consultation: c);
        }
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
/// self-hosted WebRTC (`package:talkacharya_call`).
///
/// The call belongs to the app-wide [CallHub], not to this screen: minimizing
/// or navigating away leaves it running behind a tap-to-return bar, the way a
/// phone call does, so someone can open a kundali or answer another chat
/// without hanging up on the astrologer they are paying by the minute.
class _CallRoom extends StatefulWidget {
  const _CallRoom({required this.consultation, required this.lowBalance});
  final Consultation consultation;
  final bool lowBalance;

  @override
  State<_CallRoom> createState() => _CallRoomState();
}

class _CallRoomState extends State<_CallRoom> {
  late final CallController _call;
  CallHub get _hub => getIt<CallHub>();
  String get _id => widget.consultation.id;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<ChatCubit>();
    final running = _hub.isFor(_id) ? _hub.controller : null;
    _hub.roomOpened(_id);
    if (running != null) {
      // Re-entering a call that was minimized: adopt it, never start a second.
      _call = running;
      _hub.expand();
      return;
    }
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
      sounds: const AppCallSounds(),
      // The customer placed this call: ring back until the astrologer's audio
      // arrives — unless we're re-opening a call that was already running.
      ringback: widget.consultation.status != ConsultationStatus.active,
    );
    _hub.attach(
      _call,
      CallInfo(
        consultationId: _id,
        peerName: widget.consultation.astrologerName,
        peerAvatarUrl: widget.consultation.astrologerAvatar,
        video: widget.consultation.channel == 'video',
      ),
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
    _hub.roomClosed(_id);
    // A call that is over has nothing left to run in the background; one that
    // is still up keeps going under the mini bar.
    if (_hub.isFor(_id) && _call.state.phase == CallPhase.ended) {
      unawaited(_hub.release());
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = widget.consultation;
    final waiting = c.status == ConsultationStatus.requested;
    return BlocProvider.value(
      value: _call,
      // `CallScreen` owns the back gesture: given `onMinimize` it minimizes the
      // call instead of asking whether to end it.
      child: CallScreen(
        onMinimize: () {
          _hub.minimize();
          Navigator.of(context).maybePop();
        },
        peerName: c.astrologerName,
        peerAvatarUrl: c.astrologerAvatar,
        strings: callStrings(l),
        statusOverride: waiting ? l.callWaitingAccept(c.astrologerName) : null,
        top: c.status == ConsultationStatus.active
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: BillingHud(
                      consultation: c,
                      lowBalance: widget.lowBalance,
                      onRecharge: () => showRechargeSheet(context),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _ShareChip(onTap: () => showShareDetailsSheet(context)),
                ],
              )
            : null,
        onEnded: () => context.read<ChatCubit>().refresh(),
      ),
    );
  }
}

/// Small translucent "share birth details" button for the call screen.
class _ShareChip extends StatelessWidget {
  const _ShareChip({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.14),
      shape: const StadiumBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.auto_awesome_rounded,
                size: 16,
                color: Colors.white,
              ),
              const SizedBox(width: 6),
              Text(
                context.l10n.shareWithAstrologer,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
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
  camera: l.callCamera,
  flipCamera: l.callFlipCamera,
  cameraOff: l.callCameraOff,
  peerCameraOff: l.callPeerCameraOff,
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
  minimize: l.callMinimize,
  tapToReturn: l.callTapToReturn,
  waiting: l.callWaiting,
);

// --- chat ---------------------------------------------------------------

/// The chat room. Live, this is the ordinary billed conversation. Once the
/// consultation has [ConsultationStatus.ended], it's the same room with the
/// composer switched off: the conversation stays visible — "the chat should
/// be there so the customer can read" — with the wrap-up (duration, rating,
/// recharge if the balance ran out) folded in above the messages instead of
/// replacing them.
class _ChatShell extends StatefulWidget {
  const _ChatShell({required this.consultation, required this.lowBalance});
  final Consultation consultation;
  final bool lowBalance;

  @override
  State<_ChatShell> createState() => _ChatShellState();
}

class _ChatShellState extends State<_ChatShell> {
  int _rating = 0;
  bool _ratingBusy = false;
  bool _justRated = false;

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

  Future<void> _submitRating(Consultation c) async {
    if (_rating == 0 || _ratingBusy) return;
    setState(() => _ratingBusy = true);
    try {
      await context.read<ChatCubit>().submitReview(_rating);
      if (mounted) setState(() => _justRated = true);
    } catch (_) {
      // stays editable — the star row is still there to try again
    } finally {
      if (mounted) setState(() => _ratingBusy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.consultation;
    final ended = c.status == ConsultationStatus.ended;
    final canChat = c.status.canChat;
    final scheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;

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
                  if (ended)
                    Text(
                      l10n.roomEndedTitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: scheme.onSurfaceVariant,
                      ),
                    )
                  else
                    const ChatHeaderStatus(),
                ],
              ),
            ),
            if (!ended) _AutoTranslateToggle(),
          ],
        ),
        actions: ended
            ? [
                if (_canThankFrom(c))
                  IconButton(
                    tooltip: l10n.giftAction,
                    icon: const Icon(Icons.card_giftcard_rounded),
                    onPressed: () => showGiftSheet(
                      context,
                      target: ConsultationGiftTarget(
                        consultationId: c.id,
                        astrologerName: c.astrologerName,
                        currency: c.currency,
                      ),
                    ),
                  ),
                IconButton(
                  tooltip: l10n.roomViewSummary,
                  icon: const Icon(Icons.receipt_long_rounded),
                  onPressed: () => _showSummarySheet(context, c),
                ),
              ]
            : [
                IconButton(
                  tooltip: l10n.shareWithAstrologer,
                  icon: const Icon(Icons.auto_awesome_rounded),
                  onPressed: () => showShareDetailsSheet(context),
                ),
                IconButton(
                  tooltip: l10n.giftAction,
                  icon: const Icon(Icons.card_giftcard_rounded),
                  onPressed: () => showGiftSheet(
                    context,
                    target: ConsultationGiftTarget(
                      consultationId: c.id,
                      astrologerName: c.astrologerName,
                      currency: c.currency,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => _confirmEnd(context),
                  child: Text(l10n.roomEnd),
                ),
              ],
      ),
      body: Column(
        children: [
          if (ended)
            _EndedBanner(consultation: c)
          else
            BillingHud(
              consultation: c,
              lowBalance: widget.lowBalance,
              onRecharge: () => showRechargeSheet(context),
            ),
          if (ended)
            _RatingBlock(
              consultation: c,
              rating: _rating,
              busy: _ratingBusy,
              justRated: _justRated,
              onRate: (r) => setState(() => _rating = r),
              onSubmit: () => _submitRating(c),
            ),
          Expanded(child: ChatView(composerEnabled: canChat)),
        ],
      ),
    );
  }
}

/// Same 72h post-session window the gift prompt already respects — the
/// server is the real authority; this only hides a button that would bounce.
bool _canThankFrom(Consultation c) =>
    c.status == ConsultationStatus.ended &&
    c.billedSeconds > 0 &&
    (c.endedAt == null ||
        DateTime.now().difference(c.endedAt!) < const Duration(hours: 72));

/// The compact strip at the top of an ended chat room: what happened and,
/// if the session stopped because the balance ran out, how to pick it back
/// up — kept prominent and inline since it's the one thing worth acting on
/// immediately, not tucked into the summary sheet with everything else.
class _EndedBanner extends StatelessWidget {
  const _EndedBanner({required this.consultation});
  final Consultation consultation;

  @override
  Widget build(BuildContext context) {
    final c = consultation;
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final ranOut = c.endReason == 'balance_exhausted';

    if (!ranOut) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        color: theme.colorScheme.surfaceContainerHighest,
        child: Text(
          l10n.roomEndedSummaryLine(
            c.billedMinutes,
            c.currency,
            c.gross.toStringAsFixed(2),
          ),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      color: theme.colorScheme.errorContainer.withValues(alpha: 0.4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.account_balance_wallet_outlined,
                size: 18,
                color: theme.colorScheme.onErrorContainer,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.roomBalanceOutTitle,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.onErrorContainer,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            l10n.roomBalanceOutBody(c.astrologerName),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onErrorContainer,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => showRechargeSheet(context),
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: Text(l10n.roomRechargeWallet),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => showBookConsultationSheet(
                    context,
                    astrologerId: c.astrologerId,
                    astrologerName: c.astrologerName,
                    ratePerMinute: c.ratePerMinute,
                    currency: c.currency,
                  ),
                  child: Text(l10n.roomStartAgain(c.astrologerName)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// "How was it?" once, then "you said X" every time after — instead of
/// silently showing nothing the moment a rating already exists, which is
/// what this room did before.
class _RatingBlock extends StatelessWidget {
  const _RatingBlock({
    required this.consultation,
    required this.rating,
    required this.busy,
    required this.justRated,
    required this.onRate,
    required this.onSubmit,
  });

  final Consultation consultation;
  final int rating;
  final bool busy;
  final bool justRated;
  final ValueChanged<int> onRate;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final given = justRated ? rating : consultation.rating;

    if (given != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            for (var i = 1; i <= 5; i++)
              Icon(
                i <= given ? Icons.star_rounded : Icons.star_border_rounded,
                size: 16,
                color: const Color(0xFFF2A93B),
              ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                justRated ? l10n.roomRatingThanks : l10n.roomYouRated(given),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              l10n.roomRateQuestion,
              style: theme.textTheme.bodySmall,
            ),
          ),
          for (var i = 1; i <= 5; i++)
            InkWell(
              onTap: () => onRate(i),
              child: Icon(
                i <= rating ? Icons.star_rounded : Icons.star_border_rounded,
                size: 26,
                color: const Color(0xFFF2A93B),
              ),
            ),
          const SizedBox(width: 4),
          if (busy)
            const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else
            IconButton(
              tooltip: l10n.roomSubmitRating,
              icon: const Icon(Icons.check_circle_rounded),
              onPressed: rating == 0 ? null : onSubmit,
              color: rating == 0
                  ? theme.disabledColor
                  : theme.colorScheme.primary,
            ),
        ],
      ),
    );
  }
}

/// The rest of what `_SummaryView` used to show, one tap away instead of
/// standing between the customer and their own conversation.
void _showSummarySheet(BuildContext context, Consultation c) {
  final l10n = context.l10n;
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (sheetContext) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _SummaryRow(l10n.roomRowAstrologer, c.astrologerName),
                    _SummaryRow(
                      l10n.roomRowDuration,
                      l10n.roomMinutes(c.billedMinutes),
                    ),
                    _SummaryRow(
                      l10n.roomRowAmount,
                      '${c.currency} ${c.gross.toStringAsFixed(2)}',
                    ),
                    _SummaryRow(
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
            if (getIt<ConfigRepository>().value.features.store) ...[
              const SizedBox(height: 12),
              StoreConsultSummaryCard(consultationId: c.id),
            ],
            if (c.billedSeconds > 0 && c.astrologerId.isNotEmpty) ...[
              const SizedBox(height: 12),
              FollowPromptCard(
                astrologerId: c.astrologerId,
                astrologerName: c.astrologerName,
              ),
            ],
            const SizedBox(height: 16),
            if (c.billedSeconds > 0)
              TextButton.icon(
                onPressed: () {
                  Navigator.pop(sheetContext);
                  context.push(Routes.reportIssue(c.id));
                },
                icon: const Icon(Icons.flag_outlined, size: 18),
                label: Text(l10n.roomReportProblem),
              ),
          ],
        ),
      ),
    ),
  );
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    ),
  );
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
          // Consulted about a store product: show the verdict / buy link.
          if (getIt<ConfigRepository>().value.features.store)
            StoreConsultSummaryCard(consultationId: c.id),
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
          if (ended && c.billedSeconds > 0 && c.astrologerId.isNotEmpty) ...[
            const SizedBox(height: 20),
            FollowPromptCard(
              astrologerId: c.astrologerId,
              astrologerName: c.astrologerName,
            ),
          ],
          if (_canThank(c)) ...[
            const SizedBox(height: 12),
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
