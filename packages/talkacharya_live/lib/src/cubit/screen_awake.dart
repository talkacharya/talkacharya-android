import 'package:wakelock_plus/wakelock_plus.dart';

/// Keep the screen lit while a stream is on. A device (or a test) without the
/// plugin just doesn't — never a reason for going live or watching to fail.
Future<void> keepScreenOn() async {
  try {
    await WakelockPlus.enable();
  } catch (_) {}
}
