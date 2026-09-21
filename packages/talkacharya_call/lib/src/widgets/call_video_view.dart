import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../engine/rtc_engine.dart';

/// Renders one WebRTC video stream.
///
/// The renderer is a platform texture that has to be created and disposed with the
/// widget, and re-pointed whenever the stream changes — hence a StatefulWidget rather
/// than something the call screen can build inline. It shows nothing until the first
/// frame arrives, so the caller stacks it over an avatar rather than a black gap.
class CallVideoView extends StatefulWidget {
  const CallVideoView({
    required this.stream,
    this.mirror = false,
    this.cover = true,
    super.key,
  });

  /// A `MediaStream` from the engine; anything else renders as empty.
  final RtcVideoStream? stream;

  /// Mirror the front camera, the way a phone shows your own preview.
  final bool mirror;

  /// Fill the box (crop) vs. fit inside it (letterbox).
  final bool cover;

  @override
  State<CallVideoView> createState() => _CallVideoViewState();
}

class _CallVideoViewState extends State<CallVideoView> {
  final _renderer = RTCVideoRenderer();
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _renderer.initialize();
    if (!mounted) return;
    setState(() => _ready = true);
    _attach();
  }

  @override
  void didUpdateWidget(CallVideoView old) {
    super.didUpdateWidget(old);
    if (old.stream != widget.stream) _attach();
  }

  void _attach() {
    if (!_ready) return;
    final stream = widget.stream;
    _renderer.srcObject = stream is MediaStream ? stream : null;
  }

  @override
  void dispose() {
    _renderer.srcObject = null;
    _renderer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready || _renderer.srcObject == null) {
      return const SizedBox.shrink();
    }
    return RTCVideoView(
      _renderer,
      mirror: widget.mirror,
      objectFit: widget.cover
          ? RTCVideoViewObjectFit.RTCVideoViewObjectFitCover
          : RTCVideoViewObjectFit.RTCVideoViewObjectFitContain,
    );
  }
}
