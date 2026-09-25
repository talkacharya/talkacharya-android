import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../engine/chat_controller.dart';
import '../models/chat_enums.dart';
import '../models/chat_message.dart';
import 'quoted_and_share.dart';
import 'receipt_ticks.dart';

/// One chat message. System events render as a centered chip; everyone else as a
/// left/right bubble with translation toggle, speak button, ticks and retry.
class MessageBubble extends StatefulWidget {
  const MessageBubble({
    required this.message,
    required this.controller,
    super.key,
  });

  final ChatMessage message;
  final ChatController controller;

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  bool _showOriginal = false;

  ChatMessage get m => widget.message;
  ChatController get c => widget.controller;

  bool get _pinned => c.state.pins.any((p) => p.seq == m.seq);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    if (m.isKundaliRef) {
      return KundaliCard(message: m, controller: c);
    }

    if (m.isSystem) {
      return _SystemChip(text: _systemText(m));
    }

    final mine = m.senderRole == c.identity.role;
    final lang = c.identity.language;
    final auto = c.state.autoTranslate;
    final translated =
        !mine &&
        !_showOriginal &&
        m.hasTranslationFor(lang) &&
        m.sourceLanguage.isNotEmpty &&
        m.sourceLanguage != lang.split('-').first;
    final text = translated ? m.bodyFor(lang, preferTranslation: true) : m.body;

