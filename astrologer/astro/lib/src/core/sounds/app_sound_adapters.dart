import 'package:talkacharya_call/talkacharya_call.dart';
import 'package:talkacharya_chat/talkacharya_chat.dart';
import 'package:talkacharya_sounds/talkacharya_sounds.dart';

import '../utils/haptic_service.dart';

/// Chat-room tones, backed by the shared native sound player.
class AppChatSounds implements ChatSounds {
  const AppChatSounds();
  @override
  void incoming() => AppSounds.effect(SoundEffect.messageIn);
  @override
  void sent() => AppSounds.effect(SoundEffect.messageOut);
}

/// Call tones: ringback while the other side rings, connect and hang-up tones.
class AppCallSounds implements CallSounds {
  const AppCallSounds();
  @override
  void startRingback() => AppSounds.startRingback();
  @override
  void stopRingback() => AppSounds.stop();
  @override
  void connected() => AppSounds.effect(SoundEffect.callConnected);
  @override
  void ended() => AppSounds.effect(SoundEffect.callEnded);
}

/// The call controls' tick, through the app's own "vibrate" preference.
class AppCallHaptics implements CallHaptics {
  const AppCallHaptics();
  @override
  void tap() => HapticService.selection();
}
