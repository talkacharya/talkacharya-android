/// Shared live-streaming layer for the TalkAcharya customer and astrologer apps.
///
/// An astrologer publishes one camera + microphone track into a room on **our own**
/// LiveKit media server (`deploy/media`) and every viewer subscribes to it. Django
/// mints the tokens — only the host's allows publishing — and everything that is not
/// video (chat, viewer counts, gifts, moderation) rides the Centrifugo channel
/// `live:{id}`. Each app injects its own backend, signaling and permissions;
/// networking, routing and DI stay app-side. No third-party media provider.
library;

export 'src/cubit/live_cubit_base.dart';
export 'src/cubit/live_host_cubit.dart';
export 'src/cubit/live_viewer_cubit.dart';
export 'src/engine/live_room.dart';
export 'src/engine/livekit_room.dart';
export 'src/engine/permission_handler_live_permissions.dart';
export 'src/models/live_chat_message.dart';
export 'src/models/live_join.dart';
export 'src/models/live_state.dart';
export 'src/ports/live_ports.dart';
export 'src/widgets/live_video_view.dart';
