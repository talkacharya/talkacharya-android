import 'package:dio/dio.dart';

import '../firebase/firebase_setup.dart';

/// Attaches the Firebase App Check token as `X-Firebase-AppCheck` so the backend
/// can confirm the request comes from a genuine build of this app
/// (`backend/apps/identity/app_check.py`). The SDK caches and auto-refreshes the
/// token, so this is cheap; without Firebase / a token the request goes out as-is.
class AppCheckInterceptor extends Interceptor {
  const AppCheckInterceptor();

  static const header = 'X-Firebase-AppCheck';

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await FirebaseSetup.appCheckToken();
    if (token != null && token.isNotEmpty) options.headers[header] = token;
    handler.next(options);
  }
}
