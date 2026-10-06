import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/chat_message.dart';
import '../ports/chat_media.dart';
import '../ports/voice_note.dart';
import 'local_attachment.dart';

/// A voice note in the thread with animated beating waveform bars,
/// real-time playback duration/countdown, and speed control.
class VoiceNoteBubble extends StatelessWidget {
  const VoiceNoteBubble({
    required this.attachment,
    required this.player,
    required this.tint,
    this.media,
    super.key,
  });

  final ChatAttachment attachment;
  final VoicePlayer? player;
  final Color tint;

  /// Where the note is kept on the device. With one, it is downloaded once and
  /// played from the file; without, it streams from the server every time.
  final ChatMediaStore? media;

  int get _durationSeconds => attachment.durationSeconds;

  String get _length {
    final s = _durationSeconds;
    if (s <= 0) return '';
    return '${s ~/ 60}:${(s % 60).toString().padLeft(2, '0')}';
  }

  Widget _label(String text, {Widget? leading}) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          leading ?? Icon(Icons.mic_rounded, size: 16, color: tint),
          const SizedBox(width: 6),
          Text(text, style: TextStyle(color: tint, fontSize: 13)),
        ],
      );

  String get _title =>
      _length.isEmpty ? 'Voice message' : 'Voice message · $_length';

  @override
  Widget build(BuildContext context) {
    final p = player;
    final store = media;

    // No player wired: still say it was a voice message rather than drawing
    // an empty bubble.
    if (p == null) return _label(_title);

    if (store != null) {
      return LocalAttachment(
        attachment: attachment,
        store: store,
        builder: (context, path) => _VoiceNoteControls(
          player: p,
          url: Uri.file(path).toString(),
          tint: tint,
          durationSeconds: _durationSeconds,
        ),
        loading: (_) => _label(
          _title,
          leading: SizedBox(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(strokeWidth: 1.6, color: tint),
          ),
        ),
        gone: (_) => _label('Voice message · no longer available'),
        failed: (_, retry) => GestureDetector(
          onTap: retry,
          child: _label(
            '$_title · tap to download',
            leading: Icon(Icons.download_rounded, size: 16, color: tint),
          ),
        ),
      );
    }

    final url = attachment.url;
    if (url.isEmpty) return _label(_title);
    return _VoiceNoteControls(
      player: p,
      url: url,
      tint: tint,
      durationSeconds: _durationSeconds,
    );
  }
}

class _VoiceNoteControls extends StatefulWidget {
  const _VoiceNoteControls({
    required this.player,
    required this.url,
    required this.tint,
    required this.durationSeconds,
  });

  final VoicePlayer player;
  final String url;
  final Color tint;
  final int durationSeconds;

  @override
  State<_VoiceNoteControls> createState() => _VoiceNoteControlsState();
}

class _VoiceNoteControlsState extends State<_VoiceNoteControls>
    with SingleTickerProviderStateMixin {
  late final AnimationController _beatController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 600),
  );

  double _speed = 1.0;

  @override
  void dispose() {
    _beatController.dispose();
    super.dispose();
  }

  void _cycleSpeed() {
    setState(() {
      if (_speed == 1.0) {
        _speed = 1.5;
      } else if (_speed == 1.5) {
        _speed = 2.0;
      } else {
        _speed = 1.0;
      }
    });
    widget.player.setSpeed(_speed);
  }

  String _formatTime(int totalSecs, double progress) {
    if (totalSecs <= 0) return '0:00';
    final elapsedSecs = (totalSecs * progress).round().clamp(0, totalSecs);
    final m = elapsedSecs ~/ 60;
    final s = (elapsedSecs % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  String _formatTotal(int totalSecs) {
    if (totalSecs <= 0) return '0:00';
    final m = totalSecs ~/ 60;
    final s = (totalSecs % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.player;
    final url = widget.url;
    final tint = widget.tint;
    final duration = widget.durationSeconds;

    return StreamBuilder<String?>(
      stream: p.nowPlaying,
      builder: (context, playingSnap) {
        final isPlaying = playingSnap.data == url;

        if (isPlaying) {
          if (!_beatController.isAnimating) {
            _beatController.repeat(reverse: true);
          }
        } else {
          if (_beatController.isAnimating) {
            _beatController.stop();
          }
        }

        return StreamBuilder<double>(
          stream: p.progress,
          builder: (context, progressSnap) {
            final progress = isPlaying ? (progressSnap.data ?? 0.0) : 0.0;

            return Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Play / Pause Circular Button
                Material(
                  color: tint.withValues(alpha: 0.16),
                  shape: const CircleBorder(),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () {
                      if (isPlaying) {
                        p.pause();
                      } else {
                        p.play(url);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Icon(
                        isPlaying
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        color: tint,
                        size: 22,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // Animated Beating Waveform
                AnimatedBuilder(
                  animation: _beatController,
                  builder: (context, _) => _WaveformVisualizer(
                    progress: progress,
                    isPlaying: isPlaying,
                    beatValue: _beatController.value,
                    tint: tint,
                  ),
                ),

                const SizedBox(width: 10),

                // Elapsed Countdown / Total Duration
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isPlaying
                          ? '${_formatTime(duration, progress)} / ${_formatTotal(duration)}'
                          : _formatTotal(duration),
                      style: TextStyle(
                        color: tint.withValues(alpha: 0.88),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                    if (isPlaying) ...[
                      const SizedBox(height: 2),
                      InkWell(
                        onTap: _cycleSpeed,
                        borderRadius: BorderRadius.circular(6),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 1,
                          ),
                          decoration: BoxDecoration(
                            color: tint.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${_speed == 1.0 ? '1' : _speed}x',
                            style: TextStyle(
                              color: tint,
                              fontSize: 9.5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }
}

/// Rhythmic beating waveform bars.
class _WaveformVisualizer extends StatelessWidget {
  const _WaveformVisualizer({
    required this.progress,
    required this.isPlaying,
    required this.beatValue,
    required this.tint,
  });

  final double progress;
  final bool isPlaying;
  final double beatValue;
  final Color tint;

  // 24 bar base amplitudes (normalized 0.25 to 1.0) for organic audio shape
  static const List<double> _baseAmplitudes = [
    0.35,
    0.65,
    0.40,
    0.85,
    0.50,
    0.90,
    0.75,
    0.30,
    0.60,
    0.80,
    0.95,
    0.50,
    0.70,
    0.40,
    0.85,
    0.60,
    0.35,
    0.90,
    0.70,
    0.50,
    0.80,
    0.40,
    0.65,
    0.30,
  ];

  static const double _maxHeight = 22.0;

  @override
  Widget build(BuildContext context) {
    final totalBars = _baseAmplitudes.length;

    return SizedBox(
      height: _maxHeight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(totalBars, (index) {
          final barProgress = index / totalBars;
          final isPassed = progress >= barProgress;

          final base = _baseAmplitudes[index];

          // Calculate beating height when playing
          double amplitude = base;
          if (isPlaying) {
            final pulse = 0.25 *
                math.sin(beatValue * 2 * math.pi + (index * 0.45));
            amplitude = (base + pulse).clamp(0.25, 1.0);
          }

          final barHeight = amplitude * _maxHeight;

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 1.2),
            width: 2.8,
            height: barHeight,
            decoration: BoxDecoration(
              color: isPassed ? tint : tint.withValues(alpha: 0.28),
              borderRadius: BorderRadius.circular(999),
            ),
          );
        }),
      ),
    );
  }
}
