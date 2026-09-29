import 'dart:async';
import 'dart:io';

import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'voice_note.dart';

/// `record`-backed [VoiceRecorder].
///
/// Lives beside the port, like [DeviceSttEngine] and [DeviceTtsEngine]: both
/// apps want exactly this, and two byte-identical copies in two app trees is
/// two places to fix the next plugin quirk.
///
/// AAC in an m4a container: the one format every Android and iOS device both
/// records and plays without a codec argument, and which the server already
/// accepts.
class DeviceVoiceRecorder implements VoiceRecorder {
  final _recorder = AudioRecorder();
  String? _path;

  @override
  Future<bool> available() => _recorder.hasPermission();

  @override
  Future<bool> start() async {
    try {
      if (!await _recorder.hasPermission()) return false;
      final dir = await getTemporaryDirectory();
      final path =
          '${dir.path}/vn_${DateTime.now().millisecondsSinceEpoch}.m4a';
      await _recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          // Speech, not music. A smaller file sends faster on the connections
          // most of these customers are on, and nobody can hear the difference
          // in a voice note.
          bitRate: 64000,
          sampleRate: 44100,
          numChannels: 1,
        ),
        path: path,
      );
      _path = path;
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<String?> stop() async {
    try {
      final path = await _recorder.stop() ?? _path;
      _path = null;
      if (path == null) return null;
      // An empty file is a recording that never started; sending it would put
      // a bubble in the thread that plays nothing.
      final file = File(path);
      if (!file.existsSync() || await file.length() < 512) return null;
      return path;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> cancel() async {
    try {
      await _recorder.cancel();
    } catch (_) {
    } finally {
      final path = _path;
      _path = null;
      if (path != null) {
        try {
          final file = File(path);
          if (file.existsSync()) await file.delete();
        } catch (_) {}
      }
    }
  }

  @override
  Stream<double> get amplitude => _recorder
      .onAmplitudeChanged(const Duration(milliseconds: 160))
      .map((a) => ((a.current + 45) / 45).clamp(0.0, 1.0));
}

/// `just_audio`-backed [VoicePlayer]. One note at a time.
class DeviceVoicePlayer implements VoicePlayer {
  DeviceVoicePlayer() {
    _player.playerStateStream.listen((s) {
      if (s.processingState == ProcessingState.completed) {
        _now.add(null);
        unawaited(_player.stop());
      }
    });
  }

  final _player = AudioPlayer();
  final _now = StreamController<String?>.broadcast();
  String? _url;

  @override
  Future<void> play(String url) async {
    try {
      if (_url != url) {
        await _player.setUrl(url);
        _url = url;
      }
      _now.add(url);
      await _player.play();
    } catch (_) {
      _now.add(null);
    }
  }

  @override
  Future<void> pause() async {
    await _player.pause();
    _now.add(null);
  }

  @override
  Future<void> stop() async {
    await _player.stop();
    _url = null;
    _now.add(null);
  }

  @override
  Stream<String?> get nowPlaying => _now.stream;

  @override
  Stream<double> get progress => _player.positionStream.map((pos) {
    final total = _player.duration;
    if (total == null || total.inMilliseconds <= 0) return 0.0;
    return (pos.inMilliseconds / total.inMilliseconds).clamp(0.0, 1.0);
  });

  @override
  void dispose() {
    unawaited(_player.dispose());
    unawaited(_now.close());
  }
}
