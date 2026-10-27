import 'dart:async';
import 'dart:math';

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
import 'chat_skeleton.dart';

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

class _ChatViewState extends State<ChatView> with WidgetsBindingObserver {
  final _scroll = ScrollController();

  /// Every message key the list has shown, and the newest number among them:
  /// what is new on the next change is what isn't in here, and it arrived at
  /// the bottom when it is unsent or newer than [_maxSeq] (not an older page).
  final Set<String> _knownKeys = {};
  int _maxSeq = 0;

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

  /// Where each message on screen (or just off it) is, by its number: what a
  /// tap on a reply or a pin scrolls to exactly, instead of a guess.
  final Map<int, BuildContext> _mounted = {};

  /// The message just jumped to, lit up for a moment so the eye finds it.
  int? _flashSeq;
  Timer? _flashTimer;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
    WidgetsBinding.instance.addObserver(this);
    // What is already on screen when the room mounts — loaded before it, from
    // the phone. Without this the first message after it was never "new":
    // no scroll down for one's own, no count for theirs.
    final open = context.read<ChatController>().state;
    _knownKeys.addAll(open.messages.map((m) => m.dedupeKey));
    _maxSeq = open.lastSeq;
    final now = WidgetsBinding.instance.lifecycleState;
    if (now != null) {
      context.read<ChatController>().setForeground(
        now == AppLifecycleState.resumed,
      );
    }
  }

  /// Read receipts follow what the user can see: a room behind another app
  /// (or a minimized call) still receives, but doesn't read.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    context.read<ChatController>().setForeground(
      state == AppLifecycleState.resumed,
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _flashTimer?.cancel();
    _scroll.dispose();
    super.dispose();
  }

  void _onScroll() {
    // reverse:true — the max extent is the top. Ask for the older page about
    // two screens before getting there, so it is in place by the time the
    // reader is, rather than them stopping at a spinner.
    final position = _scroll.position;
    final ahead = max(1200.0, position.viewportDimension * 2);
    if (position.pixels >= position.maxScrollExtent - ahead) {
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
  void _handleNewMessages(int arrived, {required bool mine}) {
    if (!_scroll.hasClients) return;
    // Something this person just sent: they want to see it go, wherever they
    // were reading — as in every messenger.
    if (mine) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _toBottom();
      });
      return;
    }
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
          a.messages.length != b.messages.length || a.jumpToSeq != b.jumpToSeq,
      buildWhen: (a, b) =>
          a.messages.length != b.messages.length ||
          a.loading != b.loading ||
          a.loadingOlder != b.loadingOlder ||
          a.replyingTo != b.replyingTo,
      listener: (context, state) {
        final jump = state.jumpToSeq;
        if (jump != null) {
          _scrollToSeq(jump, state);
          context.read<ChatController>().jumpHandled();
        }
        // New at the bottom = not shown before, and unsent or newer than
        // anything shown. An older page loading above is neither animated nor
        // counted as "new messages". The very first fill animates nothing.
        var arrived = 0;
        var mine = false;
        final me = context.read<ChatController>().identity.role;
        if (_knownKeys.isNotEmpty) {
          for (final m in state.messages) {
            if (_knownKeys.contains(m.dedupeKey)) continue;
            if (m.seq <= 0 || m.seq > _maxSeq) {
              _newKeys.add(m.dedupeKey);
              arrived++;
              if (m.seq <= 0 && m.senderRole == me) mine = true;
            }
          }
        }
        _knownKeys
          ..clear()
          ..addAll(state.messages.map((m) => m.dedupeKey));
        if (state.lastSeq > _maxSeq) _maxSeq = state.lastSeq;
        if (arrived > 0) _handleNewMessages(arrived, mine: mine);
      },
      builder: (context, state) {
        if (state.loading && state.messages.isEmpty) {
          return const ChatSkeleton.body();
        }

        final rows = _rows(state);
        // Where each message sits now, so the list keeps a bubble's widget when
        // a new message pushes it up one row instead of rebuilding every
        // bubble on screen (images reloading, players resetting).
        final indexOf = <String, int>{
          for (var i = 0; i < rows.length; i++)
            if (rows[i] case _MsgRow(:final message)) message.dedupeKey: i,
        };

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
                    findChildIndexCallback: (key) =>
                        key is ValueKey<String> ? indexOf[key.value] : null,
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
                            seq: message.seq,
                            registry: _mounted,
                            highlight:
                                _flashSeq != null && _flashSeq == message.seq,
                            animate: _newKeys.contains(message.dedupeKey),
                            child: _SeenReporter(
                              seq: message.seq,
                              mine: message.senderRole == c.identity.role,
                              controller: c,
                              // The list rebuilds only when messages come or go;
                              // each bubble follows its own message, so ticks,
                              // "sending…", "failed" and translations change in
                              // place the moment they change.
                              child: _LiveMessage(
                                initial: message,
                                builder: (live) => SwipeToReply(
                                  enabled:
                                      widget.composerEnabled &&
                                      (!live.isSystem || live.isKundaliRef),
                                  reverse: live.senderRole == c.identity.role,
                                  onReply: () => c.replyTo(live),
                                  child: MessageBubble(
                                    // Stable key inside SwipeToReply too, so the
                                    // bubble state (_showOriginal etc.) survives
                                    // a parent rebuild.
                                    key: ValueKey('bubble:${live.dedupeKey}'),
                                    message: live,
                                    controller: c,
                                    continuesAbove: continuesAbove,
                                    continuesBelow: continuesBelow,
                                    systemLabel: widget.systemLabel,
                                    onOpenShared: widget.onOpenShared,
                                  ),
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

  /// Scroll to message [seq] and light it up. A bubble already built is
  /// scrolled to exactly; one far off is approached by estimate first (rows
  /// have no fixed height), then found and scrolled to once it is built.
  Future<void> _scrollToSeq(int seq, ChatSessionState state) async {
    final rows = _rows(state);
    final index = rows.indexWhere((r) => r is _MsgRow && r.message.seq == seq);
    if (index < 0) return;
    for (var attempt = 0; attempt < 6; attempt++) {
      if (!mounted || !_scroll.hasClients) return;
      final ctx = _mounted[seq];
      if (ctx != null && ctx.mounted) {
        await Scrollable.ensureVisible(
          ctx,
          alignment: 0.4,
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutCubic,
        );
        _flash(seq);
        return;
      }
      final position = _scroll.position;
      final perRow = rows.isEmpty
          ? 72.0
          : (position.maxScrollExtent + position.viewportDimension) /
                rows.length;
      _scroll.jumpTo(
        (index * perRow).clamp(0.0, position.maxScrollExtent).toDouble(),
      );
      await WidgetsBinding.instance.endOfFrame;
    }
  }

  void _flash(int seq) {
    if (!mounted) return;
    _flashTimer?.cancel();
    setState(() => _flashSeq = seq);
    _flashTimer = Timer(const Duration(milliseconds: 1400), () {
      if (mounted) setState(() => _flashSeq = null);
    });
  }

  /// Newest-first rows (list is reverse:true) with day separators.

  List<_Row> _rows(ChatSessionState state) {
    final out = <_Row>[];
    if (widget.footer != null) out.add(const _FooterRow());
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
    final diff = today.difference(that).inDays;
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
  const _MessageEntry({
    required this.child,
    required this.animate,
    required this.seq,
    required this.registry,
    this.highlight = false,
    super.key,
  });

  final Widget child;
  final bool animate;

  /// This message's number, and the map it says where it is in (see
  /// `_ChatViewState._mounted`). 0 = not sent yet: nothing jumps to it.
  final int seq;
  final Map<int, BuildContext> registry;

  /// Lit for a moment after a jump to it.
  final bool highlight;

  @override
  State<_MessageEntry> createState() => _MessageEntryState();
}

class _MessageEntryState extends State<_MessageEntry>
    with SingleTickerProviderStateMixin {
  AnimationController? _ctrl;
  Animation<double>? _opacity;
  Animation<Offset>? _slide;

  void _register() {
    if (widget.seq > 0) widget.registry[widget.seq] = context;
  }

  void _unregister(int seq) {
    if (seq > 0 && identical(widget.registry[seq], context)) {
      widget.registry.remove(seq);
    }
  }

  @override
  void didUpdateWidget(covariant _MessageEntry old) {
    super.didUpdateWidget(old);
    // An unsent message gets its number from the server.
    if (old.seq != widget.seq) {
      _unregister(old.seq);
      _register();
    }
  }

  @override
  void initState() {
    super.initState();
    _register();
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
    _unregister(widget.seq);
    _ctrl?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lit = AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: widget.highlight
            ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.12)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: widget.child,
    );
    final ctrl = _ctrl;
    if (ctrl == null) return lit; // no animation — just render
    return SizeTransition(
      sizeFactor: _opacity!,
      axisAlignment: 1.0, // 1.0 aligns child to the bottom as it grows
      child: FadeTransition(
        opacity: _opacity!,
        child: SlideTransition(position: _slide!, child: lit),
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
  const _MsgRow(
    this.message, {
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

class _DaySeparator extends StatelessWidget {
  const _DaySeparator({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
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
/// Tells the controller when one of the other side's messages is laid out —
/// on screen, or just about to be. The controller decides whether that counts
/// as read (room in view) or only delivered.
class _SeenReporter extends StatefulWidget {
  const _SeenReporter({
    required this.seq,
    required this.mine,
    required this.controller,
    required this.child,
  });

  final int seq;
  final bool mine;
  final ChatController controller;
  final Widget child;

  @override
  State<_SeenReporter> createState() => _SeenReporterState();
}

class _SeenReporterState extends State<_SeenReporter> {
  @override
  void initState() {
    super.initState();
    if (widget.seq > 0 && !widget.mine) widget.controller.markSeen(widget.seq);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

/// One message, followed in the controller's state by its key: rebuilds when
/// that message changes (a receipt, a send confirmed or failed, a translation)
/// and not when any other one does.
class _LiveMessage extends StatelessWidget {
  const _LiveMessage({required this.initial, required this.builder});

  final ChatMessage initial;
  final Widget Function(ChatMessage message) builder;

  @override
  Widget build(BuildContext context) {
    final key = initial.dedupeKey;
    return BlocSelector<ChatController, ChatSessionState, ChatMessage>(
      selector: (s) {
        for (final m in s.messages) {
          if (m.dedupeKey == key) return m;
        }
        return initial;
      },
      builder: (context, message) => builder(message),
    );
  }
}

/// A compact "online · typing… · last seen" line for the app's AppBar.
class ChatHeaderStatus extends StatelessWidget {
  const ChatHeaderStatus({this.idle, super.key});

  /// Shown instead of online / last seen when the other side isn't typing —
  /// e.g. a finished session's "ended". Typing always shows: the free
  /// follow-up after a session is still a conversation.
  final Widget? idle;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatController, ChatSessionState>(
      buildWhen: (a, b) =>
          a.otherTyping != b.otherTyping ||
          a.presence != b.presence ||
          a.connection != b.connection,
      builder: (context, state) {
        final scheme = Theme.of(context).colorScheme;
        if (!state.otherTyping && idle != null) return idle!;
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
    final scheme = Theme.of(context).colorScheme;
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
