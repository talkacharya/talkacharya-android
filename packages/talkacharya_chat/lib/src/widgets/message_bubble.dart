import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../engine/chat_controller.dart';
import '../models/chat_enums.dart';
import '../models/chat_message.dart';
import '../ports/chat_media.dart';
import 'local_attachment.dart';
import 'quoted_and_share.dart';
import 'receipt_ticks.dart';
import 'voice_note_bubble.dart';

/// One chat message. System events render as a centered chip; everyone else as a
/// left/right bubble with translation toggle, speak button, ticks and retry.
class MessageBubble extends StatefulWidget {
  const MessageBubble({
    required this.message,
    required this.controller,
    this.continuesAbove = false,
    this.continuesBelow = false,
    this.systemLabel,
    this.onOpenShared,
    super.key,
  });

  final ChatMessage message;
  final ChatController controller;

  /// The app's wording for a system line, in its own language and with its
  /// own facts (the customer sees what a session cost; the astrologer sees
  /// what it earned). Null, or a null return, falls back to the defaults.
  final String? Function(ChatMessage message)? systemLabel;

  /// Opens what a shared-details card is about; see [KundaliCard.onOpen].
  final void Function(SharedDetails details)? onOpenShared;

  /// Part of a run from the same sender: tighten the gap above, and square the
  /// corner that faces it.
  final bool continuesAbove;

  /// Another message from the same sender follows, so the tail belongs to that
  /// one and not to this.
  final bool continuesBelow;

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  bool _showOriginal = false;
  Offset? _tapPosition;

  ChatMessage get m => widget.message;
  ChatController get c => widget.controller;

  /// Whether the long-press context menu should offer "pin".  This is read
  /// at menu-open time via the controller, so it doesn't need to be live in
  /// build() — we don't re-render the bubble whenever pins change.
  bool get _pinned => c.state.pins.any((p) => p.seq == m.seq);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    if (m.isKundaliRef) {
      return KundaliCard(
        message: m,
        controller: c,
        onOpen: widget.onOpenShared,
      );
    }

