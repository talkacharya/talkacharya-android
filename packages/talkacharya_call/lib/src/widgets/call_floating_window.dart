part of 'call_overlay.dart';

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
          // _ControlsLayer uses FadeTransition instead of AnimatedOpacity:
          // AnimatedOpacity keeps a permanent GPU offscreen buffer for the
          // entire controls overlay. FadeTransition only composites during
          // the 160 ms fade — better for a video preview behind it.
          _ControlsLayer(
            visible: _controls,
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
        ],
      ),
    );
  }
}

/// Compositor-driven fade for the floating window controls panel.
/// Mirrors [_ChromeLayer] from call_screen.dart — FadeTransition composites
/// only during the 160 ms fade; AnimatedOpacity holds a GPU buffer always.
class _ControlsLayer extends StatefulWidget {
  const _ControlsLayer({required this.visible, required this.child});
  final bool visible;
  final Widget child;

  @override
  State<_ControlsLayer> createState() => _ControlsLayerState();
}

class _ControlsLayerState extends State<_ControlsLayer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 160),
    value: widget.visible ? 1.0 : 0.0,
  );

  @override
  void didUpdateWidget(_ControlsLayer old) {
    super.didUpdateWidget(old);
    if (old.visible != widget.visible) {
      widget.visible ? _c.forward() : _c.reverse();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _c,
    builder: (_, child) => IgnorePointer(
      ignoring: _c.value == 0,
      child: FadeTransition(opacity: _c, child: child),
    ),
    child: widget.child,
  );
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
    this.tooltip,
    required this.onTap,
    this.active = false,
    this.background,
  });

  final IconData icon;
  final String? tooltip;
  final VoidCallback? onTap;
  final bool active;
  final Color? background;

  @override
  Widget build(BuildContext context) => IconButton(
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
