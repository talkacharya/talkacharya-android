import 'package:flutter/material.dart';

import '../models/chat_enums.dart';
import '../models/chat_message.dart';

/// WhatsApp-style status for a message the current user sent:
/// clock (sending) · single tick (sent) · double tick (delivered) · blue (read) ·
/// warning (failed).
class ReceiptTicks extends StatelessWidget {
  const ReceiptTicks({required this.message, required this.onColor, super.key});
  final ChatMessage message;
  final Color onColor;

  @override
  Widget build(BuildContext context) {
    if (message.sendStatus == SendStatus.sending) {
      return Icon(
        Icons.access_time_rounded,
        size: 13,
        color: onColor.withValues(alpha: 0.7),
      );
    }
    if (message.sendStatus == SendStatus.failed) {
      return Icon(
        Icons.error_outline_rounded,
        size: 13,
        color: Theme.of(context).colorScheme.error,
      );
    }
    final read = message.readAt != null;
    final delivered = read || message.deliveredAt != null;
    return Icon(
      delivered ? Icons.done_all_rounded : Icons.done_rounded,
      size: 14,
      color: read ? const Color(0xFF4FC3F7) : onColor.withValues(alpha: 0.7),
    );
  }
}
