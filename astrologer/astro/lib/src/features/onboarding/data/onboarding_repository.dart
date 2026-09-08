import '../../../core/astro/models/astro_profile.dart';
import 'onboarding_api.dart';

class OnboardingRepository {
  OnboardingRepository(this._api);
  final OnboardingApi _api;

  Future<AstroProfile> profile() => _api.getProfile();

  Future<AstroProfile> updateProfile({
    String? headline,
    String? bio,
    int? yearsExperience,
    List<String>? skillSlugs,
    String? primarySkillSlug,
    List<String>? languageCodes,
  }) =>
      _api.updateProfile(
        headline: headline,
        bio: bio,
        yearsExperience: yearsExperience,
        skillSlugs: skillSlugs,
        primarySkillSlug: primarySkillSlug,
        languageCodes: languageCodes,
      );

  Future<void> uploadKyc({
    required String docType,
    String? number,
    ({List<int> bytes, String filename})? file,
  }) =>
      _api.uploadKyc(docType: docType, number: number, file: file);

  Future<void> setBankAccount({
    required String accountHolderName,
    required String accountNumber,
    String? ifsc,
    String? bankName,
  }) =>
      _api.setBankAccount(
        accountHolderName: accountHolderName,
        accountNumber: accountNumber,
        ifsc: ifsc,
        bankName: bankName,
      );

  Future<SubmitResult> submit() => _api.submitForReview();
}
