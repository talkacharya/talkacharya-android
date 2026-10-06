import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Drag a message sideways to reply to it.
///
/// Replying was a long-press and a menu, which is three deliberate actions for
/// something people do constantly. The gesture is the one every messaging app
/// has trained them to expect, and it costs nothing when unused.
///
/// It only pulls one way — the direction a reply arrow points — and gives the
/// message back if the drag is too short, so a scroll that wanders sideways
/// never fires it.
class SwipeToReply extends StatefulWidget {
  const SwipeToReply({
    required this.child,
    required this.onReply,
    this.enabled = true,
    this.reverse = false,
    super.key,
  });

  final Widget child;
  final VoidCallback onReply;
  final bool enabled;
  final bool reverse;

  @override
  State<SwipeToReply> createState() => _SwipeToReplyState();
}

class _SwipeToReplyState extends State<SwipeToReply>
    with SingleTickerProviderStateMixin {
  static const _trigger = 56.0;
  static const _maxPull = 76.0;

  double _offset = 0;
  bool _armed = false;

  void _update(DragUpdateDetails d) {
    if (!widget.enabled) return;
    final dx = widget.reverse ? -d.delta.dx : d.delta.dx;
    final next = (_offset + dx).clamp(0.0, _maxPull);
    final armed = next >= _trigger;
    if (armed != _armed) {
      // The buzz is the whole affordance: it says "let go now" without asking
      // anyone to watch a progress bar while they are reading.
      if (armed) HapticFeedback.selectionClick();
      _armed = armed;
    }
    setState(() => _offset = next);
  }

  void _end(DragEndDetails _) {
    if (_armed) widget.onReply();
    _armed = false;
    setState(() => _offset = 0);
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;
    final scheme = Theme.of(context).colorScheme;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onHorizontalDragStart: (_) {},
      onHorizontalDragUpdate: _update,
      onHorizontalDragEnd: _end,
      onHorizontalDragCancel: () {
        _armed = false;
        setState(() => _offset = 0);
      },
      child: Stack(
        alignment: widget.reverse ? Alignment.centerRight : Alignment.centerLeft,
        children: [
          if (_offset > 4)
            Padding(
              padding: widget.reverse 
                  ? const EdgeInsets.only(right: 12) 
                  : const EdgeInsets.only(left: 12),
              child: Opacity(
                opacity: (_offset / _trigger).clamp(0.0, 1.0),
                child: Icon(
                  Icons.reply_rounded,
                  size: 20,
                  color: _armed ? scheme.primary : scheme.onSurfaceVariant,
                ),
              ),
            ),
          AnimatedContainer(
            duration: Duration(milliseconds: _offset == 0 ? 160 : 0),
            curve: Curves.easeOut,
            transform: Matrix4.translationValues(
              widget.reverse ? -_offset : _offset, 0, 0
            ),
            child: widget.child,
          ),
        ],
      ),
    );
  }
}
