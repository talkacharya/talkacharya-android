import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Reads chat messages aloud. The default impl uses the device's built-in TTS
/// (free, offline). An app can inject its own for server-side synthesis.
abstract class TtsEngine {
  /// Speak [text] in [language] (bcp-47). Resolves when playback finishes or is
  /// stopped.
  Future<void> speak(String text, {required String language});
  Future<void> stop();
  ValueListenable<bool> get speaking;
  void dispose();
}

class DeviceTtsEngine implements TtsEngine {
  DeviceTtsEngine() {
    _tts
      ..setStartHandler(() => _speaking.value = true)
      ..setCompletionHandler(() => _speaking.value = false)
      ..setCancelHandler(() => _speaking.value = false)
      ..setErrorHandler((_) => _speaking.value = false);
  }

  final FlutterTts _tts = FlutterTts();
  final _speaking = ValueNotifier<bool>(false);

  @override
  ValueListenable<bool> get speaking => _speaking;

  @override
  Future<void> speak(String text, {required String language}) async {
    if (text.trim().isEmpty) return;
    try {
      await _tts.stop();
      await _tts.setLanguage(_resolve(language));
      await _tts.setSpeechRate(0.48);
      await _tts.awaitSpeakCompletion(true);
      await _tts.speak(text);
    } catch (_) {
      _speaking.value = false;
    }
  }

  @override
  Future<void> stop() async {
    try {
      await _tts.stop();
    } catch (_) {}
    _speaking.value = false;
  }

  /// Map a base tag to a locale the device is likely to have.
  String _resolve(String lang) => switch (lang.split('-').first) {
    'hi' => 'hi-IN',
    'en' => 'en-IN',
    'bn' => 'bn-IN',
    'ta' => 'ta-IN',
    'te' => 'te-IN',
    'mr' => 'mr-IN',
    'gu' => 'gu-IN',
    'kn' => 'kn-IN',
    'ml' => 'ml-IN',
    'pa' => 'pa-IN',
    'or' => 'or-IN',
    final other => other,
  };

  @override
  void dispose() {
    _tts.stop();
    _speaking.dispose();
  }
}
