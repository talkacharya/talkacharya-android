import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:talkacharya_call/talkacharya_call.dart';
import 'package:talkacharya_chat/talkacharya_chat.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/realtime/realtime_client.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../../core/util/money.dart';
import '../../../../core/sounds/app_sound_adapters.dart';
import '../../../../shared/widgets/cosmic.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/fade_slide_in.dart';
import '../../../../shared/widgets/hue_widgets.dart';
import '../../../../shared/widgets/settings_widgets.dart';
import '../../../auth/presentation/bloc/auth/auth_bloc.dart';
import '../../data/call_adapters.dart';
import '../../data/chat_adapters.dart';
import '../../data/consultation_api.dart';
import '../../data/models/consultation.dart';
import '../cubit/chat_cubit.dart';
import '../room_presence.dart';
import '../widgets/consultation_style.dart';
import '../widgets/shared_details.dart';

/// The astrologer's consultation room: the shared chat engine (or the shared
/// call screen) inside an astrologer shell — live session bar, the customer's
/// question, kundali, and ending the session.
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
      (ChatCubit c) => c.state.consultation?.isCall ?? false,
    );
    _presence.opened(widget.consultationId, isCall: isCall);
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

class _RoomView extends StatelessWidget {
  const _RoomView();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        final c = state.consultation;
        if (state.loading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (c == null) {
          return Scaffold(
            appBar: AppBar(),
            body: ErrorView(
              message: l.roomLoadError,
              onRetry: context.read<ChatCubit>().init,
            ),
          );
        }
        // An ended chat keeps its room: the conversation stays there to read,
        // composer off, with the wrap-up (earnings, duration, the customer's
        // rating if given) folded in above the messages instead of replacing
        // them. Every other terminal case (rejected/no answer, or a call)
        // never had a chat worth preserving, so it keeps the summary.
        if (c.isTerminal) {
          if (!c.isCall && c.isEnded) {
            return _ChatRoom(consultation: c, state: state, ended: true);
          }
          return _Summary(consultation: c);
        }
        if (c.isCall) {
          return _AstroCallRoom(consultation: c, state: state);
        }
        return _ChatRoom(consultation: c, state: state);
      },
    );
  }
}

/// The chat room. Live, this is the ordinary session with the running
/// earnings strip. Once [ended], it's the same room with the composer
/// switched off: the conversation stays visible — the astrologer can always
/// read back what was discussed — with the wrap-up (earnings, duration, the
/// customer's rating if given) one tap away instead of replacing the thread.
class _ChatRoom extends StatelessWidget {
  const _ChatRoom({
    required this.consultation,
    required this.state,
    this.ended = false,
  });

  final Consultation consultation;
  final ChatState state;
  final bool ended;

  @override
  Widget build(BuildContext context) {
    final c = consultation;
    final l = context.l10n;
    final brand = context.brand;
    final ch = channelStyle(context, c.channel);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            HueAvatar(name: c.customerName, hue: ch.hue, size: 38),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    c.customerName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (ended)
                    Text(
                      l.roomEndedTitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    )
                  else
                    const ChatHeaderStatus(),
                ],
              ),
            ),
          ],
        ),
        actions: ended
            ? [
                IconButton(
                  tooltip: l.roomViewSummary,
                  icon: const Icon(Icons.receipt_long_rounded),
                  onPressed: () => _showAstroSummarySheet(context, c),
                ),
              ]
            : [
                const _AutoTranslateToggle(),
                if (c.sharedPeople.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.auto_awesome_rounded),
                    tooltip: l.detailKundali,
                    onPressed: () => context.push(
                      Routes.consultationKundali(
                        c.id,
                        profile: c.sharedPeople.first.id,
                      ),
                      extra: c.sharedPeople.first.name,
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: brand.live,
                      minimumSize: const Size(0, 36),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                    ),
                    onPressed: () => confirmEndConsultation(context),
                    child: Text(l.roomEnd),
                  ),
                ),
              ],
      ),
      body: Column(
        children: [
          if (ended)
            _EndedBar(consultation: c)
          else if (c.status == 'active')
            _SessionBar(consultation: c, state: state)
          else
            _WaitingBar(name: c.customerName),
          if (!ended && c.question.isNotEmpty)
            _QuestionBanner(question: c.question),
          if (!ended && c.shares.isNotEmpty)
            SingleChildScrollView(
              child: SharedDetailsSection(
                consultation: c,
                canOpen: c.isLive,
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
              ),
            ),
          Expanded(
            child: ChatView(
              composerEnabled: !ended && c.isLive,
              composerHint: l.roomComposerHint,
            ),
          ),
        ],
      ),
    );
  }
}

