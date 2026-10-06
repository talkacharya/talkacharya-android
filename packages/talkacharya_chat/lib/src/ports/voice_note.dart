/// Recording and playing a voice note.
///
/// Ports rather than packages, like everything else platform-shaped in here:
/// the engine stays testable without a microphone, and each app supplies its
/// own implementation.
abstract class VoiceRecorder {
  /// Whether the device will let us record — permission included.
  Future<bool> available();

  /// Begin recording. Returns false when permission was refused, so the
  /// composer can say so rather than appearing to do nothing.
  Future<bool> start();

  /// Stop and keep it. Returns the file path, or null if nothing usable was
  /// captured — a tap that never became a recording is not an error.
  Future<String?> stop();

  /// Stop and throw it away.
  Future<void> cancel();

  /// Loudness right now, 0..1, for a waveform. Silence is a legitimate answer.
  Stream<double> get amplitude;
}

/// Playback of one voice note at a time.
///
/// One at a time on purpose: two voices talking over each other in a
/// transcript is nobody's idea of a conversation.
abstract class VoicePlayer {
  /// Play [url], stopping whatever else was playing.
  Future<void> play(String url);
  Future<void> pause();
  Future<void> stop();

  /// Change playback speed (e.g. 1.0, 1.5, 2.0).
  Future<void> setSpeed(double speed) async {}

  /// The url currently playing, or null.
  Stream<String?> get nowPlaying;

  /// How far through the current note, 0..1.
  Stream<double> get progress;

  void dispose();
}