    if (m.isSystem) {
      return _SystemChip(
        text: widget.systemLabel?.call(m) ?? defaultSystemText(m),
        icon: systemIcon(m),
        tone: systemTone(m),
      );
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
        onTapDown: (d) => _tapPosition = d.globalPosition,
        onTap: () => _menu(context, mine: mine),
        onLongPress: () => _menu(context, mine: mine),
        child: Container(
          margin: EdgeInsets.fromLTRB(
            2,
            widget.continuesAbove ? 1 : 3,
            2,
            widget.continuesBelow ? 1 : 3,
          ),
          padding: const EdgeInsets.fromLTRB(12, 8, 10, 6),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.sizeOf(context).width * 0.78,
          ),
          decoration: BoxDecoration(
            color: bg,
            // The tail sits on the last bubble of a run; the ones above it
            // square off against the message they belong with.
            borderRadius: BorderRadius.circular(14).copyWith(
              topRight: mine && widget.continuesAbove
                  ? const Radius.circular(4)
                  : null,
              topLeft: !mine && widget.continuesAbove
                  ? const Radius.circular(4)
                  : null,
              bottomRight: mine && !widget.continuesBelow
                  ? const Radius.circular(3)
                  : null,
              bottomLeft: !mine && !widget.continuesBelow
                  ? const Radius.circular(3)
                  : null,
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
                if (a.kind == 'audio')
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: VoiceNoteBubble(
                      attachment: a,
                      player: c.voicePlayer,
                      media: c.media,
                      tint: fg,
                    ),
                  )
                else if (a.kind == 'image' && c.media != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: _DevicePhoto(
                      attachment: a,
                      store: c.media!,
                      tint: fg,
                    ),
                  )
                else if (a.kind == 'image' &&
                    (a.url.isNotEmpty || a.localPath.isNotEmpty))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: GestureDetector(
                      onTap: a.url.isEmpty
                          ? null
                          : () => _openImage(context, Image.network(a.url)),
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
    if (_tapPosition == null) return;
    
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    
    showMenu<String>(
      context: context,
      position: RelativeRect.fromRect(
        _tapPosition! & const Size(40, 40),
        Offset.zero & overlay.size,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 6,
      items: [
        if (m.seq > 0)
          const PopupMenuItem(
            value: 'reply',
            child: Row(
              children: [
                Icon(Icons.reply_rounded, size: 20),
                SizedBox(width: 12),
                Text('Reply'),
              ],
            ),
          ),
        if (m.seq > 0)
          PopupMenuItem(
            value: 'pin',
            child: Row(
              children: [
                Icon(_pinned ? Icons.push_pin : Icons.push_pin_outlined, size: 20),
                const SizedBox(width: 12),
                Text(_pinned ? 'Unpin' : 'Pin'),
              ],
            ),
          ),
        if (m.body.isNotEmpty)
          const PopupMenuItem(
            value: 'copy',
            child: Row(
              children: [
                Icon(Icons.copy_rounded, size: 20),
                SizedBox(width: 12),
                Text('Copy'),
              ],
            ),
          ),
        if (m.body.isNotEmpty)
          const PopupMenuItem(
            value: 'speak',
            child: Row(
              children: [
                Icon(Icons.volume_up_rounded, size: 20),
                SizedBox(width: 12),
                Text('Read aloud'),
              ],
            ),
          ),
        if (!mine && m.body.isNotEmpty && !m.hasTranslationFor(c.identity.language))
          const PopupMenuItem(
            value: 'translate',
            child: Row(
              children: [
                Icon(Icons.translate_rounded, size: 20),
                SizedBox(width: 12),
                Text('Translate'),
              ],
            ),
          ),
        if (m.sendStatus == SendStatus.failed)
          const PopupMenuItem(
            value: 'retry',
            child: Row(
              children: [
                Icon(Icons.refresh_rounded, size: 20),
                SizedBox(width: 12),
                Text('Retry'),
              ],
            ),
          ),
        if (!mine && m.seq > 0)
          const PopupMenuItem(
            value: 'report',
            child: Row(
              children: [
                Icon(Icons.flag_outlined, size: 20),
                SizedBox(width: 12),
                Text('Report message'),
              ],
            ),
          ),
      ],
    ).then((value) {
      if (value == null) return;
      switch (value) {
        case 'reply':
          c.replyTo(m);
          break;
        case 'pin':
          if (_pinned) {
            c.unpin(m.seq);
          } else {
            c.pin(m);
          }
          break;
        case 'copy':
          Clipboard.setData(ClipboardData(text: m.body));
          break;
        case 'speak':
          c.speak(m);
          break;
        case 'translate':
          c.translateOne(m.seq);
          break;
        case 'retry':
          c.retry(m);
          break;
        case 'report':
          _reportSheet(context);
          break;
      }
    });
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

}

/// Full screen, pinch to zoom.
void _openImage(BuildContext context, Widget image) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
        body: Center(child: InteractiveViewer(maxScale: 5, child: image)),
      ),
    ),
  );
}

/// A chat photo read off the device — downloaded once, the first time it is
/// shown, and never fetched from the server again.
class _DevicePhoto extends StatelessWidget {
  const _DevicePhoto({
    required this.attachment,
    required this.store,
    required this.tint,
  });

  final ChatAttachment attachment;
  final ChatMediaStore store;
  final Color tint;

  static const _box = Size(220, 160);

  Widget _placeholder(Widget child) => Container(
    width: _box.width,
    height: _box.height,
    decoration: BoxDecoration(
      color: tint.withValues(alpha: 0.10),
      borderRadius: BorderRadius.circular(10),
    ),
    alignment: Alignment.center,
    child: child,
  );

