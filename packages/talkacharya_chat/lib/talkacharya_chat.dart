/// Shared consultation-chat layer for the TalkAcharya customer and astrologer
/// apps: the chat engine (history + optimistic send + realtime + receipts +
/// presence + translation + TTS/STT) and its widgets. Each app injects a
/// [ChatTransport], [ChatRealtime] and [ChatIdentity]; networking, routing and
/// DI stay app-side.
library;

export 'src/engine/chat_controller.dart';
export 'src/models/chat_enums.dart';
export 'src/models/chat_message.dart';
export 'src/models/chat_pin.dart';
export 'src/models/chat_presence.dart';
export 'src/ports/chat_outbox.dart';
export 'src/ports/chat_ports.dart';
export 'src/ports/stt_engine.dart';
export 'src/ports/tts_engine.dart';
export 'src/widgets/chat_composer.dart';
export 'src/widgets/chat_view.dart';
export 'src/widgets/connection_banner.dart';
export 'src/widgets/message_bubble.dart';
export 'src/widgets/receipt_ticks.dart';
export 'src/widgets/typing_indicator.dart';
