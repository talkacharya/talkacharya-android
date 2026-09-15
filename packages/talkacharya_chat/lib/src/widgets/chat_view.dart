import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../engine/chat_controller.dart';
import '../models/chat_message.dart';
import 'chat_composer.dart';
import 'connection_banner.dart';
import 'message_bubble.dart';
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
    super.key,
  });

  final bool composerEnabled;
  final String composerHint;

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final _scroll = ScrollController();
  int _lastCount = 0;

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
  }

  @override
  Widget build(BuildContext context) {
    final c = context.read<ChatController>();
    return BlocConsumer<ChatController, ChatSessionState>(
      listenWhen: (a, b) => a.messages.length != b.messages.length,
      listener: (_, state) {
        // stick to bottom when a new message arrives (reverse list => offset 0)
        if (state.messages.length > _lastCount && _scroll.hasClients) {
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
            Expanded(
              child: ListView.builder(
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
                    _MsgRow(:final message) => _SeenReporter(
                      seq: message.seq,
                      controller: c,
                      child: MessageBubble(message: message, controller: c),
                    ),
                  };
                },
              ),
            ),
            ChatComposer(
              controller: c,
              enabled: widget.composerEnabled,
              hint: widget.composerHint,
            ),
          ],
        );
      },
    );
  }

  /// Newest-first rows (list is reverse:true) with day separators + a typing row.
  List<_Row> _rows(ChatSessionState state) {
    final out = <_Row>[];
    if (state.otherTyping) out.add(const _TypingRow());
    final msgs = state.messages;
    for (var i = msgs.length - 1; i >= 0; i--) {
      final m = msgs[i];
      out.add(_MsgRow(m));
      final prev = i > 0 ? msgs[i - 1] : null;
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
  const _MsgRow(this.message);
  final ChatMessage message;
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