  @override
  Widget build(BuildContext context) {
    return LocalAttachment(
      attachment: attachment,
      store: store,
      builder: (context, path) => GestureDetector(
        onTap: () => _openImage(context, Image.file(File(path))),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 260),
            child: Image.file(
              File(path),
              fit: BoxFit.cover,
              // Decoded at bubble size, not camera size: a thread of photos
              // otherwise holds a few hundred megabytes of pixels.
              cacheWidth: 720,
              errorBuilder: (_, _, _) => const _BrokenImage(),
            ),
          ),
        ),
      ),
      loading: (_) => _placeholder(
        SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(strokeWidth: 2, color: tint),
        ),
      ),
      gone: (_) => _placeholder(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.image_not_supported_outlined, color: tint),
            const SizedBox(height: 6),
            Text(
              'Photo no longer available',
              style: TextStyle(color: tint, fontSize: 12),
            ),
          ],
        ),
      ),
      failed: (_, retry) => GestureDetector(
        onTap: retry,
        child: _placeholder(
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.download_rounded, color: tint),
              const SizedBox(height: 6),
              Text(
                'Tap to download',
                style: TextStyle(color: tint, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// What a session was, for a system line: "Chat", "Voice call", "Video call".
String sessionNoun(ChatMessage m) => switch (m.meta['channel']) {
  'voice' => 'Voice call',
  'video' => 'Video call',
  _ => 'Chat',
};

/// English wording for a system line, used when the app supplies none.
String defaultSystemText(ChatMessage m) {
  final noun = sessionNoun(m);
  return switch (m.systemEvent) {
    'requested' => '$noun requested',
    'accepted' => '$noun picked up · connecting',
    'started' => '$noun started',
    'ended' => _endedText(m, noun),
    'rejected' => '$noun request declined',
    'cancelled' => '$noun request cancelled',
    'expired' => '$noun request not answered',
    'no_show' => '$noun did not connect',
    'ending_soon' => 'A few minutes of balance left',
    _ => m.body.isNotEmpty ? m.body : 'Update',
  };
}

String _endedText(ChatMessage m, String noun) {
  final secs = (m.meta['billed_seconds'] as num?)?.toInt();
  if (secs == null || secs <= 0) return '$noun ended';
  final mins = (secs / 60).ceil();
  return '$noun ended · $mins min';
}

/// The icon a system line carries, by what happened.
IconData systemIcon(ChatMessage m) {
  final video = m.meta['channel'] == 'video';
  final call = video || m.meta['channel'] == 'voice';
  return switch (m.systemEvent) {
    'requested' || 'accepted' =>
      video
          ? Icons.videocam_outlined
          : (call ? Icons.call_made_rounded : Icons.forum_outlined),
    'started' =>
      video
          ? Icons.videocam_rounded
          : (call ? Icons.call_rounded : Icons.chat_bubble_rounded),
    'ended' => call ? Icons.call_end_rounded : Icons.check_circle_outline,
    'rejected' || 'cancelled' || 'expired' || 'no_show' =>
      call ? Icons.phone_missed_rounded : Icons.block_rounded,
    'ending_soon' => Icons.hourglass_bottom_rounded,
    _ => Icons.info_outline_rounded,
  };
}

/// Whether a system line is good news, bad news or just news.
SystemTone systemTone(ChatMessage m) => switch (m.systemEvent) {
  'started' => SystemTone.positive,
  'rejected' || 'expired' || 'no_show' || 'ending_soon' => SystemTone.warning,
  _ => SystemTone.neutral,
};

enum SystemTone { neutral, positive, warning }

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
  const _SystemChip({
    required this.text,
    required this.icon,
    this.tone = SystemTone.neutral,
  });
  final String text;
  final IconData icon;
  final SystemTone tone;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (Color bg, Color fg) = switch (tone) {
      SystemTone.positive => (
        scheme.primaryContainer.withValues(alpha: 0.7),
        scheme.onPrimaryContainer,
      ),
      SystemTone.warning => (
        scheme.errorContainer.withValues(alpha: 0.6),
        scheme.onErrorContainer,
      ),
      SystemTone.neutral => (
        scheme.surfaceContainerHighest.withValues(alpha: 0.7),
        scheme.onSurfaceVariant,
      ),
    };
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 24),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: fg),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11.5,
                  color: fg,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
