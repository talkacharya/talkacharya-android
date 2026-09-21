import 'package:dio/dio.dart';

import '../../../core/astro/models/astro_profile.dart';
import '../../../core/constants/api_paths.dart';
import '../../../core/network/api_exception.dart';

class SubmitResult {
  const SubmitResult({required this.ok, this.missing = const []});
  final bool ok;
  final List<String> missing;
}

class OnboardingApi {
  OnboardingApi(this._dio);
  final Dio _dio;

  Future<AstroProfile> getProfile() async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        ApiPaths.astroOnboarding,
      );
      return AstroProfile.fromJson(res.data ?? const {});
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<AstroProfile> updateProfile({
    String? headline,
    String? bio,
    int? yearsExperience,
    List<String>? skillSlugs,
    String? primarySkillSlug,
    List<String>? languageCodes,
  }) async {
    try {
      final res = (await _dio.patch<Map<String, dynamic>>(
        ApiPaths.astroOnboarding,
        data: {
          if (headline != null) 'headline': headline,
          if (bio != null) 'bio': bio,
          if (yearsExperience != null) 'years_experience': yearsExperience,
          if (skillSlugs != null) 'skill_slugs': skillSlugs,
          if (primarySkillSlug != null) 'primary_skill_slug': primarySkillSlug,
          if (languageCodes != null) 'language_codes': languageCodes,
        },
      )).ensureOk();
      return AstroProfile.fromJson(res.data ?? const {});
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<void> uploadKyc({
    required String docType,
    String? number,
    ({List<int> bytes, String filename})? file,
  }) async {
    try {
      final form = FormData.fromMap({
        'doc_type': docType,
        if (number != null) 'number': number,
        if (file != null)
          'file': MultipartFile.fromBytes(
            file.bytes,
            filename: file.filename,
            contentType: DioMediaType.parse('image/jpeg'),
          ),
      });
      (await _dio.post<void>(
        ApiPaths.astroOnboardingKyc,
        data: form,
      )).ensureOk();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<void> setBankAccount({
    required String accountHolderName,
    required String accountNumber,
    String? ifsc,
    String? bankName,
  }) async {
    try {
      (await _dio.post<void>(
        ApiPaths.astroOnboardingBank,
        data: {
          'account_holder_name': accountHolderName,
          'account_number': accountNumber,
          if (ifsc != null && ifsc.isNotEmpty) 'ifsc': ifsc,
          if (bankName != null && bankName.isNotEmpty) 'bank_name': bankName,
        },
      )).ensureOk();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<SubmitResult> submitForReview() async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        ApiPaths.astroOnboardingSubmit,
      );
      if ((res.statusCode ?? 0) >= 400) {
        return SubmitResult(ok: false, missing: _missingFrom(res.data));
      }
      return const SubmitResult(ok: true);
    } on DioException catch (e) {
      final data = e.response?.data;
      if (data is Map)
        return SubmitResult(ok: false, missing: _missingFrom(data));
      throw ApiException.fromDio(e);
    }
  }

  List<String> _missingFrom(Object? data) {
    if (data is Map && data['detail'] is Map) {
      final m = (data['detail'] as Map)['missing'];
      if (m is List) return m.map((e) => e.toString()).toList();
    }
    return const [];
  }
}
