import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../engine/chat_controller.dart';
import '../models/chat_message.dart';
import 'chat_composer.dart';
import 'connection_banner.dart';
import 'pinned_bar.dart';
import 'message_bubble.dart';
import 'message_grouping.dart';
import 'swipe_to_reply.dart';
import 'typing_indicator.dart';

/// The full chat surface: connection banner + message list (with day separators,
/// scroll-up pagination, typing indicator) + composer. Drop it in a Scaffold
/// body; the app owns the AppBar (use [ChatHeaderStatus] for the subtitle).
///
/// Provide the [ChatController] above this widget with a `BlocProvider`.
class ChatView extends StatefulWidget {
  const ChatView({
    this.composerEnabled = true,
    this.composerHint = 'Message',
    this.aboveComposer,
    this.footer,
    this.systemLabel,
    this.onOpenShared,
    super.key,
  });

  final bool composerEnabled;
  final String composerHint;

  /// An app-supplied card at the very end of the thread, below the newest
  /// message — where the room says what is happening *now*: a request being
  /// answered, a session being billed, the wrap-up and the way to start again.
  /// Part of the conversation rather than a bar bolted around it, so it
  /// scrolls with the messages and reads like one.
  final Widget? footer;

  /// The app's wording for system lines; see [MessageBubble.systemLabel].
  final String? Function(ChatMessage message)? systemLabel;

  /// Opens the kundali or match report behind a shared-details card.
  final void Function(SharedDetails details)? onOpenShared;

  /// An app-supplied strip above the composer — the astrologer's quick
  /// replies. `insert` puts text into the field for editing.
  final Widget Function(BuildContext context, void Function(String) insert)?
  aboveComposer;

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final _scroll = ScrollController();
  int _lastCount = 0;

  /// How far up the list counts as "not at the bottom". Generous, so the
  /// button does not flicker in and out while someone reads the last screen.
  static const _awayFromBottom = 240.0;

  bool _away = false;

  /// Messages that arrived while the reader was scrolled up. Reset when they
  /// come back down, because that is when they have actually seen them.
  int _missed = 0;

