/// Picture-in-picture: a video call follows the user out of the app.
///
/// The Activity decides *when* (only it sees `onUserLeaveHint`); Dart decides
/// *whether*, by telling it a video call is live. Everything here is about that
/// contract holding — including on hosts that have no PiP at all, where it must
/// quietly do nothing rather than throw mid-call.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talkacharya_call/talkacharya_call.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('talkacharya/pip');
  final calls = <MethodCall>[];
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  void host({Object? Function(MethodCall call)? answer}) {
    messenger.setMockMethodCallHandler(channel, (call) async {
      calls.add(call);
      return answer?.call(call);
    });
  }

  setUp(() {
    calls.clear();
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    CallPip.resetForTest();
  });

  tearDown(() {
    messenger.setMockMethodCallHandler(channel, null);
    debugDefaultTargetPlatformOverride = null;
    CallPip.resetForTest();
  });

  test('a live video call is announced to the Activity', () async {
    host();

    await CallPip.setActive(active: true);

    expect(calls.single.method, 'setActive');
    expect(calls.single.arguments, {'active': true});
  });

  test('ending the call takes the permission away again', () async {
    host();

    await CallPip.setActive(active: false);

    expect(calls.single.arguments, {'active': false});
    expect(CallPip.inPip.value, isFalse);
  });

  test('the Activity tells us when the window opens and closes', () async {
    host();
    await CallPip.setActive(active: true); // wires the handler

    await messenger.handlePlatformMessage(
      channel.name,
      channel.codec.encodeMethodCall(const MethodCall('pipChanged', true)),
      (_) {},
    );
    expect(CallPip.inPip.value, isTrue);

    await messenger.handlePlatformMessage(
      channel.name,
      channel.codec.encodeMethodCall(const MethodCall('pipChanged', false)),
      (_) {},
    );
    expect(CallPip.inPip.value, isFalse);
  });

  test('support is whatever the device says', () async {
    host(answer: (call) => call.method == 'isSupported' ? false : null);

    expect(await CallPip.isSupported(), isFalse);
  });

  test('a host without the channel is not an error', () async {
    // iOS, an older build of either app, a widget test: no PiP, no crash.
    messenger.setMockMethodCallHandler(channel, null);

    expect(await CallPip.enter(), isFalse);
    expect(await CallPip.isSupported(), isFalse);
    await expectLater(CallPip.setActive(active: true), completes);
  });

  test('nothing is sent off Android', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    host();

    await CallPip.setActive(active: true);
    expect(await CallPip.enter(), isFalse);

    expect(calls, isEmpty);
  });
}
