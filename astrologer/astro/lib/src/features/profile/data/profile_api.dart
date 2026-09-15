import 'package:dio/dio.dart';

import '../../../core/astro/models/astro_profile.dart';
import '../../../core/constants/api_paths.dart';

class ProfileApi {
  ProfileApi(this._dio);
  final Dio _dio;

  Future<AstroProfile> profile() async {
    final res = await _dio.get<Map<String, dynamic>>(ApiPaths.astroProfile);
    return AstroProfile.fromJson(res.data ?? const {});
  }

  Future<AstroProfile> update({
    String? headline,
    String? bio,
    int? yearsExperience,
  }) async {
    final res = await _dio.patch<Map<String, dynamic>>(
      ApiPaths.astroProfile,
      data: {
        if (headline != null) 'headline': headline,
        if (bio != null) 'bio': bio,
        if (yearsExperience != null) 'years_experience': yearsExperience,
      },
    );
    return AstroProfile.fromJson(res.data ?? const {});
  }

  /// Upload a new cover image (replaces the old one).
  Future<AstroProfile> uploadBanner(String filePath) async {
    final form = FormData.fromMap({
      'banner': await MultipartFile.fromFile(filePath),
    });
    final res = await _dio.put<Map<String, dynamic>>(
      ApiPaths.astroProfileBanner,
      data: form,
    );
    return AstroProfile.fromJson(res.data ?? const {});
  }

  Future<AstroProfile> removeBanner() async {
    final res = await _dio.delete<Map<String, dynamic>>(
      ApiPaths.astroProfileBanner,
    );
    return AstroProfile.fromJson(res.data ?? const {});
  }

  Future<List<Map<String, dynamic>>> rates() async {
    final res = await _dio.get<dynamic>(ApiPaths.astroRates);
    return (res.data as List? ?? const [])
        .map((e) => (e as Map).cast<String, dynamic>())
        .toList();
  }

  Future<void> setRate(String channel, String currency, String amount) =>
      _dio.put(
        ApiPaths.astroRates,
        data: {
          'channel': channel,
          'currency': currency,
          'per_minute_amount': amount,
        },
      );

  Future<List<Map<String, dynamic>>> workingHours() async {
    final res = await _dio.get<dynamic>(ApiPaths.astroWorkingHours);
    return (res.data as List? ?? const [])
        .map((e) => (e as Map).cast<String, dynamic>())
        .toList();
  }

  Future<void> setWorkingHours(List<Map<String, dynamic>> rows) =>
      _dio.put(ApiPaths.astroWorkingHours, data: rows);

  Future<List<Map<String, dynamic>>> reviews() async {
    final res = await _dio.get<dynamic>(ApiPaths.astroReviews);
    return (res.data as List? ?? const [])
        .map((e) => (e as Map).cast<String, dynamic>())
        .toList();
  }

  Future<void> replyToReview(String id, String text) =>
      _dio.post(ApiPaths.astroReviewReply(id), data: {'text': text});
}
