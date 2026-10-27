import 'package:flutter/material.dart';

/// The shape of a chat while it loads, in the app's own colours.
///
/// * [ChatSkeleton.page] stands in for the whole room before anything is
///   known: an app bar with a working back button, bubbles, and the composer.
/// * [ChatSkeleton.body] is only the bubbles, for when the room's real app
///   bar and composer are already on screen.
///
/// Widths are fractions of the space it is given, never fixed pixels, so it
/// fits any phone and text size; whatever does not fit is clipped, not
/// overflowed. It guesses nothing about the session (no "chat ended", no
/// rating card).
class ChatSkeleton extends StatefulWidget {
  /// The whole room, app bar to composer.
  const ChatSkeleton.page({super.key}) : _page = true;

  /// The message area only.
  const ChatSkeleton.body({super.key}) : _page = false;

  final bool _page;

  @override
  State<ChatSkeleton> createState() => _ChatSkeletonState();
}

class _ChatSkeletonState extends State<ChatSkeleton>
    with SingleTickerProviderStateMixin {
  // (mine, width as a share of the row) from the bottom up, like a real chat.
  static const _bubbles = <(bool, double)>[
    (true, 0.62),
    (true, 0.34),
    (false, 0.72),
    (false, 0.48),
    (false, 0.30),
    (true, 0.55),
    (false, 0.66),
    (true, 0.40),
    (false, 0.52),
    (false, 0.36),
    (true, 0.58),
    (false, 0.44),
  ];

  late final AnimationController _shine = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // No shimmer for people who asked for less motion.
    final still = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    if (still) {
      _shine.stop();
    } else if (!_shine.isAnimating) {
      _shine.repeat();
    }
  }

  @override
  void dispose() {
    _shine.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = _Palette.of(theme);
    final still = MediaQuery.maybeDisableAnimationsOf(context) ?? false;

    Widget shimmer(Widget child) => still
        ? child
        : AnimatedBuilder(
            animation: _shine,
            builder: (context, child) => ShaderMask(
              blendMode: BlendMode.srcATop,
              shaderCallback: (rect) => LinearGradient(
                begin: Alignment(-1.5 + 3 * _shine.value, -0.3),
                end: Alignment(-0.5 + 3 * _shine.value, 0.3),
                colors: [
                  palette.shine.withValues(alpha: 0),
                  palette.shine,
                  palette.shine.withValues(alpha: 0),
                ],
              ).createShader(rect),
              child: child,
            ),
            child: child,
          );

    final messages = ClipRect(
      child: ListView(
        reverse: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        children: [
          for (final (mine, share) in _bubbles)
            _Bubble(mine: mine, share: share, palette: palette),
        ],
      ),
    );

    if (!widget._page) return shimmer(messages);

    return Scaffold(
      appBar: AppBar(
        // The real back button: nobody is stuck on a room that will not load.
        titleSpacing: 0,
        title: shimmer(
          Row(
            children: [
              _Block(width: 36, height: 36, color: palette.block),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Bar(share: 0.55, height: 14, color: palette.block),
                    const SizedBox(height: 6),
                    _Bar(share: 0.35, height: 10, color: palette.block),
                  ],
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(child: shimmer(messages)),
            Container(
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: palette.line)),
              ),
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              child: shimmer(
                Row(
                  children: [
                    _Block(
                      width: 28,
                      height: 28,
                      radius: 8,
                      color: palette.block,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _Block(
                        height: 46,
                        radius: 23,
                        color: palette.block,
                      ),
                    ),
                    const SizedBox(width: 10),
                    _Block(width: 46, height: 46, color: palette.block),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The skeleton's colours, taken from the theme the same way the real bubbles
/// take theirs, so each app (and dark mode) loads in its own look.
class _Palette {
  const _Palette({
    required this.sent,
    required this.sentBar,
    required this.received,
    required this.receivedBar,
    required this.block,
    required this.line,
    required this.shine,
  });

  factory _Palette.of(ThemeData theme) {
    final s = theme.colorScheme;
    final dark = theme.brightness == Brightness.dark;
    return _Palette(
      sent: s.primary.withValues(alpha: dark ? 0.45 : 0.30),
      sentBar: s.onPrimary.withValues(alpha: 0.35),
      received: s.surfaceContainerHighest,
      receivedBar: s.onSurface.withValues(alpha: 0.08),
      block: s.onSurface.withValues(alpha: 0.08),
      line: s.outlineVariant,
      shine: Colors.white.withValues(alpha: dark ? 0.08 : 0.4),
    );
  }

  final Color sent;
  final Color sentBar;
  final Color received;
  final Color receivedBar;
  final Color block;
  final Color line;
  final Color shine;
}

class _Bubble extends StatelessWidget {
  const _Bubble({
    required this.mine,
    required this.share,
    required this.palette,
  });

  final bool mine;
  final double share;
  final _Palette palette;

  @override
  Widget build(BuildContext context) {
    final bar = mine ? palette.sentBar : palette.receivedBar;
    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: FractionallySizedBox(
        widthFactor: share,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 3),
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
          decoration: BoxDecoration(
            color: mine ? palette.sent : palette.received,
            borderRadius: BorderRadius.circular(14).copyWith(
              bottomLeft: Radius.circular(mine ? 14 : 4),
              bottomRight: Radius.circular(mine ? 4 : 14),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              _Block(height: 10, color: bar),
              const SizedBox(height: 7),
              Align(
                alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
                child: _Bar(share: 0.4, height: 7, color: bar),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A rounded block; full width of its slot unless [width] is given.
class _Block extends StatelessWidget {
  const _Block({
    required this.height,
    required this.color,
    this.width,
    this.radius,
  });

  final double? width;
  final double height;
  final double? radius;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    width: width ?? double.infinity,
    height: height,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(radius ?? height / 2),
    ),
  );
}

/// A bar [share] of its slot's width.
class _Bar extends StatelessWidget {
  const _Bar({required this.share, required this.height, required this.color});

  final double share;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) => FractionallySizedBox(
    widthFactor: share,
    alignment: AlignmentDirectional.centerStart,
    child: _Block(height: height, color: color),
  );
}
