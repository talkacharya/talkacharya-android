/// One switch for sound, one for vibration, and nothing that dodges them.
///
/// Before this, `AppSounds.enabled` existed but nothing ever set it, and a
/// dozen call sites buzzed through `HapticFeedback` directly — so turning
/// vibration off in settings left the ringtone's buzz and the call buttons
/// untouched.
library;

import 'package:astro/src/core/config/config_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:talkacharya_call/talkacharya_call.dart';
import 'package:talkacharya_sounds/talkacharya_sounds.dart';

class _MockStorage extends Mock implements FlutterSecureStorage {}

class _Haptics implements CallHaptics {
  var taps = 0;
  @override
  void tap() => taps++;
}

void main() {
  late _MockStorage storage;
  late ConfigRepository repo;

  setUp(() {
    AppSounds.enabled = true;
    storage = _MockStorage();
    when(
      () => storage.read(key: any(named: 'key')),
    ).thenAnswer((_) async => null);
    when(
      () => storage.write(key: any(named: 'key'), value: any(named: 'value')),
    ).thenAnswer((_) async {});
    repo = ConfigRepository(dio: Dio(), storage: storage);
  });

  tearDown(() {
    AppSounds.enabled = true;
    callHaptics = const SystemCallHaptics();
  });

  test('sound is on until someone turns it off', () {
    expect(repo.soundEnabled, isTrue);
  });

  test('turning sound off silences the player, not just the setting', () async {
    await repo.setSoundEnabled(false);

    expect(repo.soundEnabled, isFalse);
    expect(AppSounds.enabled, isFalse);
    verify(
      () => storage.write(key: 'ta_sound_enabled', value: 'false'),
    ).called(1);
  });

  test('the choice is remembered and reapplied on the next run', () async {
    when(
      () => storage.read(key: 'ta_sound_enabled'),
    ).thenAnswer((_) async => 'false');
    when(
      () => storage.read(key: 'ta_haptic_enabled'),
    ).thenAnswer((_) async => 'false');
    when(() => storage.read(key: 'ta_remote_config')).thenAnswer((_) async => null);

    await repo.prime();

    expect(repo.soundEnabled, isFalse);
    expect(repo.hapticEnabled, isFalse);
    expect(AppSounds.enabled, isFalse, reason: 'the player follows the setting');
  });

  test('listeners are told, so an open settings screen repaints', () async {
    var changes = 0;
    repo.addListener(() => changes++);

    await repo.setSoundEnabled(false);
    await repo.setSoundEnabled(false); // no change, no notification
    await repo.setHapticEnabled(false);

    expect(changes, 2);
  });

  test('call controls buzz through the app, not straight to the platform', () {
    // The shared call screen used to call HapticFeedback itself, which no
    // preference could reach.
    final haptics = _Haptics();
    callHaptics = haptics;

    callHaptics.tap();

    expect(haptics.taps, 1);
  });
}