    final bg = mine ? scheme.primary : scheme.surfaceContainerHighest;
    final fg = mine ? scheme.onPrimary : scheme.onSurface;

    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: () => _menu(context, mine: mine),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 2),
          padding: const EdgeInsets.fromLTRB(12, 8, 10, 6),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.sizeOf(context).width * 0.78,
          ),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(14).copyWith(
              bottomRight: mine ? const Radius.circular(3) : null,
              bottomLeft: mine ? null : const Radius.circular(3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (m.replyTo != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: QuotedHeader(quote: m.replyTo!, mine: mine),
                ),
              for (final a in m.attachments)
                if (a.kind == 'image' &&
                    (a.url.isNotEmpty || a.localPath.isNotEmpty))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: GestureDetector(
                      onTap: a.url.isEmpty
                          ? null
                          : () => _openImage(context, a.url),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 260),
                          child: a.localPath.isNotEmpty
                              ? Image.file(
                                  File(a.localPath),
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, _, _) =>
                                      const _BrokenImage(),
                                )
                              : Image.network(
                                  a.url,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, _, _) =>
                                      const _BrokenImage(),
                                ),
                        ),
                      ),
                    ),
                  ),
              if (text.isNotEmpty)
                Text(
                  text,
                  style: TextStyle(color: fg, fontSize: 14.5, height: 1.32),
                ),
              if (translated || (!mine && m.hasTranslationFor(lang)))
                GestureDetector(
                  onTap: () => setState(() => _showOriginal = !_showOriginal),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      _showOriginal
                          ? 'Show translation'
                          : 'translated · show original',
                      style: TextStyle(
                        fontSize: 10.5,
                        color: fg.withValues(alpha: 0.75),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
              if (!mine &&
                  !auto &&
                  !m.hasTranslationFor(lang) &&
                  m.sourceLanguage.isNotEmpty &&
                  m.sourceLanguage != lang.split('-').first &&
                  m.body.isNotEmpty)
                GestureDetector(
                  onTap: () => c.translateOne(m.seq),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      'Translate',
                      style: TextStyle(
                        fontSize: 10.5,
                        color: fg.withValues(alpha: 0.75),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 2),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (m.body.isNotEmpty)
                    GestureDetector(
                      onTap: () => c.speak(m),
                      child: Icon(
                        Icons.volume_up_rounded,
                        size: 13,
                        color: fg.withValues(alpha: 0.6),
                      ),
                    ),
                  if (m.body.isNotEmpty) const SizedBox(width: 6),
                  Text(
                    m.createdAt == null
                        ? ''
                        : DateFormat('h:mm a').format(m.createdAt!.toLocal()),
                    style: TextStyle(
                      fontSize: 10,
                      color: fg.withValues(alpha: 0.6),
                    ),
                  ),
                  if (mine) ...[
                    const SizedBox(width: 4),
                    ReceiptTicks(message: m, onColor: fg),
                  ],
                ],
              ),
              if (m.sendStatus == SendStatus.failed)
                GestureDetector(
                  onTap: () => c.retry(m),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Text(
                      'Failed — tap to retry',
                      style: TextStyle(
                        fontSize: 10.5,
                        color: Theme.of(context).colorScheme.error,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _menu(BuildContext context, {required bool mine}) {
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (m.seq > 0)
              ListTile(
                leading: const Icon(Icons.reply_rounded),
                title: const Text('Reply'),
                onTap: () {
                  Navigator.pop(context);
                  c.replyTo(m);
                },
              ),
            if (m.seq > 0)
              ListTile(
                leading: Icon(
                  _pinned ? Icons.push_pin : Icons.push_pin_outlined,
                ),
                title: Text(_pinned ? 'Unpin' : 'Pin'),
                onTap: () {
                  Navigator.pop(context);
                  if (_pinned) {
                    c.unpin(m.seq);
                  } else {
                    c.pin(m);
                  }
                },
              ),
            if (m.body.isNotEmpty)
              ListTile(
                leading: const Icon(Icons.copy_rounded),
                title: const Text('Copy'),
                onTap: () {
                  Navigator.pop(context);
                  Clipboard.setData(ClipboardData(text: m.body));
                },
              ),
            if (m.body.isNotEmpty)
              ListTile(
                leading: const Icon(Icons.volume_up_rounded),
                title: const Text('Read aloud'),
                onTap: () {
                  Navigator.pop(context);
                  c.speak(m);
                },
              ),
            if (!mine &&
                m.body.isNotEmpty &&
                !m.hasTranslationFor(c.identity.language))
              ListTile(
                leading: const Icon(Icons.translate_rounded),
                title: const Text('Translate'),
                onTap: () {
                  Navigator.pop(context);
                  c.translateOne(m.seq);
                },
              ),
            if (m.sendStatus == SendStatus.failed)
              ListTile(
                leading: const Icon(Icons.refresh_rounded),
                title: const Text('Retry'),
                onTap: () {
                  Navigator.pop(context);
                  c.retry(m);
                },
              ),
            if (!mine && m.seq > 0)
              ListTile(
                leading: const Icon(Icons.flag_outlined),
                title: const Text('Report message'),
                onTap: () {
                  Navigator.pop(context);
                  _reportSheet(context);
                },
              ),
          ],
        ),
      ),
    );
  }

  void _reportSheet(BuildContext context) {
    const reasons = {
      'abuse': 'Abusive or harassing',
      'spam': 'Spam or scam',
      'inappropriate': 'Inappropriate content',
      'other': 'Something else',
    };
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 14, 16, 6),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Report this message',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
            for (final e in reasons.entries)
              ListTile(
                title: Text(e.value),
                onTap: () {
                  Navigator.pop(context);
                  c.reportMessage(m.seq, e.key);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Thanks — this has been reported.'),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  void _openImage(BuildContext context, String url) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
          ),
          body: Center(
            child: InteractiveViewer(maxScale: 5, child: Image.network(url)),
          ),
        ),
      ),
    );
  }

  String _systemText(ChatMessage m) => switch (m.systemEvent) {
    'started' => 'Consultation started',
    'ended' => 'Consultation ended',
    'ending_soon' => 'A few minutes of balance left',
    _ => m.body.isNotEmpty ? m.body : 'Update',
  };
}

class _BrokenImage extends StatelessWidget {
  const _BrokenImage();
  @override
  Widget build(BuildContext context) => const SizedBox(
    height: 120,
    width: 160,
    child: Center(child: Icon(Icons.broken_image_outlined)),
  );
}

class _SystemChip extends StatelessWidget {
  const _SystemChip({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 11.5,
            color: scheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
