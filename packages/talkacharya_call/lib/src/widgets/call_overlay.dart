import 'dart:async';

import 'package:flutter/material.dart';

import '../engine/call_controller.dart';
import '../engine/call_pip.dart';
import '../models/call_state.dart';
import 'call_hub.dart';
import 'call_status.dart';
import 'call_video_view.dart';
import 'call_screen.dart';

export 'call_hub.dart';

part 'call_mini_bar.dart';
part 'call_floating_window.dart';

/// Wrap the app's navigator with this (`MaterialApp.builder`): while a call is
/// minimized it shows [CallMiniBar] above the app (voice) or a draggable
/// [CallFloatingWindow] over it (video). [onOpen] brings the call screen back.
///
/// The navigator keeps the same position in the tree whatever is shown, so
/// minimizing / expanding never resets navigation.
class CallOverlayHost extends StatefulWidget {
  const CallOverlayHost({
    required this.hub,
    required this.onOpen,
    required this.child,
    this.strings = const CallStrings(),
    this.barColor,
    super.key,
  });

  final CallHub hub;
  final void Function(CallInfo info) onOpen;
  final Widget child;
  final CallStrings strings;
  final Color? barColor;

  @override
  State<CallOverlayHost> createState() => _CallOverlayHostState();
}

class _CallOverlayHostState extends State<CallOverlayHost> {
  /// Keeps the app (navigator) alive if the layout around it ever changes shape.
  final _appKey = GlobalKey(debugLabel: 'call-overlay-app');

  @override
  Widget build(BuildContext context) {
    final hub = widget.hub;
    final strings = widget.strings;
    return Overlay(
      initialEntries: [
        OverlayEntry(
          builder: (context) => ListenableBuilder(
            listenable: Listenable.merge([hub, CallPip.inPip]),
            builder: (context, _) {
              final c = hub.controller;
              final info = hub.info;
              final minimized = c != null && info != null && !hub.expanded;
              // In the system's picture-in-picture window there is room for one
              // thing, and it is the other person — not the app screen behind them,
              // scaled down to the size of a stamp.
              final pip = CallPip.inPip.value;
              return _PhaseGate(
                controller: minimized || pip ? c : null,
                builder: (context, state) {
                  final showBar =
                      minimized &&
                      state != null &&
                      !info.video &&
                      _visible(state);
                  final showFloat =
                      minimized &&
                      state != null &&
                      info.video &&
                      _visible(state);

                  return SizedBox.expand(
                    child: Stack(
                      children: [
                        Offstage(
                          offstage: pip,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (showBar)
                                CallMiniBar(
                                  info: info,
                                  state: state,
                                  strings: strings,
                                  color: widget.barColor,
                                  onOpen: () => widget.onOpen(info),
                                  onMute: c.toggleMute,
                                  onEnd: c.hangUp,
                                ),
                              Expanded(
                                key: const ValueKey('call-overlay-body'),
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: MediaQuery.removePadding(
                                        context: context,
                                        removeTop: showBar,
                                        child: KeyedSubtree(
                                          key: _appKey,
                                          child: widget.child,
                                        ),
                                      ),
                                    ),
                                    if (showFloat)
                                      CallFloatingWindow(
                                        info: info,
                                        state: state,
                                        strings: strings,
                                        onExpand: () => widget.onOpen(info),
                                        onMute: c.toggleMute,
                                        onCamera: c.toggleCamera,
                                        onFlip: c.switchCamera,
                                        onEnd: c.hangUp,
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (pip)
                          Positioned.fill(
                            child: (state != null && info != null)
                                ? _PipView(
                                    state: state,
                                    peerName: info.peerName,
                                  )
                                : const ColoredBox(
                                    color: Color(0xFF140B2E),
                                    child: Center(
                                      child: Icon(
                                        Icons.call_end_rounded,
                                        color: Colors.white54,
                                        size: 48,
                                      ),
                                    ),
                                  ),
                          ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  static bool _visible(CallState s) => s.phase != CallPhase.ended;
}

/// What the picture-in-picture window shows: the peer's video, or their name on
/// the call's own background while their camera is off.
class _PipView extends StatelessWidget {
  const _PipView({required this.state, required this.peerName});

  final CallState state;
  final String peerName;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFF140B2E),
      child: state.showRemoteVideo
          ? CallVideoView(stream: state.remoteVideo)
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  peerName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
    );
  }
}

/// Rebuilds with the controller's state (or `null` without a controller),
/// filtered to only the fields that affect the overlay visibility and content.
///
/// Without this filter, every quality tick (~2 s) and every peerQuality update
/// triggers a full rebuild of the overlay column — the bar slide-in logic,
/// the floating window, and the app body key. The stream is filtered to only
/// emit when something the overlay actually renders changes.
class _PhaseGate extends StatelessWidget {
  const _PhaseGate({required this.controller, required this.builder});
  final CallController? controller;
  final Widget Function(BuildContext context, CallState? state) builder;

  static bool _changed(CallState a, CallState b) =>
      a.phase != b.phase ||
      a.muted != b.muted ||
      a.cameraOn != b.cameraOn ||
      a.speakerOn != b.speakerOn ||
      a.showRemoteVideo != b.showRemoteVideo ||
      a.connectedAt != b.connectedAt;

  @override
  Widget build(BuildContext context) {
    final c = controller;
    return StreamBuilder<CallState>(
      key: ObjectKey(c),
      stream: c?.stream.distinct(_changed),
      initialData: c?.state,
      builder: (context, snap) =>
          builder(context, c == null ? null : snap.data),
    );
  }
}

/// Re-renders every second while [state] is connected (for the clock).
class _Ticker extends StatefulWidget {
  const _Ticker({required this.state, required this.builder});
  final CallState state;
  final WidgetBuilder builder;

  @override
  State<_Ticker> createState() => _TickerState();
}

class _TickerState extends State<_Ticker> {
  Timer? _t;

  @override
  void initState() {
    super.initState();
    _t = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted && widget.state.connectedAt != null) setState(() {});
    });
  }

  @override
  void dispose() {
    _t?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context);
}

String _miniStatus(CallState s, CallStrings strings) =>
    s.phase == CallPhase.idle ? strings.waiting : callStatusText(s, strings);
