import 'package:dio/dio.dart';

import '../di/service_locator.dart';
import '../l10n/l10n.dart';
import '../../features/auth/presentation/bloc/auth/auth_bloc.dart';

/// Injects the `Accept-Language` header so the backend can localize responses.
class LanguageInterceptor extends Interceptor {
  const LanguageInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (getIt.isRegistered<AuthBloc>()) {
      final lang = getIt<AuthBloc>().state.user?.preferredLanguage;
      if (lang != null && lang.isNotEmpty) {
        // Someone who chose a language the app no longer offers sees the app
        // in English; the server's text should match what is on screen.
        options.headers['Accept-Language'] = isSupportedLanguage(lang)
            ? lang
            : 'en';
      }
    }
    super.onRequest(options, handler);
  }
}
