import 'dart:async';

import 'package:flutter/material.dart';

import '../engine/call_controller.dart';
import '../engine/call_pip.dart';
import '../models/call_state.dart';
import 'call_screen.dart';
import 'call_status.dart';
import 'call_video_view.dart';

/// What the minimized call UI needs to show and where tapping it goes.
class CallInfo {
  const CallInfo({
    required this.consultationId,
    required this.peerName,
    this.peerAvatarUrl,
    this.video = false,
  });

  final String consultationId;
  final String peerName;
  final String? peerAvatarUrl;
  final bool video;
}

/// App-wide owner of the one running call, so it outlives the room screen.
///
/// The room shows the full [CallScreen] while [expanded]; minimizing hands the
/// call to [CallOverlayHost] (a bar for voice, a floating window for video) and
/// the user can move around the app. Rooms report when they're open so a tap on
/// the minimized UI can go back to the existing screen instead of stacking a
/// second one.
class CallHub extends ChangeNotifier {
  CallController? _controller;
  CallInfo? _info;
  bool _expanded = true;
  final _openRooms = <String, int>{};

  CallController? get controller => _controller;
  CallInfo? get info => _info;
  bool get expanded => _expanded;
  bool get hasCall => _controller != null;

  bool isFor(String consultationId) =>
      _controller != null && _info?.consultationId == consultationId;

  StreamSubscription<CallState>? _watch;

  /// Take ownership of [controller]; any previous call is closed.
  void attach(CallController controller, CallInfo info) {
    final previous = _controller;
    _controller = controller;
    _info = info;
    _expanded = true;
    unawaited(_watch?.cancel());
    // A call that ends while minimized has no screen to clean it up: the bar
    // hides itself, and without this the hub would hold a finished call — and
    // go on claiming the consultation is "in progress" — until someone opened
    // the room again.
    _watch = controller.stream.listen((state) {
      // A live video call follows the user out of the app as a picture-in-picture
      // window; anything else (voice, or a call that is over) must not.
      unawaited(CallPip.setActive(active: info.video && state.phase.isLive));
      if (state.phase == CallPhase.ended && !_expanded) unawaited(release());
    });
    notifyListeners();
    if (previous != null && !identical(previous, controller)) {
      unawaited(previous.close());
    }
  }

  void minimize() {
    if (_controller == null || !_expanded) return;
    _expanded = false;
    notifyListeners();
  }

  void expand() {
    if (_controller == null || _expanded) return;
    _expanded = true;
    notifyListeners();
  }

  /// Close and forget the call.
  Future<void> release() async {
    final c = _controller;
    if (c == null) return;
    unawaited(CallPip.setActive(active: false));
    unawaited(_watch?.cancel());
    _watch = null;
    _controller = null;
    _info = null;
    _expanded = true;
    notifyListeners();
    await c.close();
  }

  void roomOpened(String consultationId) =>
      _openRooms.update(consultationId, (n) => n + 1, ifAbsent: () => 1);

  void roomClosed(String consultationId) {
    final n = (_openRooms[consultationId] ?? 1) - 1;
    n <= 0 ? _openRooms.remove(consultationId) : _openRooms[consultationId] = n;
  }

