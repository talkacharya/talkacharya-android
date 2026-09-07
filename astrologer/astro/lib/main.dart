import 'bootstrap.dart';
import 'src/core/config/flavor.dart';

/// Default entrypoint. Prefer the flavor-specific ones:
///   flutter run --target lib/main_dev.dart
///   flutter run --target lib/main_prod.dart
void main() => bootstrap(Flavor.dev);
