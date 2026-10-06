part of 'call_overlay.dart';

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
          // Use padding-based height instead of a fixed SizedBox so the bar
          // grows with status bar inset and never overflows.
          padding: EdgeInsets.fromLTRB(14, top + 6, 6, 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const _PulsingIcon(icon: Icons.call_rounded),
              const SizedBox(width: 10),
              // Expanded takes all leftover width — name, sub-label and the
              // running timer all live here, safe from overflow.
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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
                    _Ticker(
                      state: state,
                      builder: (_) => Text(
                        _miniStatus(state, strings),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: text.labelSmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontWeight: FontWeight.w600,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Compact icon buttons — shrinkWrap removes the default 48px
              // minimum tap target so they never push the Row wider.
              IconButton(
                onPressed: onMute,
                color: Colors.white,
                padding: const EdgeInsets.all(8),
                constraints: const BoxConstraints(),
                style: IconButton.styleFrom(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                icon: Icon(
                  state.muted ? Icons.mic_off_rounded : Icons.mic_rounded,
                  size: 22,
                ),
              ),
              const SizedBox(width: 4),
              IconButton(
                onPressed: onEnd,
                padding: const EdgeInsets.all(6),
                constraints: const BoxConstraints(),
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFFE5484D),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(34, 34),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                icon: const Icon(Icons.call_end_rounded, size: 18),
              ),
            ],
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
