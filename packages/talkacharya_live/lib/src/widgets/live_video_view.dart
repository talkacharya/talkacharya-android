import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart' as lk;

import '../engine/live_room.dart';

/// Renders one live video track (the host's picture, or the host's own preview).
///
/// Anything that is not a LiveKit track renders as empty, so a screen can stack this
/// over a placeholder and not care whether the track has arrived yet.
class LiveVideoView extends StatelessWidget {
  const LiveVideoView({
    required this.track,
    this.cover = true,
    this.mirror = false,
    super.key,
  });

  final LiveVideoTrack? track;

  /// Fill the box (crop) vs. fit inside it (letterbox).
  final bool cover;

  /// Mirror the front camera, the way a phone shows your own preview.
  final bool mirror;

  @override
  Widget build(BuildContext context) {
    final t = track;
    if (t is! lk.VideoTrack) return const SizedBox.shrink();
    return lk.VideoTrackRenderer(
      t,
      fit: cover ? lk.VideoViewFit.cover : lk.VideoViewFit.contain,
      mirrorMode: mirror
          ? lk.VideoViewMirrorMode.mirror
          : lk.VideoViewMirrorMode.off,
    );
  }
}
