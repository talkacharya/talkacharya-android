import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart';

/// On-device speech-to-text for the astrologer's dictation. Streams partial
/// transcripts; the astrologer edits the text before sending — output is always
/// a normal text message.
abstract class SttEngine {
  Future<bool> available();

  /// Start listening in [language] (bcp-47). [onResult] is called with the
  /// running transcript (partial and final).
  Future<void> start({
    required String language,
    required void Function(String transcript, bool isFinal) onResult,
  });
  Future<void> stop();
  ValueListenable<bool> get listening;
  void dispose();
}

class DeviceSttEngine implements SttEngine {
  final SpeechToText _stt = SpeechToText();
  final _listening = ValueNotifier<bool>(false);
  bool _ready = false;

  @override
  ValueListenable<bool> get listening => _listening;

  @override
  Future<bool> available() async {
    if (_ready) return true;
    try {
      _ready = await _stt.initialize(
        onStatus: (s) {
          if (s == 'done' || s == 'notListening') _listening.value = false;
        },
        onError: (_) => _listening.value = false,
      );
    } catch (_) {
      _ready = false;
    }
    return _ready;
  }

  @override
  Future<void> start({
    required String language,
    required void Function(String transcript, bool isFinal) onResult,
  }) async {
    if (!await available()) return;
    _listening.value = true;
    await _stt.listen(
      listenOptions: SpeechListenOptions(
        partialResults: true,
        cancelOnError: true,
        listenMode: ListenMode.dictation,
        localeId: _resolve(language),
      ),
      onResult: (r) => onResult(r.recognizedWords, r.finalResult),
    );
  }

  @override
  Future<void> stop() async {
    try {
      await _stt.stop();
    } catch (_) {}
    _listening.value = false;
  }

  String _resolve(String lang) => switch (lang.split('-').first) {
    'hi' => 'hi_IN',
    'en' => 'en_IN',
    'bn' => 'bn_IN',
    'ta' => 'ta_IN',
    'te' => 'te_IN',
    'mr' => 'mr_IN',
    'gu' => 'gu_IN',
    'kn' => 'kn_IN',
    'ml' => 'ml_IN',
    'pa' => 'pa_IN',
    final other => other,
  };

  @override
  void dispose() {
    _stt.cancel();
    _listening.dispose();
  }
}
