enum Flavor { dev, staging, prod }

/// Immutable runtime configuration. Built once in `bootstrap` from the compile-time
/// flavor plus `--dart-define` overrides, then read everywhere via `AppConfig.of` or DI.
class AppConfig {
  const AppConfig({
    required this.flavor,
    required this.appName,
    required this.apiBaseUrl,
    required this.connectTimeout,
    required this.receiveTimeout,
  });

  final Flavor flavor;
  final String appName;

  /// Includes the `/api/v1` prefix, no trailing slash.
  final String apiBaseUrl;
  final Duration connectTimeout;
  final Duration receiveTimeout;

  bool get isProd => flavor == Flavor.prod;

  /// Resolve from the compile-time flavor. `API_BASE_URL` always wins when supplied.
  factory AppConfig.fromEnvironment(Flavor flavor) {
    const override = String.fromEnvironment('API_BASE_URL');
    final defaults = switch (flavor) {
      // 10.0.2.2 = host loopback from the Android emulator.
      Flavor.dev => 'http://10.0.2.2:8000/api/v1',
      Flavor.staging => 'https://staging-api.talkacharya.com/api/v1',
      Flavor.prod => 'https://api.talkacharya.com/api/v1',
    };
    return AppConfig(
      flavor: flavor,
      appName: switch (flavor) {
        Flavor.dev => 'TalkAcharya Astrologer Dev',
        Flavor.staging => 'TalkAcharya Astrologer Staging',
        Flavor.prod => 'TalkAcharya for Astrologers',
      },
      apiBaseUrl: override.isNotEmpty ? override : defaults,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
    );
  }
}