/// Compact strip above an ended room: what was earned, how long, and — since
/// only the customer rates a session — what they rated it, if they have.
class _EndedBar extends StatelessWidget {
  const _EndedBar({required this.consultation});
  final Consultation consultation;

  @override
  Widget build(BuildContext context) {
    final c = consultation;
    final l = context.l10n;
    final theme = Theme.of(context);
    final earned = double.tryParse(c.astrologerAmount) ?? 0;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: theme.colorScheme.surfaceContainerHighest,
      child: Row(
        children: [
          Expanded(
            child: Text(
              '${l.requestsMinutes(c.billedMinutes)} · ${Money.format(earned, c.currency)}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          if (c.rating != null) ...[
            Icon(
              Icons.star_rounded,
              size: 15,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 2),
            Text(
              '${c.rating}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// The rest of what `_Summary` shows for an ended session, one tap away
/// instead of standing between the astrologer and the conversation itself.
void _showAstroSummarySheet(BuildContext context, Consultation c) {
  final l = context.l10n;
  final rate = double.tryParse(c.rateSnapshot) ?? 0;
  final earned = double.tryParse(c.astrologerAmount) ?? 0;
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
                    Text(l.detailYouEarned),
                    Text(
                      Money.format(earned, c.currency),
                      style: Theme.of(sheetContext).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _Stat(
                          label: l.detailDuration,
                          value: l.requestsMinutes(c.billedMinutes),
                        ),
                        _Stat(
                          label: l.detailRate,
                          value: l.dashPerMin(Money.format(rate, c.currency)),
                        ),
                        if (c.rating != null)
                          _Stat(label: l.detailRating, value: '${c.rating} ★'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (c.sharedPeople.isNotEmpty) ...[
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(sheetContext);
                  context.push(
                    Routes.consultationKundali(
                      c.id,
                      profile: c.sharedPeople.firstOrNull?.id,
                    ),
                    extra: c.customerName,
                  );
                },
                icon: const Icon(Icons.auto_awesome_rounded),
                label: Text(l.detailKundali),
              ),
            ],
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () {
                Navigator.pop(sheetContext);
                context.go(Routes.requests);
              },
              icon: const Icon(Icons.inbox_rounded),
              label: Text(l.roomBackToRequests),
            ),
          ],
        ),
      ),
    ),
  );
}

/// Voice / video session: the shared call screen with the session bar on top.
///
/// The call belongs to the app-wide [CallHub], not to this screen, so an
/// astrologer can pull up the customer's kundali or answer another chat
/// mid-session and come back through the mini bar.
class _AstroCallRoom extends StatefulWidget {
  const _AstroCallRoom({required this.consultation, required this.state});

  final Consultation consultation;
  final ChatState state;

  @override
  State<_AstroCallRoom> createState() => _AstroCallRoomState();
}

class _AstroCallRoomState extends State<_AstroCallRoom> {
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
      // Re-entering a minimized call: adopt it, never start a second.
      _call = running;
      _hub.expand();
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
        // close), so it falls back to the API directly.
        onEnd: () async {
          if (!cubit.isClosed) {
            await cubit.endConsultation();
            return;
          }
          try {
            await getIt<ConsultationApi>().end(_id);
          } catch (_) {}
        },
      ),
      signaling: RealtimeCallSignaling(getIt<RealtimeClient>()),
      engine: FlutterWebRtcEngine(),
      permissions: const PermissionHandlerCallPermissions(),
      keepAlive: ForegroundServiceCallKeepAlive(),
      connectivity: const ConnectivityPlusCallConnectivity(),
      diagnostics: const CrashlyticsCallDiagnostics(),
      keepAliveTitle: 'TalkAcharya Astrologer',
      sounds: const AppCallSounds(),
    );
    _hub.attach(
      _call,
      CallInfo(
        consultationId: _id,
        peerName: widget.consultation.customerName,
        video: widget.consultation.channel == 'video',
      ),
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
    _hub.roomClosed(_id);
    // A finished call has nothing to keep running; a live one carries on under
    // the mini bar.
    if (_hub.isFor(_id) && _call.state.phase == CallPhase.ended) {
      unawaited(_hub.release());
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.consultation;
    return BlocProvider.value(
      value: _call,
      // `CallScreen` owns the back gesture: given `onMinimize` it minimizes the
      // call instead of asking whether to end it.
      child: CallScreen(
        onMinimize: () {
          _hub.minimize();
          Navigator.of(context).maybePop();
        },
        peerName: c.customerName,
        accent: context.brand.glowAccent,
        strings: astroCallStrings(context.l10n),
        top: c.status == 'active'
            ? ClipRRect(
                borderRadius: BorderRadius.circular(Radii.md),
                child: _SessionBar(consultation: c, state: widget.state),
              )
            : null,
        onEnded: () => context.read<ChatCubit>().refresh(),
      ),
    );
  }
}

