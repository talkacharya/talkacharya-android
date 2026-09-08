import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../config/flavor.dart';
import '../storage/token_storage.dart';
import 'auth_interceptor.dart';

/// Builds the app's Dio instances. [buildApiClient] is the authenticated client
/// used everywhere; it shares a bare [_buildBareClient] for token refresh + replay
/// so the auth interceptor never recurses into itself.
class DioClientFactory {
  DioClientFactory(this._config, this._tokens);

  final AppConfig _config;
  final TokenStorage _tokens;

  BaseOptions get _baseOptions => BaseOptions(
    baseUrl: _config.apiBaseUrl,
    connectTimeout: _config.connectTimeout,
    receiveTimeout: _config.receiveTimeout,
    contentType: Headers.jsonContentType,
    headers: {
      'Accept': 'application/json',
      // Identifies this app to the shared backend. The OTP flow refuses a login
      // when the phone's account belongs to the customer app (`auth.wrong_app`).
      'X-Client-App': 'astrologer',
    },
    // 401 must surface as a DioException so AuthInterceptor.onError can refresh +
    // replay. Every other 4xx stays a normal Response — repositories read the body
    // and map it to a typed error themselves.
    validateStatus: (s) => s != null && s < 500 && s != 401,
  );

  Dio _buildBareClient() => Dio(_baseOptions);

  Dio buildApiClient({required Future<void> Function() onSessionExpired}) {
    final dio = Dio(_baseOptions);
    dio.interceptors.add(
      AuthInterceptor(
        tokens: _tokens,
        refreshClient: _buildBareClient(),
        onSessionExpired: onSessionExpired,
      ),
    );
    if (!_config.isProd) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          compact: true,
        ),
      );
    }
    return dio;
  }
}
