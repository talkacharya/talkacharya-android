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
    super.key,
  });

  final bool composerEnabled;
  final String composerHint;

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

  @override
  Widget build(BuildContext context) {
    final c = context.read<ChatController>();
    return BlocConsumer<ChatController, ChatSessionState>(
      listenWhen: (a, b) => a.messages.length != b.messages.length,
      listener: (_, state) {
        final arrived = state.messages.length - _lastCount;
        if (arrived > 0 && _scroll.hasClients) {
          if (_away) {
            // Someone reading back through the conversation must not be
            // dragged to the bottom by a message they have not asked for.
            setState(() => _missed += arrived);
          } else {
            // stick to bottom (reverse list => offset 0)
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (_scroll.hasClients) {
                _scroll.animateTo(
                  0,
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOut,
                );
              }
            });
          }
        }
        _lastCount = state.messages.length;
      },
      builder: (context, state) {
        if (state.loading && state.messages.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final rows = _rows(state);
        return Column(
          children: [
            ConnectionBanner(status: state.connection),
            if (state.pins.isNotEmpty)
              PinnedBar(
                pins: state.pins,
                onUnpin: c.unpin,
                onTap: (seq) => _scrollToSeq(seq, state),
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
                        _TypingRow() => const TypingIndicator(),
                        _DateRow(:final label) => _DaySeparator(label: label),
                        _MsgRow(
                          :final message,
                          :final continuesAbove,
                          :final continuesBelow,
                        ) =>
                          _SeenReporter(
                            seq: message.seq,
                            controller: c,
                            child: SwipeToReply(
                              // Nothing to quote on a system line, and a card is
                              // its own thing.
                              enabled:
                                  widget.composerEnabled &&
                                  !message.isSystem &&
                                  !message.isKundaliRef,
                              onReply: () => c.replyTo(message),
                              child: MessageBubble(
                                message: message,
                                controller: c,
                                continuesAbove: continuesAbove,
                                continuesBelow: continuesBelow,
                              ),
                            ),
                          ),
                      };
                    },
                  ),
                  // A way back to the newest message, and a count of what
                  // arrived while the reader was elsewhere in the history.
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
  /// Bring the message at [seq] into view, if it is in the loaded window.
  ///
  /// The list is `reverse: true` and mixes messages with day separators, so the
  /// index has to be counted off the same rows the builder draws. A pin that
  /// points further back than what is loaded simply doesn't move — better than
  /// jumping somewhere arbitrary.
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
    final diff = today.difference(that).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    if (diff < 7) return DateFormat('EEEE').format(local);
    return DateFormat('d MMM yyyy').format(local);
  }
}

// --- row model -----------------------------------------------------------

sealed class _Row {
  const _Row();
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

class _TypingRow extends _Row {
  const _TypingRow();
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
        final scheme = Theme.of(context).colorScheme;
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