class _AutoTranslateToggle extends StatelessWidget {
  const _AutoTranslateToggle();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatController, ChatSessionState>(
      buildWhen: (a, b) => a.autoTranslate != b.autoTranslate,
      builder: (context, state) => IconButton(
        tooltip: context.l10n.roomTranslate,
        isSelected: state.autoTranslate,
        icon: const Icon(Icons.translate_outlined),
        selectedIcon: Icon(
          Icons.translate_rounded,
          color: Theme.of(context).colorScheme.primary,
        ),
        onPressed: () => context.read<ChatController>().setAutoTranslate(
          !state.autoTranslate,
        ),
      ),
    );
  }
}

/// Live session strip: running timer, rate, earnings so far, and the
/// customer's remaining balance (with a warning when it's low).
class _SessionBar extends StatelessWidget {
  const _SessionBar({required this.consultation, required this.state});

  final Consultation consultation;
  final ChatState state;

  @override
  Widget build(BuildContext context) {
    final c = consultation;
    final l = context.l10n;
    final brand = context.brand;
    final rate = double.tryParse(c.rateSnapshot) ?? 0;
    final earned = double.tryParse(c.astrologerAmount) ?? 0;
    final runway = state.clientRunwaySeconds ?? c.runwaySeconds;
    final low = state.clientLowBalance;

    return Column(
      children: [
        ClipRect(
          child: Stack(
            children: [
              const Positioned.fill(child: CosmicBackdrop()),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    const LiveDot(),
                    const SizedBox(width: 8),
                    _Elapsed(
                      since: c.startedAt,
                      fallbackSeconds: c.billedSeconds,
                    ),
                    const SizedBox(width: 12),
                    _Chip(text: l.dashPerMin(Money.format(rate, c.currency))),
                    const Spacer(),
                    if (runway > 0 && !low)
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          l.roomRunway((runway / 60).floor()),
                          style: TextStyle(
                            color: brand.onCosmicMuted,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ShaderMask(
                      shaderCallback: (r) => const LinearGradient(
                        colors: BrandColors.goldGradient,
                      ).createShader(r),
                      child: Text(
                        Money.format(earned, c.currency),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          child: low
              ? Container(
                  width: double.infinity,
                  color: brand.live,
                  padding: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        size: 16,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          runway > 0
                              ? '${l.roomLowBalance} · ${l.roomRunway((runway / 60).ceil())}'
                              : l.roomLowBalance,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox(width: double.infinity),
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(999),
    ),
    child: Text(
      text,
      style: TextStyle(
        color: context.brand.onCosmic,
        fontSize: 12,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}

/// mm:ss (or h:mm:ss) since [since], ticking every second.
class _Elapsed extends StatefulWidget {
  const _Elapsed({required this.since, required this.fallbackSeconds});

  final DateTime? since;
  final int fallbackSeconds;

  @override
  State<_Elapsed> createState() => _ElapsedState();
}

class _ElapsedState extends State<_Elapsed> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final since = widget.since;
    final secs = since == null
        ? widget.fallbackSeconds
        : DateTime.now().difference(since).inSeconds.clamp(0, 1 << 30);
    return Text(
      formatElapsed(secs),
      style: TextStyle(
        color: context.brand.onCosmic,
        fontWeight: FontWeight.w800,
        fontSize: 16,
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
    );
  }
}

/// 75 → "01:15", 3725 → "1:02:05".
String formatElapsed(int seconds) {
  final h = seconds ~/ 3600;
  final m = (seconds % 3600) ~/ 60;
  final s = seconds % 60;
  String two(int v) => v.toString().padLeft(2, '0');
  return h > 0 ? '$h:${two(m)}:${two(s)}' : '${two(m)}:${two(s)}';
}

class _WaitingBar extends StatelessWidget {
  const _WaitingBar({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return Container(
      width: double.infinity,
      color: brand.tint,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          SizedBox.square(
            dimension: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: brand.onTint,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              context.l10n.roomWaiting(name),
              style: TextStyle(
                color: brand.onTint,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The customer's intake question, collapsed to two lines until tapped.
class _QuestionBanner extends StatefulWidget {
  const _QuestionBanner({required this.question});

  final String question;

  @override
  State<_QuestionBanner> createState() => _QuestionBannerState();
}

class _QuestionBannerState extends State<_QuestionBanner> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surface,
      child: InkWell(
        onTap: () => setState(() => _open = !_open),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 10, 12, 10),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: brand.hairline)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.help_outline_rounded,
                size: 18,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 200),
                  alignment: Alignment.topCenter,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.detailQuestion,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: brand.inkMuted,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        widget.question,
                        maxLines: _open ? null : 2,
                        overflow: _open ? null : TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              Icon(
                _open ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                color: brand.inkMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Shown once the consultation is over (or never happened).
class _Summary extends StatelessWidget {
  const _Summary({required this.consultation});

  final Consultation consultation;

  @override
  Widget build(BuildContext context) {
    final c = consultation;
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    final held = c.isEnded;
    final rate = double.tryParse(c.rateSnapshot) ?? 0;
    final earned = double.tryParse(c.astrologerAmount) ?? 0;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: brand.cosmicStart,
        body: Stack(
          children: [
            const Positioned.fill(child: CosmicBackdrop()),
            SafeArea(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: BackButton(color: brand.onCosmic),
                  ),
                  const SizedBox(height: 16),
                  FadeSlideIn(
                    child: Center(
                      child: Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: held
                              ? const LinearGradient(
                                  colors: BrandColors.goldGradient,
                                )
                              : null,
                          color: held
                              ? null
                              : Colors.white.withValues(alpha: 0.1),
                          boxShadow: held
                              ? [
                                  BoxShadow(
                                    color: brand.glowAccent.withValues(
                                      alpha: 0.4,
                                    ),
                                    blurRadius: 30,
                                  ),
                                ]
                              : null,
                        ),
                        child: Icon(
                          held ? Icons.check_rounded : Icons.event_busy_rounded,
                          size: 48,
                          color: held
                              ? const Color(0xFF3A1703)
                              : brand.onCosmicMuted,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    held
                        ? l.roomEndedTitle
                        : statusStyle(context, c.status).label,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: brand.onCosmic,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    held ? l.roomEndedBody(c.customerName) : l.roomNotHeldBody,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: brand.onCosmicMuted,
                    ),
                  ),
                  if (held) ...[
                    const SizedBox(height: 24),
                    FadeSlideIn(
                      delay: const Duration(milliseconds: 80),
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.07),
                          borderRadius: BorderRadius.circular(Radii.lg),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.12),
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              l.detailYouEarned,
                              style: TextStyle(color: brand.onCosmicMuted),
                            ),
                            ShaderMask(
                              shaderCallback: (r) => const LinearGradient(
                                colors: BrandColors.goldGradient,
                              ).createShader(r),
                              child: Text(
                                Money.format(earned, c.currency),
                                style: theme.textTheme.displayMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                _Stat(
                                  label: l.detailDuration,
                                  value: l.requestsMinutes(c.billedMinutes),
                                ),
                                _Stat(
                                  label: l.detailRate,
                                  value: l.dashPerMin(
                                    Money.format(rate, c.currency),
                                  ),
                                ),
                                if (c.rating != null)
                                  _Stat(
                                    label: l.detailRating,
                                    value: '${c.rating} ★',
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (c.sharedPeople.isNotEmpty)
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: brand.onCosmic,
                          side: BorderSide(
                            color: Colors.white.withValues(alpha: 0.3),
                          ),
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(Radii.md),
                          ),
                        ),
                        onPressed: () => context.push(
                          Routes.consultationKundali(
                            c.id,
                            profile: c.sharedPeople.firstOrNull?.id,
                          ),
                          extra: c.customerName,
                        ),
                        icon: const Icon(Icons.auto_awesome_rounded),
                        label: Text(l.detailKundali),
                      ),
                  ],
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: brand.glowAccent,
                      foregroundColor: const Color(0xFF3A1703),
                    ),
                    onPressed: () => context.go(Routes.requests),
                    icon: const Icon(Icons.inbox_rounded),
                    label: Text(l.roomBackToRequests),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: brand.onCosmic,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(color: brand.onCosmicMuted, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

/// The call screen's words, in the astrologer's language.
CallStrings astroCallStrings(AppLocalizations l) => CallStrings(
  endConfirmBody: l.roomCallEndBody,
  videoPausedWeakConnection: l.callVideoPausedWeak,
  minimize: l.callMinimize,
  tapToReturn: l.callTapToReturn,
  waiting: l.callWaiting,
);
