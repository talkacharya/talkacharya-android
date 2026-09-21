import 'package:dio/dio.dart';

import '../../../core/astro/models/astro_profile.dart';
import '../../../core/constants/api_paths.dart';
import '../../../core/network/api_exception.dart';
import '../../auth/data/models/auth_user.dart';
import 'profile_models.dart';

/// Astrologer profile, pricing, schedule, reviews and featured slots, plus the
/// `PATCH /me` account settings. Errors surface as [ApiException] so screens
/// can show the backend's message (e.g. "Allowed range is …").
class ProfileApi {
  ProfileApi(this._dio);
  final Dio _dio;

  Future<T> _guard<T>(Future<T> Function() run) async {
    try {
      return await run();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Awaits [call] and throws on a 4xx (see [EnsureOk]).
  Future<Response<T>> _ok<T>(Future<Response<T>> call) async =>
      (await call).ensureOk();

  List<Map<String, dynamic>> _rows(Object? data) {
    final list = data is Map ? data['results'] : data;
    return (list as List? ?? const [])
        .map((e) => (e as Map).cast<String, dynamic>())
        .toList();
  }

  // --- profile --------------------------------------------------------------

  Future<AstroProfile> profile() => _guard(() async {
    final res = await _ok(
      _dio.get<Map<String, dynamic>>(ApiPaths.astroProfile),
    );
    return AstroProfile.fromJson(res.data ?? const {});
  });

  Future<AstroProfile> update({
    String? headline,
    String? bio,
    int? yearsExperience,
    List<String>? skillSlugs,
    String? primarySkillSlug,
    List<String>? languageCodes,
  }) => _guard(() async {
    final res = await _ok(
      _dio.patch<Map<String, dynamic>>(
        ApiPaths.astroProfile,
        data: {
          'headline': ?headline,
          'bio': ?bio,
          'years_experience': ?yearsExperience,
          'skill_slugs': ?skillSlugs,
          'primary_skill_slug': ?primarySkillSlug,
          'language_codes': ?languageCodes,
        },
      ),
    );
    return AstroProfile.fromJson(res.data ?? const {});
  });

  /// Upload a new cover image (replaces the old one).
  Future<AstroProfile> uploadBanner(String filePath) => _guard(() async {
    final form = FormData.fromMap({
      'banner': await MultipartFile.fromFile(filePath),
    });
    final res = await _ok(
      _dio.put<Map<String, dynamic>>(ApiPaths.astroProfileBanner, data: form),
    );
    return AstroProfile.fromJson(res.data ?? const {});
  });

  Future<AstroProfile> removeBanner() => _guard(() async {
    final res = await _ok(
      _dio.delete<Map<String, dynamic>>(ApiPaths.astroProfileBanner),
    );
    return AstroProfile.fromJson(res.data ?? const {});
  });

  Future<List<RefOption>> skillOptions() => _guard(() async {
    final res = await _ok(_dio.get<dynamic>(ApiPaths.referenceSkills));
    return _rows(res.data).map(RefOption.skill).toList();
  });

  Future<List<RefOption>> languageOptions() => _guard(() async {
    final res = await _ok(_dio.get<dynamic>(ApiPaths.referenceLanguages));
    return _rows(res.data).map(RefOption.language).toList();
  });

  // --- account (/me) --------------------------------------------------------

  Future<AuthUser> updateAccount({String? displayName, String? language}) =>
      _guard(() async {
        final res = await _ok(
          _dio.patch<Map<String, dynamic>>(
            ApiPaths.me,
            data: {
              'display_name': ?displayName,
              'preferred_language': ?language,
            },
          ),
        );
        return AuthUser.fromJson(res.data ?? const {});
      });

  Future<AuthUser> uploadAvatar(String filePath) => _guard(() async {
    final form = FormData.fromMap({
      'avatar': await MultipartFile.fromFile(filePath),
    });
    final res = await _ok(
      _dio.patch<Map<String, dynamic>>(ApiPaths.me, data: form),
    );
    return AuthUser.fromJson(res.data ?? const {});
  });

  // --- rates ----------------------------------------------------------------

  /// Current per-minute rate per channel (`{channel: amount}`), INR only.
  Future<Map<String, double>> rates({String currency = 'INR'}) =>
      _guard(() async {
        final res = await _ok(_dio.get<dynamic>(ApiPaths.astroRates));
        return {
          for (final r in _rows(res.data))
            if ((r['currency'] ?? currency) == currency)
              r['channel'] as String:
                  double.tryParse('${r['per_minute_amount']}') ?? 0,
        };
      });

  Future<List<RateBand>> rateBands() => _guard(() async {
    final res = await _ok(_dio.get<dynamic>(ApiPaths.astroRateBands));
    return _rows(res.data).map(RateBand.fromJson).toList();
  });

  Future<void> setRate(String channel, String currency, double amount) =>
      _guard(
        () => _ok(
          _dio.put<void>(
            ApiPaths.astroRates,
            data: {
              'channel': channel,
              'currency': currency,
              'per_minute_amount': amount.toStringAsFixed(2),
            },
          ),
        ),
      );

  // --- availability & hours -------------------------------------------------

  Future<AvailabilitySettings> availability() => _guard(() async {
    final res = await _ok(
      _dio.get<Map<String, dynamic>>(ApiPaths.astroAvailability),
    );
    return AvailabilitySettings.fromJson(res.data ?? const {});
  });

  Future<void> setAvailability({
    required List<String> channels,
    required int maxConcurrent,
  }) => _guard(
    () => _ok(
      _dio.put<void>(
        ApiPaths.astroAvailability,
        data: {
          'channels_enabled': channels,
          'max_concurrent_chats': maxConcurrent,
        },
      ),
    ),
  );

  Future<List<WorkingWindow>> workingHours() => _guard(() async {
    final res = await _ok(_dio.get<dynamic>(ApiPaths.astroWorkingHours));
    return _rows(res.data).map(WorkingWindow.fromJson).toList();
  });

  Future<void> setWorkingHours(List<WorkingWindow> rows) => _guard(
    () => _ok(
      _dio.put<void>(
        ApiPaths.astroWorkingHours,
        data: [for (final r in rows) r.toJson()],
      ),
    ),
  );

  // --- reviews --------------------------------------------------------------

  Future<List<Review>> reviews() => _guard(() async {
    final res = await _ok(_dio.get<dynamic>(ApiPaths.astroReviews));
    return _rows(res.data).map(Review.fromJson).toList();
  });

  Future<Review> replyToReview(String id, String text) => _guard(() async {
    final res = await _ok(
      _dio.post<Map<String, dynamic>>(
        ApiPaths.astroReviewReply(id),
        data: {'text': text},
      ),
    );
    return Review.fromJson(res.data ?? const {});
  });

  // --- featured slots -------------------------------------------------------

  Future<List<FeaturedSlot>> featuredSlots() => _guard(() async {
    final res = await _ok(_dio.get<dynamic>(ApiPaths.astroFeaturedSlots));
    return _rows(res.data).map(FeaturedSlot.fromJson).toList();
  });

  Future<FeaturedPricing> featuredPricing() => _guard(() async {
    final res = await _ok(
      _dio.get<Map<String, dynamic>>(ApiPaths.astroFeaturedPricing),
    );
    return FeaturedPricing.fromJson(res.data ?? const {});
  });

  Future<FeaturedSlot> requestFeaturedSlot({
    required String placement,
    required DateTime startsAt,
    required DateTime endsAt,
    String? skill,
  }) => _guard(() async {
    final res = await _ok(
      _dio.post<Map<String, dynamic>>(
        ApiPaths.astroFeaturedSlots,
        data: {
          'placement': placement,
          'starts_at': startsAt.toUtc().toIso8601String(),
          'ends_at': endsAt.toUtc().toIso8601String(),
          'skill': ?skill,
        },
      ),
    );
    return FeaturedSlot.fromJson(res.data ?? const {});
  });
}
