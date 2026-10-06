part of 'consultation_room_page.dart';

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
    if (_hub.isFor(_id)) {
      if (_call.state.phase == CallPhase.ended) {
        unawaited(_hub.release());
      } else {
        _hub.minimize();
      }
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
          if (context.canPop()) context.pop();
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
        // A reading is two people looking at the same diagram. On a video call
        // the astrologer had nowhere to put it and either worked from memory
        // or left the call to look.
        overlay: c.isCall && c.sharedPeople.isNotEmpty
            ? CallChartPanel(
                consultationId: c.id,
                profileId: c.sharedPeople.first.id,
                profileName: c.sharedPeople.first.name,
              )
            : null,
        onEnded: () => context.read<ChatCubit>().refresh(),
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
    final toppingUp = state.customerToppingUp;

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
          // The hold takes precedence over the warning: by this point the
          // customer is past warning and actually paying.
          child: toppingUp
              ? Container(
                  width: double.infinity,
                  color: Theme.of(context).colorScheme.tertiaryContainer,
                  padding: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 13,
                        height: 13,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Theme.of(
                            context,
                          ).colorScheme.onTertiaryContainer,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          l.roomCustomerToppingUp,
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onTertiaryContainer,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : low
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
  // Named, not generic: an astrologer whose own line is fine used to spend a
  // rough call apologising and restarting things that were never the problem.
  poorConnection: l.callPoorConnection,
  peerPoorConnection: l.callPeerPoorConnection,
  bothPoorConnection: l.callBothPoorConnection,
  minimize: l.callMinimize,
  tapToReturn: l.callTapToReturn,
  waiting: l.callWaiting,
  audio: l.callAudio,
  earpiece: l.callEarpiece,
  wiredHeadset: l.callWiredHeadset,
  bluetoothHeadset: l.callBluetooth,
);

/// Saves or shares a transcript of the session.
class _TranscriptButton extends StatefulWidget {
  const _TranscriptButton({required this.consultation});

  final Consultation consultation;

  @override
  State<_TranscriptButton> createState() => _TranscriptButtonState();
}

class _TranscriptButtonState extends State<_TranscriptButton> {
  bool _busy = false;

  Future<void> _download() async {
    setState(() => _busy = true);
    final messenger = ScaffoldMessenger.of(context);
    final l = context.l10n;
    try {
      final bytes = await getIt<ConsultationApi>().transcript(
        widget.consultation.id,
        consultationId: widget.consultation.id,
      );
      // The server decides the format — plain text where it cannot build a
      // PDF — so sniff rather than assume.
      final isPdf =
          bytes.length > 4 &&
          bytes[0] == 0x25 &&
          bytes[1] == 0x50 &&
          bytes[2] == 0x44 &&
          bytes[3] == 0x46;
      await Share.shareXFiles([
        XFile.fromData(
          Uint8List.fromList(bytes),
          mimeType: isPdf ? 'application/pdf' : 'text/plain',
          name: 'consultation.${isPdf ? 'pdf' : 'txt'}',
        ),
      ]);
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text(l.docDownloadFailed)));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: _busy ? null : _download,
      icon: _busy
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.download_rounded, size: 18),
      label: Text(context.l10n.roomDownloadTranscript),
    );
  }
}