  /// Track which message dedupeKeys are "new" (just appeared) so we can
  /// animate only those. Cleared after the post-frame callback fires.
  final Set<String> _newKeys = {};

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _onScroll() {
    // reverse:true — hitting the max extent means we've scrolled to the top.
    if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 200) {
      context.read<ChatController>().loadOlder();
    }
    // ...and offset 0 is the newest message.
    final away = _scroll.position.pixels > _awayFromBottom;
    if (away != _away) {
      setState(() {
        _away = away;
        if (!away) _missed = 0;
      });
    }
  }

  void _toBottom() {
    if (!_scroll.hasClients) return;
    setState(() => _missed = 0);
    _scroll.animateTo(
      0,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOut,
    );
  }

  // ---------------------------------------------------------------------------
  // Scroll intelligence: only scroll-to-bottom when the user is already near
  // the bottom. Use addPostFrameCallback so the list has settled before we
  // measure — this prevents the layout-first-then-jerk problem.
  // ---------------------------------------------------------------------------
  void _handleNewMessages(int arrived) {
    if (!_scroll.hasClients) return;
    if (_away) {
      setState(() => _missed += arrived);
    } else {
      // Wait one frame for the new item to be laid out, then animate.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !_scroll.hasClients) return;
        _scroll.animateTo(
          0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.read<ChatController>();

    // ── OUTER: only rebuild the full list tree when the message list length
    //    changes, loading state flips, typing starts/stops, or a reply bar
    //    appears/disappears.
    //
    //    Receipts, connection, pins, recording — all handled by isolated child
    //    widgets with their own buildWhen, so they don't cascade here.
    return BlocConsumer<ChatController, ChatSessionState>(
      listenWhen: (a, b) =>
      a.messages.length != b.messages.length ||
          a.jumpToSeq != b.jumpToSeq,
      buildWhen: (a, b) =>
      a.messages.length != b.messages.length ||
          a.loading != b.loading ||
          a.loadingOlder != b.loadingOlder ||
          a.otherTyping != b.otherTyping ||
          a.replyingTo != b.replyingTo,
      listener: (context, state) {
        final jump = state.jumpToSeq;
        if (jump != null) {
          _scrollToSeq(jump, state);
          context.read<ChatController>().jumpHandled();
        }
        final arrived = state.messages.length - _lastCount;
        if (arrived > 0) {
          // Record the keys of newly appeared messages for their entry animation.
          final start = state.messages.length - arrived;
          for (var i = start; i < state.messages.length; i++) {
            _newKeys.add(state.messages[i].dedupeKey);
          }
          _handleNewMessages(arrived);
        }
        _lastCount = state.messages.length;
      },
      builder: (context, state) {
        if (state.loading && state.messages.isEmpty) {
          return const Center(child: ChatSkeletonLoader());
        }

        final rows = _rows(state);

        // Clear entry-animation keys after this frame so subsequent rebuilds
        // (receipts, etc.) don't re-trigger the animation on existing messages.
        WidgetsBinding.instance.addPostFrameCallback((_) => _newKeys.clear());

        return Column(
          children: [
            // Isolated: rebuilds only when connection status changes.
            _ConnectionBannerBridge(),
            // Isolated: rebuilds only when pins list changes.
            _PinnedBarBridge(
              onTap: (seq) => _scrollToSeq(seq, state),
              onUnpin: c.unpin,
            ),
            Expanded(
              child: Stack(
                children: [
                  ListView.builder(
                    controller: _scroll,
                    reverse: true,
                    padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                    itemCount: rows.length + (state.loadingOlder ? 1 : 0),
                    itemBuilder: (context, i) {
                      if (i >= rows.length) {
                        return const Padding(
                          padding: EdgeInsets.all(12),
                          child: Center(
                            child: SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        );
                      }
                      final row = rows[i];
                      return switch (row) {
                        _FooterRow() => widget.footer!,
                        _TypingRow() => const TypingIndicator(),
                        _DateRow(:final label) => _DaySeparator(label: label),
                        _MsgRow(
                            :final message,
                            :final continuesAbove,
                            :final continuesBelow,
                        ) =>
                        // ValueKey on _MessageEntry gives the list a stable
                        // identity so it reuses rather than recreates the
                        // widget when the list grows.
                        _MessageEntry(
                          key: ValueKey(message.dedupeKey),
                          animate: _newKeys.contains(message.dedupeKey),
                          child: _SeenReporter(
                            seq: message.seq,
                            controller: c,
                            child: SwipeToReply(
                              enabled:
                              widget.composerEnabled &&
                                  (!message.isSystem || message.isKundaliRef),
                              reverse: message.senderRole == c.identity.role,
                              onReply: () => c.replyTo(message),
                              child: MessageBubble(
                                // Stable key inside SwipeToReply too, so the
                                // bubble state (_showOriginal etc.) survives
                                // a parent rebuild.
                                key: ValueKey('bubble:${message.dedupeKey}'),
                                message: message,
                                controller: c,
                                continuesAbove: continuesAbove,
                                continuesBelow: continuesBelow,
                                systemLabel: widget.systemLabel,
                                onOpenShared: widget.onOpenShared,
                              ),
                            ),
                          ),
                        ),
                      };
                    },
                  ),
                  if (_away)
                    Positioned(
                      right: 12,
                      bottom: 12,
                      child: _ToBottomButton(missed: _missed, onTap: _toBottom),
                    ),
                ],
              ),
            ),
            if (state.replyingTo != null)
              ReplyBar(
                quoted: state.replyingTo!,
                mine: state.replyingTo!.senderRole == c.identity.role,
                onCancel: () => c.replyTo(null),
              ),
            ChatComposer(
              controller: c,
              enabled: widget.composerEnabled,
              hint: widget.composerHint,
              above: widget.aboveComposer,
            ),
          ],
        );
      },
    );
  }

  /// Newest-first rows (list is reverse:true) with day separators + a typing row.
  void _scrollToSeq(int seq, ChatSessionState state) {
    final rows = _rows(state);
    final index = rows.indexWhere((r) => r is _MsgRow && r.message.seq == seq);
    if (index < 0 || !_scroll.hasClients) return;
    _scroll.animateTo(
      (index * 72.0).clamp(0.0, _scroll.position.maxScrollExtent),
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  List<_Row> _rows(ChatSessionState state) {
    final out = <_Row>[];
    if (widget.footer != null) out.add(const _FooterRow());
    if (state.otherTyping) out.add(const _TypingRow());
    final msgs = state.messages;
    for (var i = msgs.length - 1; i >= 0; i--) {
      final m = msgs[i];
      final prev = i > 0 ? msgs[i - 1] : null;
      final next = i < msgs.length - 1 ? msgs[i + 1] : null;
      out.add(
        _MsgRow(
          m,
          continuesAbove: continuesTurn(prev, m),
          continuesBelow: continuesTurn(m, next),
        ),
      );
      final day = _day(m.createdAt);
      if (prev == null || _day(prev.createdAt) != day) {
        out.add(_DateRow(_dayLabel(m.createdAt)));
      }
    }
    return out;
  }

  String _day(DateTime? d) =>
      d == null ? '' : DateFormat('yyyy-MM-dd').format(d.toLocal());

  String _dayLabel(DateTime? d) {
    if (d == null) return '';
    final local = d.toLocal();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final that = DateTime(local.year, local.month, local.day);
    final diff = today
        .difference(that)
        .inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    if (diff < 7) return DateFormat('EEEE').format(local);
    return DateFormat('d MMM yyyy').format(local);
  }
}

// --- Isolated sub-widgets that only rebuild for their own state slice --------

/// Wraps [ConnectionBanner] with a scoped selector so connection-status changes
/// don't cascade a rebuild of the full message list.
class _ConnectionBannerBridge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatController, ChatSessionState>(
      buildWhen: (a, b) => a.connection != b.connection,
      builder: (context, state) => ConnectionBanner(status: state.connection),
    );
  }
}

/// Wraps [PinnedBar] and only rebuilds when the pins list actually changes.
class _PinnedBarBridge extends StatelessWidget {
  const _PinnedBarBridge({required this.onTap, required this.onUnpin});

  final void Function(int seq) onTap;
  final void Function(int seq) onUnpin;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatController, ChatSessionState>(
      buildWhen: (a, b) => a.pins != b.pins,
      builder: (context, state) {
        if (state.pins.isEmpty) return const SizedBox.shrink();
        return PinnedBar(pins: state.pins, onUnpin: onUnpin, onTap: onTap);
      },
    );
  }
}

// --- Subtle entry animation for newly inserted messages ---------------------

/// Wraps a new message bubble with a 200ms fade + tiny upward slide.
///
/// When [animate] is false (for existing messages on a re-render) this is a
/// zero-cost transparent passthrough — no AnimationController is created.
class _MessageEntry extends StatefulWidget {
  const _MessageEntry({required this.child, required this.animate, super.key});

  final Widget child;
  final bool animate;

  @override
  State<_MessageEntry> createState() => _MessageEntryState();
}

class _MessageEntryState extends State<_MessageEntry>
    with SingleTickerProviderStateMixin {
  AnimationController? _ctrl;
  Animation<double>? _opacity;
  Animation<Offset>? _slide;

  @override
  void initState() {
    super.initState();
    if (widget.animate) {
      _ctrl = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 250),
      );
      final curve = CurvedAnimation(parent: _ctrl!, curve: Curves.easeOutCubic);
      _opacity = curve;
      _slide = Tween<Offset>(
        begin: const Offset(0, 0.1), // slightly more slide
        end: Offset.zero,
      ).animate(curve);
      _ctrl!.forward();
    }
  }

  @override
  void dispose() {
    _ctrl?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = _ctrl;
    if (ctrl == null) return widget.child; // no animation — just render
    return SizeTransition(
      sizeFactor: _opacity!,
      axisAlignment: 1.0, // 1.0 aligns child to the bottom as it grows
      child: FadeTransition(
        opacity: _opacity!,
        child: SlideTransition(position: _slide!, child: widget.child),
      ),
    );
  }
}

