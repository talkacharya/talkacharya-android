import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:talkacharya_call/talkacharya_call.dart';

import '../../../../../core/di/service_locator.dart';
import '../../../../../core/l10n/l10n.dart';
import '../../../../../core/realtime/realtime_client.dart';
import '../../../../../core/notifications/local_notifications.dart';
import '../../../../../core/sounds/app_sound_adapters.dart';
import '../../../../wallet/presentation/view/recharge_sheet.dart';
import '../../../data/call_adapters.dart';
import '../../../data/consultation_repository.dart';
import '../../../data/models/consultation.dart';
import '../../cubit/chat_cubit.dart';
import 'billing_hud.dart';
import 'quick_top_up.dart';
import 'share_details_sheet.dart';

/// Shown in the Android foreground-service notification while a call runs.
const String kAppName = 'TalkAcharya';

/// Voice consultation: one full-screen call surface from "waiting for accept"
/// through ringing, the live call (with the billing HUD) to hang-up. Media is
/// self-hosted WebRTC (`package:talkacharya_call`).
///
/// The call belongs to the app-wide [CallHub], not to this screen: minimizing
/// or navigating away leaves it running behind a tap-to-return bar, the way a
/// phone call does, so someone can open a kundali or answer another chat
/// without hanging up on the astrologer they are paying by the minute.
class CallRoom extends StatefulWidget {
  const CallRoom({required this.consultation, required this.lowBalance, super.key});

  final Consultation consultation;
  final bool lowBalance;

  @override
  State<CallRoom> createState() => _CallRoomState();
}

class _CallRoomState extends State<CallRoom> {
  late final CallController _call;
  StreamSubscription<CallState>? _callSub;
  CallPhase? _lastPhase;

  CallHub get _hub => getIt<CallHub>();

  String get _id => widget.consultation.id;

  /// Runs [fn] after the current frame. The hub notifies its listeners
  /// (`RoomView`'s [ListenableBuilder] among them), and `initState` runs
  /// during a build — notifying from here would mark a widget dirty mid-build.
  void _afterFrame(VoidCallback fn) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) fn();
    });
  }

  @override
  void initState() {
    super.initState();
    // The incoming-call notification (FLAG_INSISTENT system ringtone) keeps
    // ringing until explicitly cancelled.  Opening the call room IS the act of
    // answering, so stop it immediately — regardless of whether the controller
    // is new or being re-adopted from the hub.
    unawaited(getIt<LocalNotifications>().cancelIncomingCall());
    final cubit = context.read<ChatCubit>();
    final running = _hub.isFor(_id) ? _hub.controller : null;
    if (running != null) {
      // Re-entering a call that was minimized: adopt it, never start a second.
      _call = running;
      _afterFrame(() {
        _hub.roomOpened(_id);
        _hub.expand();
      });
      return;
    }
    _call = CallController(
      backend: DioCallBackend(
        getIt(),
        widget.consultation.id,
        // `cubit` is owned by this route (`BlocProvider(create:)`) and closes
        // when it's popped — which minimizing does. The call, and this
        // callback with it, can outlive that: hanging up from the minimized
        // bar later must not touch a closed cubit (Cubit.emit throws after
        // close), so it falls back to the repository directly. `connectedAt`
        // is read off the call itself rather than the cubit's (possibly
        // stale) consultation status, so this doesn't depend on the cubit
        // either way.
        onEnd: () async {
          final everConnected = _call.state.connectedAt != null;
          if (!cubit.isClosed) {
            await (everConnected
                ? cubit.endConsultation()
                : cubit.cancelRequest());
            return;
          }
          await (everConnected
              ? getIt<ConsultationRepository>().end(_id)
              : getIt<ConsultationRepository>().cancel(_id));
        },
      ),
      signaling: RealtimeCallSignaling(getIt<RealtimeClient>()),
      // Opus capped at 32 kbps: clear speech that holds up on a weak mobile
      // connection, instead of the encoder chasing bandwidth it then loses.
      engine: FlutterWebRtcEngine(maxAudioBitrate: 32000),
      // The id the ring was reported to Android under, so the live call
      // adopts that Telecom call rather than placing a second one.
      telecomCallId: _id,
      permissions: const PermissionHandlerCallPermissions(),
      keepAlive: ForegroundServiceCallKeepAlive(),
      connectivity: const ConnectivityPlusCallConnectivity(),
      diagnostics: const CrashlyticsCallDiagnostics(),
      keepAliveTitle: kAppName,
      sounds: const AppCallSounds(),
      // The customer placed this call: ring back until the astrologer's audio
      // arrives — unless we're re-opening a call that was already running.
      ringback: widget.consultation.status != ConsultationStatus.active,
    );
    _callSub = _call.stream.listen((state) {
      if (state.phase == CallPhase.connected &&
          _lastPhase != CallPhase.connected) {
        // Belt-and-suspenders: cancel the incoming-call notification the moment
        // audio flows, in case the room was opened from the background and the
        // notification's ringtone is still audible.
        unawaited(getIt<LocalNotifications>().cancelIncomingCall());
        // Auto-minimize as soon as the call connects so the user lands
        // directly in the consultation chat room.
        _afterFrame(() {
          if (mounted) _hub.minimize();
        });
      }
      _lastPhase = state.phase;
    });
    _afterFrame(() {
      _hub.roomOpened(_id);
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
    });
  }

  @override
  void didUpdateWidget(covariant CallRoom old) {
    super.didUpdateWidget(old);
    if (widget.consultation.status.isTerminal) {
      if (_hub.isFor(_id)) unawaited(_hub.release());
    } else {
      _maybeStart();
    }
  }

  void _maybeStart() {
    final s = widget.consultation.status;
    final joinable =
        s == ConsultationStatus.accepted || s == ConsultationStatus.active;
    if (joinable && _call.state.phase == CallPhase.idle) _call.start();
  }

  @override
  void dispose() {
    unawaited(_callSub?.cancel());
    _hub.roomClosed(_id);
    // A call that is over or terminal has nothing left to run in the background.
    if (_hub.isFor(_id) &&
        (_call.state.phase == CallPhase.ended ||
            widget.consultation.status.isTerminal)) {
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
          if (context.canPop()) context.pop();
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
                      awaitingPaymentUntil: context.select(
                        (ChatCubit cubit) => cubit.state.awaitingPaymentUntil,
                      ),
                      onRecharge: () => showRechargeSheet(
                        context,
                        initialAmount: QuickTopUp.amountFor(
                          double.tryParse(c.rateSnapshot) ?? 0,
                          10,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ShareChip(onTap: () => showShareDetailsSheet(context)),
                ],
              )
            : null,
        onEnded: () => context.read<ChatCubit>().refresh(),
      ),
    );
  }
}

/// Small translucent "share birth details" button for the call screen.
class ShareChip extends StatelessWidget {
  const ShareChip({required this.onTap, super.key});

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
      peerPoorConnection: l.callPeerPoorConnection,
      bothPoorConnection: l.callBothPoorConnection,
      mute: l.callMute,
      speaker: l.callSpeaker,
      camera: l.callCamera,
      flipCamera: l.callFlipCamera,
      cameraOff: l.callCameraOff,
      videoPausedWeakConnection: l.callVideoPausedWeak,
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
      audio: l.callAudio,
      earpiece: l.callEarpiece,
      wiredHeadset: l.callWiredHeadset,
      bluetoothHeadset: l.callBluetooth,
    );
