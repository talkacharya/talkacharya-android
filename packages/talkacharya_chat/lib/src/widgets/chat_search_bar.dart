import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../engine/chat_controller.dart';
import '../models/chat_message.dart';

/// Search within one thread.
///
/// A conversation that spans five readings has the useful answer somewhere
/// months above the loaded window — "what stone did you tell me to wear?" is
/// the single most common thing people scroll for and never find.
///
/// Drop it in an AppBar's `bottom`, or anywhere above the transcript.
class ChatSearchBar extends StatefulWidget {
  const ChatSearchBar({
    required this.onJumpTo,
    this.hint = 'Search this conversation',
    this.emptyText = 'Nothing found',
    super.key,
  });

  /// Called with the sequence of the message the reader picked.
  final void Function(int seq) onJumpTo;
  final String hint;
  final String emptyText;

  @override
  State<ChatSearchBar> createState() => _ChatSearchBarState();
}

class _ChatSearchBarState extends State<ChatSearchBar> {
  final _field = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _field.dispose();
    super.dispose();
  }

  void _onChanged(String q) {
    // People type faster than a round trip, and every keystroke would
    // otherwise be a query the server has to answer and we then throw away.
    _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 280),
      () => context.read<ChatController>().searchMessages(q),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.read<ChatController>();
    final scheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
          child: TextField(
            controller: _field,
            autofocus: true,
            textInputAction: TextInputAction.search,
            onChanged: _onChanged,
            decoration: InputDecoration(
              isDense: true,
              hintText: widget.hint,
              prefixIcon: const Icon(Icons.search_rounded, size: 20),
              suffixIcon: IconButton(
                icon: const Icon(Icons.close_rounded, size: 18),
                onPressed: () {
                  _field.clear();
                  c.clearSearch();
                },
              ),
              filled: true,
              fillColor: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(22),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        BlocBuilder<ChatController, ChatSessionState>(
          buildWhen: (a, b) =>
              a.searchResults != b.searchResults ||
              a.searching != b.searching ||
              a.searchQuery != b.searchQuery,
          builder: (context, state) {
            if (!state.isSearching) return const SizedBox.shrink();
            if (state.searching && state.searchResults.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              );
            }
            if (state.searchResults.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  widget.emptyText,
                  style: TextStyle(color: scheme.onSurfaceVariant),
                ),
              );
            }
            return ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 280),
              child: ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: state.searchResults.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, i) {
                  final m = state.searchResults[i];
                  return ListTile(
                    dense: true,
                    title: Text(
                      m.body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13.5),
                    ),
                    subtitle: Text(_when(m), style: const TextStyle(fontSize: 11)),
                    onTap: () => widget.onJumpTo(m.seq),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  String _when(ChatMessage m) {
    final at = m.createdAt?.toLocal();
    if (at == null) return '';
    return '${at.day}/${at.month}/${at.year}';
  }
}