// --- Row model ---------------------------------------------------------------

sealed class _Row {
  const _Row();
}

class _FooterRow extends _Row {
  const _FooterRow();
}

class _MsgRow extends _Row {
  const _MsgRow(this.message, {
    this.continuesAbove = false,
    this.continuesBelow = false,
  });

  final ChatMessage message;

  /// The message directly above is the same sender's, moments earlier.
  final bool continuesAbove;

  /// The message directly below is too — so this one carries no tail.
  final bool continuesBelow;
}

class _DateRow extends _Row {
  const _DateRow(this.label);

  final String label;
}

class _TypingRow extends _Row {
  const _TypingRow();
}

class _DaySeparator extends StatelessWidget {
  const _DaySeparator({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme
        .of(context)
        .colorScheme;
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w700,
            color: scheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

/// Reports a message as "seen" to the controller when it's built (i.e. on
/// screen), which drives delivered + read receipts.
class _SeenReporter extends StatefulWidget {
  const _SeenReporter({
    required this.seq,
    required this.controller,
    required this.child,
  });

  final int seq;
  final ChatController controller;
  final Widget child;

  @override
  State<_SeenReporter> createState() => _SeenReporterState();
}

class _SeenReporterState extends State<_SeenReporter> {
  @override
  void initState() {
    super.initState();
    if (widget.seq > 0) widget.controller.markSeen(widget.seq);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

/// A compact "online · typing… · last seen" line for the app's AppBar.
class ChatHeaderStatus extends StatelessWidget {
  const ChatHeaderStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatController, ChatSessionState>(
      buildWhen: (a, b) =>
      a.otherTyping != b.otherTyping ||
          a.presence != b.presence ||
          a.connection != b.connection,
      builder: (context, state) {
        final scheme = Theme
            .of(context)
            .colorScheme;
        final (String text, Color color) = state.otherTyping
            ? ('typing…', scheme.primary)
            : state.presence.otherOnline
            ? ('online', const Color(0xFF2E7D32))
            : state.presence.otherLastSeen != null
            ? (
        'last seen ${_ago(state.presence.otherLastSeen!)}',
        scheme.onSurfaceVariant,
        )
            : ('', scheme.onSurfaceVariant);
        if (text.isEmpty) return const SizedBox.shrink();
        return Text(
          text,
          style: TextStyle(
            fontSize: 11.5,
            color: color,
            fontWeight: FontWeight.w600,
          ),
        );
      },
    );
  }

  static String _ago(DateTime t) {
    final d = DateTime.now().difference(t);
    if (d.inMinutes < 1) return 'just now';
    if (d.inMinutes < 60) return '${d.inMinutes}m ago';
    if (d.inHours < 24) return '${d.inHours}h ago';
    return DateFormat('d MMM').format(t.toLocal());
  }
}

/// Back to the newest message, with what was missed on the way.
///
/// Reading back through a long conversation used to be a one-way trip: the
/// only way down was to keep flicking. The count matters as much as the
/// button — it is the difference between "nothing happened" and "answer them".
class _ToBottomButton extends StatelessWidget {
  const _ToBottomButton({required this.missed, required this.onTap});

  final int missed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme
        .of(context)
        .colorScheme;
    return Material(
      elevation: 3,
      color: scheme.surface,
      shape: const StadiumBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const StadiumBorder(),
        child: Padding(
          padding: EdgeInsets.fromLTRB(missed > 0 ? 12 : 8, 8, 8, 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (missed > 0) ...[
                Text(
                  '$missed',
                  style: TextStyle(
                    color: scheme.primary,
                    fontWeight: FontWeight.w800,
                    fontSize: 12.5,
                  ),
                ),
                const SizedBox(width: 6),
              ],
              Icon(
                Icons.keyboard_double_arrow_down_rounded,
                size: 18,
                color: scheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class ChatSkeletonLoader extends StatefulWidget {
  const ChatSkeletonLoader({super.key});

  @override
  State<ChatSkeletonLoader> createState() => _ChatRoomSkeletonState();
}

class _ChatRoomSkeletonState extends State<ChatSkeletonLoader>
    with SingleTickerProviderStateMixin {
  // Swap for your theme colors.
  static const _bg = Color(0xFFFFF8F5);
  static const _recv = Color(0xFFEFDDD6);
  static const _recvBar = Color(0xFFE2C9BE);
  static const _sent = Color(0xFF8E4B2C);
  static const _sentBar = Color(0x40FFFFFF);
  static const _card = Color(0xFFFFF0EB);
  static const _cardBorder = Color(0xFFEBD3C9);
  static const _neutral = Color(0xFFEBDAD2);

  // (isMine, textWidth) top to bottom, mirroring the real chat.
  static const _items = <(bool, double)>[
    (true, 60),
    (false, 190),
    (true, 80),
    (false, 50),
    (false, 110),
    (false, 50),
    (false, 150),
    (false, 240),
    (true, 50),
    (true, 200),
  ];

  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )
    ..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  Widget _b(double w, double h, {double? r, Color color = _neutral}) =>
      Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(r ?? h / 2),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: AnimatedBuilder(
        animation: _c,
        builder: (context, child) =>
            ShaderMask(
              blendMode: BlendMode.srcATop,
              shaderCallback: (rect) =>
                  LinearGradient(
                    begin: Alignment(-1.5 + 3 * _c.value, -0.3),
                    end: Alignment(-0.5 + 3 * _c.value, 0.3),
                    colors: const [
                      Color(0x00FFFFFF),
                      Color(0x66FFFFFF),
                      Color(0x00FFFFFF),
                    ],
                  ).createShader(rect),
              child: child,
            ),
        child: SafeArea(
          child: Column(
            children: [
              _appBar(),
              Expanded(
                child: SingleChildScrollView(
                  reverse: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                  child: Column(
                    children: [
                      for (final (mine, w) in _items) _bubble(mine, w),
                    ],
                  ),
                ),
              ),
              Center(child: _b(230, 36, color: _recv)), // "Chat ended" pill
              const SizedBox(height: 14),
              _ratingCard(),
              const SizedBox(height: 10),
              _composer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _appBar() =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            _b(24, 24, r: 12),
            const SizedBox(width: 20),
            _b(46, 46, r: 23), // avatar
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _b(140, 16), // name
                const SizedBox(height: 7),
                _b(100, 11), // consultation status
              ],
            ),
            const Spacer(),
            _b(24, 24, r: 12), // search
            const SizedBox(width: 22),
            _b(6, 24, r: 3), // more
            const SizedBox(width: 8),
          ],
        ),
      );

  Widget _bubble(bool mine, double width) {
    final bar = mine ? _sentBar : _recvBar;
    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
        decoration: BoxDecoration(
          color: mine ? _sent : _recv,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(mine ? 20 : 6),
            bottomRight: Radius.circular(mine ? 6 : 20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _b(width, 12, color: bar),
            const SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _b(12, 12, color: bar), // speaker icon
                const SizedBox(width: 8),
                _b(44, 8, color: bar), // time
                if (mine) ...[
                  const SizedBox(width: 8),
                  _b(14, 8, color: bar), // ticks
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _ratingCard() =>
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: _cardBorder),
        ),
        child: Column(
          children: [
            Row(
              children: [
                for (var i = 0; i < 5; i++) ...[
                  _b(22, 22, r: 5, color: _cardBorder), // stars
                  const SizedBox(width: 4),
                ],
                const SizedBox(width: 12),
                _b(150, 12), // "You rated this session"
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _b(22, 22, r: 6), // lock icon
                const SizedBox(width: 12),
                _b(220, 14), // "Consultation ended..."
              ],
            ),
            const SizedBox(height: 16),
            Container(
              height: 56,
              width: double.infinity,
              decoration: BoxDecoration(
                color: _sent,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Center(child: _b(140, 14, color: _sentBar)),
            ),
            const SizedBox(height: 12),
            _b(210, 10), // "Chat again with ..."
          ],
        ),
      );

  Widget _composer() =>
      Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: _cardBorder)),
        ),
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
        child: Row(
          children: [
            _b(28, 28, r: 7),
            const SizedBox(width: 14),
            Expanded(child: _b(double.infinity, 52, r: 26)),
            const SizedBox(width: 10),
            _b(52, 52, r: 26),
          ],
        ),
      );
}