  /// A room screen for [consultationId] is somewhere in the navigation stack.
  bool isRoomOpen(String consultationId) =>
      _openRooms.containsKey(consultationId);
}

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
    return ListenableBuilder(
      listenable: Listenable.merge([hub, CallPip.inPip]),
      builder: (context, _) {
        final c = hub.controller;
        final info = hub.info;
        final minimized = c != null && info != null && !hub.expanded;
        // In the system's picture-in-picture window there is room for one
        // thing, and it is the other person — not the app screen behind them,
        // scaled down to the size of a stamp.
        final pip = CallPip.inPip.value && c != null && info != null;
        return _PhaseGate(
          controller: minimized || pip ? c : null,
          builder: (context, state) {
            if (pip && state != null) {
              return _PipView(state: state, peerName: info.peerName);
            }
            final showBar =
                minimized && state != null && !info.video && _visible(state);
            final showFloat =
                minimized && state != null && info.video && _visible(state);
            return Column(
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
            );
          },
        );
      },
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

/// Rebuilds with the controller's state (or `null` without a controller).
class _PhaseGate extends StatelessWidget {
  const _PhaseGate({required this.controller, required this.builder});
  final CallController? controller;
  final Widget Function(BuildContext context, CallState? state) builder;

  @override
  Widget build(BuildContext context) {
    final c = controller;
    return StreamBuilder<CallState>(
      key: ObjectKey(c),
      stream: c?.stream,
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

/// Voice call in progress, shown above the app while the call is minimized:
/// who, the running time, mute and hang-up. Tap anywhere else to go back.
class CallMiniBar extends StatelessWidget {
  const CallMiniBar({
    required this.info,
    required this.state,
    required this.onOpen,
    required this.onMute,
    required this.onEnd,
    this.strings = const CallStrings(),
    this.color,
    super.key,
  });

  final CallInfo info;
  final CallState state;
  final CallStrings strings;
  final Color? color;
  final VoidCallback onOpen;
  final VoidCallback onMute;
  final VoidCallback onEnd;

  static const defaultColor = Color(0xFF1E9E5A);

  @override
  Widget build(BuildContext context) {
    final bg = state.phase == CallPhase.reconnecting
        ? const Color(0xFFB7791F)
        : (color ?? defaultColor);
    final top = MediaQuery.paddingOf(context).top;
    final text = Theme.of(context).textTheme;
    return Material(
      color: bg,
      child: InkWell(
        onTap: onOpen,
        child: Padding(
          padding: EdgeInsets.fromLTRB(14, top + 4, 6, 4),
          child: SizedBox(
            height: 44,
            child: Row(
              children: [
                const _PulsingIcon(icon: Icons.call_rounded),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        info.peerName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: text.titleSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        strings.tapToReturn,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: text.labelSmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                _Ticker(
                  state: state,
                  builder: (_) => Text(
                    _miniStatus(state, strings),
                    style: text.titleSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                IconButton(
                  tooltip: strings.mute,
                  onPressed: onMute,
                  color: Colors.white,
                  icon: Icon(
                    state.muted ? Icons.mic_off_rounded : Icons.mic_rounded,
                  ),
                ),
                IconButton(
                  tooltip: strings.endCall,
                  onPressed: onEnd,
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFFE5484D),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(36, 36),
                  ),
                  icon: const Icon(Icons.call_end_rounded, size: 20),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PulsingIcon extends StatefulWidget {
  const _PulsingIcon({required this.icon});
  final IconData icon;

  @override
  State<_PulsingIcon> createState() => _PulsingIconState();
}

class _PulsingIconState extends State<_PulsingIcon>
    with SingleTickerProviderStateMixin {
  late final _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
    opacity: Tween(begin: 0.55, end: 1.0).animate(_c),
    child: Icon(widget.icon, color: Colors.white, size: 20),
  );
}

/// Video call in progress, as a small window over the app while minimized.
/// Drag it anywhere (it snaps to the nearest side). Tap for controls — mute,
/// camera, flip, hang up, full screen; double-tap goes straight back.
class CallFloatingWindow extends StatefulWidget {
  const CallFloatingWindow({
    required this.info,
    required this.state,
    required this.onExpand,
    required this.onMute,
    required this.onCamera,
    required this.onFlip,
    required this.onEnd,
    this.strings = const CallStrings(),
    super.key,
  });

  final CallInfo info;
  final CallState state;
  final CallStrings strings;
  final VoidCallback onExpand;
  final VoidCallback onMute;
  final VoidCallback onCamera;
  final VoidCallback onFlip;
  final VoidCallback onEnd;

  static const size = Size(124, 184);

  @override
  State<CallFloatingWindow> createState() => _CallFloatingWindowState();
}

class _CallFloatingWindowState extends State<CallFloatingWindow> {
  static const _margin = 12.0;

  Offset? _pos;
  bool _dragging = false;
  bool _controls = false;
  Timer? _hide;

  @override
  void dispose() {
    _hide?.cancel();
    super.dispose();
  }

  Rect _bounds(BoxConstraints c, EdgeInsets pad) => Rect.fromLTRB(
    _margin + pad.left,
    _margin + pad.top,
    c.maxWidth - CallFloatingWindow.size.width - _margin - pad.right,
    c.maxHeight - CallFloatingWindow.size.height - _margin - pad.bottom - 64,
  );

  Offset _clamp(Offset p, Rect b) => Offset(
    p.dx.clamp(b.left, b.right < b.left ? b.left : b.right),
    p.dy.clamp(b.top, b.bottom < b.top ? b.top : b.bottom),
  );

  void _toggleControls() {
    setState(() => _controls = !_controls);
    _hide?.cancel();
    if (_controls) {
      _hide = Timer(const Duration(seconds: 4), () {
        if (mounted) setState(() => _controls = false);
      });
    }
  }

  /// Run a control and keep the controls up a little longer.
  void _act(VoidCallback f) {
    f();
    _hide?.cancel();
    _hide = Timer(const Duration(seconds: 4), () {
      if (mounted) setState(() => _controls = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final pad = MediaQuery.paddingOf(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final bounds = _bounds(constraints, pad);
        final pos = _clamp(_pos ?? bounds.topRight, bounds);
        return AnimatedPositioned(
          duration: _dragging
              ? Duration.zero
              : const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          left: pos.dx,
          top: pos.dy,
          width: CallFloatingWindow.size.width,
          height: CallFloatingWindow.size.height,
          child: GestureDetector(
            onTap: _toggleControls,
            onDoubleTap: widget.onExpand,
            onPanStart: (_) => setState(() => _dragging = true),
            onPanUpdate: (d) =>
                setState(() => _pos = _clamp(pos + d.delta, bounds)),
            onPanEnd: (d) {
              final mid = constraints.maxWidth / 2;
              final centre = pos.dx + CallFloatingWindow.size.width / 2;
              final vx = d.velocity.pixelsPerSecond.dx;
              final right = vx.abs() > 300 ? vx > 0 : centre > mid;
              setState(() {
                _dragging = false;
                _pos = Offset(right ? bounds.right : bounds.left, pos.dy);
              });
            },
            child: _window(context),
          ),
        );
      },
    );
  }

  Widget _window(BuildContext context) {
    final s = widget.state;
    final strings = widget.strings;
    return Material(
      elevation: 10,
      shadowColor: Colors.black54,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      color: const Color(0xFF1B1036),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (s.showRemoteVideo)
            CallVideoView(stream: s.remoteVideo)
          else
            _FloatAvatar(
              name: widget.info.peerName,
              url: widget.info.peerAvatarUrl,
            ),
          // status chip
          Positioned(
            left: 6,
            right: 6,
            bottom: 6,
            child: Row(
              children: [
                if (s.muted)
                  const Padding(
                    padding: EdgeInsets.only(right: 4),
                    child: _Chip(
                      child: Icon(
                        Icons.mic_off_rounded,
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                Flexible(
                  child: _Chip(
                    child: _Ticker(
                      state: s,
                      builder: (_) => Text(
                        _miniStatus(s, strings),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          fontFeatures: [FontFeature.tabularFigures()],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // controls
          IgnorePointer(
            ignoring: !_controls,
            child: AnimatedOpacity(
              opacity: _controls ? 1 : 0,
              duration: const Duration(milliseconds: 160),
              child: ColoredBox(
                color: Colors.black.withValues(alpha: 0.55),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _FloatButton(
                          icon: Icons.flip_camera_ios_rounded,
                          tooltip: strings.flipCamera,
                          onTap: s.cameraOn ? () => _act(widget.onFlip) : null,
                        ),
                        _FloatButton(
                          icon: Icons.open_in_full_rounded,
                          tooltip: strings.tapToReturn,
                          onTap: widget.onExpand,
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _FloatButton(
                          icon: s.muted
                              ? Icons.mic_off_rounded
                              : Icons.mic_rounded,
                          tooltip: strings.mute,
                          active: s.muted,
                          onTap: () => _act(widget.onMute),
                        ),
                        _FloatButton(
                          icon: s.cameraOn
                              ? Icons.videocam_rounded
                              : Icons.videocam_off_rounded,
                          tooltip: strings.camera,
                          active: !s.cameraOn,
                          onTap: () => _act(widget.onCamera),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _FloatButton(
                      icon: Icons.call_end_rounded,
                      tooltip: strings.endCall,
                      background: const Color(0xFFE5484D),
                      onTap: widget.onEnd,
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FloatAvatar extends StatelessWidget {
  const _FloatAvatar({required this.name, this.url});
  final String name;
  final String? url;

  @override
  Widget build(BuildContext context) {
    final initial = name.trim().isEmpty ? '?' : name.trim()[0].toUpperCase();
    final u = url;
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF140B2E), Color(0xFF2A1454)],
        ),
      ),
      child: Center(
        child: CircleAvatar(
          radius: 32,
          backgroundColor: const Color(0xFF3D2A6E),
          foregroundImage: (u != null && u.isNotEmpty) ? NetworkImage(u) : null,
          child: Text(
            initial,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: Colors.black.withValues(alpha: 0.55),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      child: child,
    ),
  );
}

class _FloatButton extends StatelessWidget {
  const _FloatButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.active = false,
    this.background,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onTap;
  final bool active;
  final Color? background;

  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: tooltip,
    onPressed: onTap,
    iconSize: 18,
    visualDensity: VisualDensity.compact,
    style: IconButton.styleFrom(
      backgroundColor:
          background ??
          (active ? Colors.white : Colors.white.withValues(alpha: 0.16)),
      foregroundColor: active && background == null
          ? const Color(0xFF1B1036)
          : Colors.white,
      disabledForegroundColor: Colors.white38,
      minimumSize: const Size(34, 34),
    ),
    icon: Icon(icon),
  );
}
