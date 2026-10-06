import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talkacharya_call/talkacharya_call.dart';

/// The Dart half of the Telecom bridge: what the platform sends is read into
/// the right events, and what Dart asks for reaches the platform intact.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('talkacharya/telecom');
  final calls = <MethodCall>[];

  setUp(() {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    CallTelecom.resetForTest();
    calls.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          calls.add(call);
          return switch (call.method) {
            'takePendingAnswer' => 'c9',
            _ => true,
          };
        });
  });

  tearDown(() {
    debugDefaultTargetPlatformOverride = null;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  Future<void> platformSends(String method, Map<String, Object?> args) =>
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .handlePlatformMessage(
            channel.name,
            const StandardMethodCodec().encodeMethodCall(MethodCall(method, args)),
            (_) {},
          );

  test('a ringing call is reported with its id, name, kind and timeout', () async {
    final ok = await CallTelecom.reportIncoming(
      callId: 'c1',
      peerName: 'Ravi',
      video: true,
      expiresIn: const Duration(seconds: 90),
    );
    expect(ok, isTrue);
    expect(calls.single.method, 'reportIncoming');
    expect(calls.single.arguments, {
      'callId': 'c1',
      'peerName': 'Ravi',
      'video': true,
      'expiresMs': 90000,
    });
  });

  test('nothing is reported without an id to report it under', () async {
    expect(
      await CallTelecom.reportIncoming(
        callId: '',
        peerName: 'Ravi',
        video: false,
        expiresIn: const Duration(seconds: 90),
      ),
      isFalse,
    );
    expect(calls, isEmpty);
  });

  test('system answers, declines and missed rings arrive as events', () async {
    final events = <CallTelecomEvent>[];
    final sub = CallTelecom.events.listen(events.add);

    await platformSends('answer', {'callId': 'c1'});
    await platformSends('reject', {'callId': 'c2'});
    await platformSends('missed', {'callId': 'c3'});
    await Future<void>.delayed(Duration.zero);

    expect((events[0] as TelecomAnswer).callId, 'c1');
    expect((events[1] as TelecomReject).callId, 'c2');
    expect((events[2] as TelecomMissed).callId, 'c3');
    await sub.cancel();
  });

  test('the audio report carries the route and every route available', () async {
    final events = <CallTelecomEvent>[];
    final sub = CallTelecom.events.listen(events.add);

    await platformSends('audio', {
      'callId': 'c1',
      'speaker': false,
      'bluetooth': true,
      'route': 'bluetooth',
      'routes': ['earpiece', 'speaker', 'bluetooth'],
    });
    await Future<void>.delayed(Duration.zero);

    final a = events.single as TelecomAudioRoute;
    expect(a.route, CallAudioOutput.bluetooth);
    expect(a.routes, {
      CallAudioOutput.earpiece,
      CallAudioOutput.speaker,
      CallAudioOutput.bluetooth,
    });
    await sub.cancel();
  });

  test('a headset answer made while the app was closed is collected once', () async {
    expect(await CallTelecom.takePendingAnswer(), 'c9');
  });

  test('routes are asked for by name', () async {
    await CallTelecom.setAudioRoute(CallAudioOutput.wired);
    expect(calls.single.method, 'setAudioRoute');
    expect(calls.single.arguments, {'route': 'wired'});
  });
}
