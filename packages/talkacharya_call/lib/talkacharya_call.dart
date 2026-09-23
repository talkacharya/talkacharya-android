/// Shared 1:1 voice- and video-call layer for the TalkAcharya customer and
/// astrologer apps: a self-hosted WebRTC engine (peer connection + signaling over
/// Centrifugo + ICE restart + heartbeats + quality) and the call screen. Each app
/// injects a [CallBackend], [CallSignaling] and (optionally) a [CallKeepAlive];
/// networking, routing and DI stay app-side. No third-party media provider.
library;

export 'src/engine/call_controller.dart';
export 'src/engine/call_pip.dart';
export 'src/engine/call_proximity.dart';
export 'src/engine/connectivity_plus_connectivity.dart';
export 'src/engine/flutter_webrtc_engine.dart';
export 'src/engine/foreground_keep_alive.dart';
export 'src/engine/permission_handler_permissions.dart';
export 'src/engine/rtc_engine.dart';
export 'src/models/call_join.dart';
export 'src/models/call_state.dart';
export 'src/ports/call_ports.dart';
export 'src/widgets/call_overlay.dart';
export 'src/widgets/call_screen.dart';
export 'src/widgets/call_status.dart';
export 'src/widgets/call_video_view.dart';
