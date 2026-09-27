/// One step of the video quality ladder.
class VideoRung {
  const VideoRung({
    required this.label,
    this.scaleDownBy = 1.0,
    this.maxBitrateBps,
    this.maxFramerate,
    this.cameraOff = false,
  });

  final String label;

  /// Divides the captured resolution: 2.0 sends half the width and height.
  final double scaleDownBy;
  final int? maxBitrateBps;
  final int? maxFramerate;

  /// The last resort: carry on as a voice call.
  final bool cameraOff;
}

/// Best first. The steps are wide on purpose — a ladder with narrow rungs just
/// spends its time climbing and falling, and each change is visible.
///
/// The bitrates assume one face talking, which compresses far better than a
/// moving scene, and leave headroom for the audio: on a paid consultation the
/// voice is the product and the picture is the comfort.
const kVideoLadder = <VideoRung>[
  VideoRung(
    label: '540p',
    maxBitrateBps: 800000,
    maxFramerate: 24,
  ),
  VideoRung(
    label: '360p',
    scaleDownBy: 1.5,
    maxBitrateBps: 350000,
    maxFramerate: 20,
  ),
  VideoRung(
    label: '270p',
    scaleDownBy: 2.0,
    maxBitrateBps: 180000,
    maxFramerate: 15,
  ),
  VideoRung(label: 'audio only', cameraOff: true),
];
