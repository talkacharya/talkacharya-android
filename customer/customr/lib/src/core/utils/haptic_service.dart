import 'package:flutter/services.dart';
import '../config/config_repository.dart';
import '../di/service_locator.dart';

enum HapticLevel { none, selection, light, medium, heavy }

/// Centralized haptic feedback service.
class HapticService {
  HapticService._();

  /// The faint tick of a picker or a segmented control.
  static void selection() => _vibrate(HapticLevel.selection);
  static void light() => _vibrate(HapticLevel.light);
  static void medium() => _vibrate(HapticLevel.medium);
  static void heavy() => _vibrate(HapticLevel.heavy);

  /// Vibration is on unless the preference says otherwise. Read defensively:
  /// a buzz is decoration, and it must never be the thing that throws while
  /// someone is pressing a button (widget tests, and any screen that runs
  /// before DI is up).
  static bool get _enabled =>
      !getIt.isRegistered<ConfigRepository>() ||
      getIt<ConfigRepository>().hapticEnabled;

  static void _vibrate(HapticLevel level) {
    if (level == HapticLevel.none) return;

    if (!_enabled) return;

    switch (level) {
      case HapticLevel.selection:
        HapticFeedback.selectionClick();
      case HapticLevel.light:
        HapticFeedback.lightImpact();
      case HapticLevel.medium:
        HapticFeedback.mediumImpact();
      case HapticLevel.heavy:
        HapticFeedback.heavyImpact();
      case HapticLevel.none:
        break;
    }
  }
}
