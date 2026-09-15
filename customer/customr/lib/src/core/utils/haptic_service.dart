import 'package:flutter/services.dart';
import '../config/config_repository.dart';
import '../di/service_locator.dart';

enum HapticLevel { none, light, medium, heavy }

/// Centralized haptic feedback service.
class HapticService {
  HapticService._();

  static void light() => _vibrate(HapticLevel.light);
  static void medium() => _vibrate(HapticLevel.medium);
  static void heavy() => _vibrate(HapticLevel.heavy);

  static void _vibrate(HapticLevel level) {
    if (level == HapticLevel.none) return;

    final configRepo = getIt<ConfigRepository>();
    if (!configRepo.hapticEnabled) return;

    switch (level) {
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
