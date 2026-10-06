import 'package:dio/dio.dart';

import '../di/service_locator.dart';
import '../../features/auth/presentation/bloc/auth/auth_bloc.dart';

/// Injects the `Accept-Language` header so the backend can localize responses.
class LanguageInterceptor extends Interceptor {
  const LanguageInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (getIt.isRegistered<AuthBloc>()) {
      final lang = getIt<AuthBloc>().state.user?.preferredLanguage;
      if (lang != null && lang.isNotEmpty) {
        options.headers['Accept-Language'] = lang;
      }
    }
    super.onRequest(options, handler);
  }
}
