import 'package:flutter/material.dart';

import '../models/chat_message.dart';
import '../models/chat_pin.dart';
import 'quoted_and_share.dart';

/// The pinned messages, above the thread. Tapping one jumps to it; the pin icon
/// unpins it.
///
/// Shared between both participants on purpose — a pin is how the two of them
/// agree on what matters in the conversation (a remedy, a date, the question
/// actually being asked), not a private bookmark.
class PinnedBar extends StatelessWidget {
  const PinnedBar({
    required this.pins,
    required this.onTap,
    required this.onUnpin,
    super.key,
  });

  final List<ChatPin> pins;
  final void Function(int seq) onTap;
  final void Function(int seq) onUnpin;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.secondaryContainer,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final pin in pins)
            InkWell(
              onTap: () => onTap(pin.seq),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 8, 6, 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.push_pin_rounded,
                      size: 15,
                      color: scheme.onSecondaryContainer,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        quotePreview(pin.type, pin.body, redacted: false),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: scheme.onSecondaryContainer,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Unpin',
                      visualDensity: VisualDensity.compact,
                      icon: Icon(
                        Icons.close_rounded,
                        size: 16,
                        color: scheme.onSecondaryContainer,
                      ),
                      onPressed: () => onUnpin(pin.seq),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// The message being replied to, sitting above the composer until it is sent
/// or dismissed.
class ReplyBar extends StatelessWidget {
  const ReplyBar({
    required this.quoted,
    required this.mine,
    required this.onCancel,
    super.key,
  });

  final ChatMessage quoted;

  /// Whether the quoted message is the reader's own.
  final bool mine;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 4, 8),
        child: Row(
          children: [
            Container(width: 3, height: 34, color: scheme.primary),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    mine ? 'Replying to yourself' : 'Replying',
                    style: TextStyle(
                      color: scheme.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    quotePreview(quoted.type, quoted.body, redacted: false),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: scheme.onSurfaceVariant,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Cancel reply',
              icon: const Icon(Icons.close_rounded, size: 18),
              onPressed: onCancel,
            ),
          ],
        ),
      ),
    );
  }
}
