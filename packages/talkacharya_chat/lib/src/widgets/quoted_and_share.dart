import 'package:flutter/material.dart';

import '../engine/chat_controller.dart';
import '../models/chat_enums.dart';
import '../models/chat_message.dart';

/// What a quoted message says when it has no text of its own.
String quotePreview(String type, String body, {required bool redacted}) {
  if (redacted) return 'Message removed';
  if (body.isNotEmpty) return body;
  return switch (type) {
    'image' => 'Photo',
    'audio' => 'Voice message',
    'kundali_ref' => 'Birth details',
    _ => 'Message',
  };
}

/// The quoted message drawn above a reply.
class QuotedHeader extends StatelessWidget {
  const QuotedHeader({required this.quote, required this.mine, super.key});

  final ChatReplyTo quote;

  /// Whether the *reply* is ours, which decides what colours read well.
  final bool mine;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tint = mine ? scheme.onPrimary : scheme.primary;
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
      decoration: BoxDecoration(
        color: tint.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border(left: BorderSide(color: tint, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            quote.senderRole == ParticipantRole.astrologer
                ? 'Acharya'
                : 'Customer',
            style: TextStyle(
              color: tint,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            quotePreview(quote.type, quote.body, redacted: quote.redacted),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: (mine ? scheme.onPrimary : scheme.onSurface).withValues(
                alpha: 0.75,
              ),
              fontSize: 12.5,
              fontStyle: quote.redacted ? FontStyle.italic : null,
            ),
          ),
        ],
      ),
    );
  }
}

/// A birth profile or match the customer shared, as a card in the thread.
///
/// It used to be a panel pinned above the conversation, which said nothing
/// about *when* it was shared — at booking, or halfway through. Here it sits
/// where it happened, and can be replied to or pinned like anything else.
class KundaliCard extends StatelessWidget {
  const KundaliCard({
    required this.message,
    required this.controller,
    this.onOpen,
    super.key,
  });

  final ChatMessage message;
  final ChatController controller;

  /// Opens the kundali (or match report) the card is about. Each app knows its
  /// own route; without one the card is information only.
  final void Function(SharedDetails details)? onOpen;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final summary = message.shareSummary;
    final shared = message.shared;
    final isMatch = message.meta['share_kind'] == 'match';
    final open = onOpen;
    final canOpen = shared != null && open != null;
    final fullName = (summary['full_name'] as String? ?? '').trim();
    final label = (summary['label'] as String? ?? '').trim();
    final name = (shared?.name.isNotEmpty ?? false)
        ? shared!.name
        : fullName.isNotEmpty
        ? fullName
        : (label.isNotEmpty ? label : 'Birth details');

    final date = (summary['birth_date'] as String? ?? '').trim();
    final time = (summary['birth_time'] as String? ?? '').trim();
    final place = (summary['birth_place'] as String? ?? '').trim();
    final rows = <(IconData, String)>[
      if (date.isNotEmpty) (Icons.event_rounded, date),
      if (time.isNotEmpty)
        (Icons.schedule_rounded, time)
      else if (summary['time_known'] == false)
        (Icons.schedule_rounded, 'Birth time not known'),
      if (place.isNotEmpty) (Icons.place_outlined, place),
      if (isMatch && summary['total_points'] != null)
        (
          Icons.favorite_outline_rounded,
          '${summary['total_points']} / ${summary['max_points'] ?? 36} gunas',
        ),
    ];

    return Align(
      child: GestureDetector(
        onTap: canOpen ? () => open(shared) : null,
        onLongPress: () => _menu(context),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.sizeOf(context).width * 0.86,
          ),
          decoration: BoxDecoration(
            color: scheme.primaryContainer,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.auto_awesome_rounded,
                    size: 15,
                    color: scheme.onPrimaryContainer,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isMatch ? 'Kundali match shared' : 'Birth details shared',
                    style: TextStyle(
                      color: scheme.onPrimaryContainer,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                name,
                style: TextStyle(
                  color: scheme.onPrimaryContainer,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              for (final (icon, text) in rows)
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Row(
                    children: [
                      Icon(
                        icon,
                        size: 13,
                        color: scheme.onPrimaryContainer.withValues(alpha: 0.8),
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          text,
                          style: TextStyle(
                            color: scheme.onPrimaryContainer.withValues(
                              alpha: 0.9,
                            ),
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (canOpen) ...[
                const SizedBox(height: 10),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isMatch ? 'Open match report' : 'Open kundali',
                      style: TextStyle(
                        color: scheme.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 18,
                      color: scheme.primary,
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _menu(BuildContext context) {
    final pinned = controller.state.pins.any((p) => p.seq == message.seq);
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.reply_rounded),
              title: const Text('Reply'),
              onTap: () {
                Navigator.pop(context);
                controller.replyTo(message);
              },
            ),
            ListTile(
              leading: Icon(pinned ? Icons.push_pin : Icons.push_pin_outlined),
              title: Text(pinned ? 'Unpin' : 'Pin'),
              onTap: () {
                Navigator.pop(context);
                if (pinned) {
                  controller.unpin(message.seq);
                } else {
                  controller.pin(message);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
