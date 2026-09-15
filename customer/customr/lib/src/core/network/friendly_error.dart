import 'api_exception.dart';

/// Turns any thrown error into a short, user-facing sentence.
///
/// Technical details — type-cast failures, parser errors, raw exception
/// strings, stack traces — must never reach the UI. Anything we don't
/// specifically recognise collapses to [fallback].
String friendlyError(Object error, {String? fallback}) {
  final generic = fallback ?? 'Something went wrong. Please try again.';

  if (error is ApiException) {
    // Connectivity / timeout: ApiException already phrases these for humans.
    if (error.isNetwork) return error.message;

    final status = error.statusCode ?? 0;
    if (status == 401 || status == 403) {
      return 'Please sign in again to see this.';
    }
    if (status == 404) {
      return "We couldn't find this — it may have been removed.";
    }
    if (status == 429) {
      return "You're going a bit fast. Please try again in a moment.";
    }
    if (status >= 500) {
      return 'Our server ran into a problem. Please try again shortly.';
    }
    // Other 4xx: the backend's `detail` is written for users, so surface it.
    return error.message.trim().isNotEmpty ? error.message : generic;
  }

  return generic;
}
