import 'package:flutter/material.dart';

import '../models/chat_message.dart';
import '../ports/voice_note.dart';

/// A voice note in the thread: play, pause, and how long it runs.
///
/// The duration is shown before anything is downloaded, because a voice note
/// with no length is a decision someone cannot make — nobody taps play on an
/// unknown quantity while a meter is running.
class VoiceNoteBubble extends StatelessWidget {
  const VoiceNoteBubble({
    required this.attachment,
    required this.player,
    required this.tint,
    super.key,
  });

  final ChatAttachment attachment;
  final VoicePlayer? player;
  final Color tint;

  String get _length {
    final s = attachment.durationSeconds;
    if (s <= 0) return '';
    return '${s ~/ 60}:${(s % 60).toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final p = player;
    final url = attachment.url;

    // No player wired, or nothing to play: still say it was a voice message
    // rather than drawing an empty bubble.
    if (p == null || url.isEmpty) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.mic_rounded, size: 16, color: tint),
          const SizedBox(width: 6),
          Text(
            _length.isEmpty ? 'Voice message' : 'Voice message · $_length',
            style: TextStyle(color: tint, fontSize: 13),
          ),
        ],
      );
    }

    return StreamBuilder<String?>(
      stream: p.nowPlaying,
      builder: (context, playing) {
        final isThis = playing.data == url;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 34, minHeight: 34),
              icon: Icon(
                isThis ? Icons.pause_rounded : Icons.play_arrow_rounded,
                color: tint,
              ),
              onPressed: () => isThis ? p.pause() : p.play(url),
            ),
            SizedBox(
              width: 96,
              child: StreamBuilder<double>(
                stream: p.progress,
                builder: (context, snap) => ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: isThis ? (snap.data ?? 0) : 0,
                    minHeight: 3,
                    color: tint,
                    backgroundColor: tint.withValues(alpha: 0.25),
                  ),
                ),
              ),
            ),
            if (_length.isNotEmpty) ...[
              const SizedBox(width: 8),
              Text(
                _length,
                style: TextStyle(
                  color: tint.withValues(alpha: 0.85),
                  fontSize: 11.5,
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
