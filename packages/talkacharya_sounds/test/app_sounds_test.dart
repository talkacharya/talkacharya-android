import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talkacharya_sounds/talkacharya_sounds.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('talkacharya/sounds');
  final calls = <MethodCall>[];

  setUp(() {
    calls.clear();
    AppSounds.enabled = true;
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          calls.add(call);
          return null;
        });
  });

  tearDown(() {
    debugDefaultTargetPlatformOverride = null;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('forwards each sound to the native channel', () async {
    await AppSounds.startRinging();
    await AppSounds.startRingback();
    await AppSounds.notify();
    await AppSounds.effect(SoundEffect.messageIn);
    await AppSounds.stop();
    expect(calls.map((c) => c.method), [
      'startRinging',
      'startRingback',
      'notify',
      'effect',
      'stop',
    ]);
    expect(calls[3].arguments, {'name': 'message_in'});
  });

  test('disabled plays nothing but can still stop a loop', () async {
    AppSounds.enabled = false;
    await AppSounds.startRinging();
    await AppSounds.effect(SoundEffect.callEnded);
    await AppSounds.stop();
    expect(calls.map((c) => c.method), ['stop']);
  });

  test('is a no-op off Android and without the plugin', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    await AppSounds.startRinging();
    expect(calls, isEmpty);

    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
    await expectLater(AppSounds.notify(), completes);
  });
}
