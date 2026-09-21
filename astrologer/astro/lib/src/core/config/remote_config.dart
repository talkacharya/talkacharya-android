import 'package:freezed_annotation/freezed_annotation.dart';

part 'remote_config.freezed.dart';
part 'remote_config.g.dart';

/// Client bootstrap payload from `GET /api/v1/config` (see backend/docs/mobile.md).
/// Fetched once at startup; the last good copy is cached so the app opens offline.
@freezed
abstract class RemoteConfig with _$RemoteConfig {
  const factory RemoteConfig({
    @JsonKey(name: 'min_app_version')
    @Default(<String, String>{})
    Map<String, String> minAppVersion,
    @Default(<String>['INR']) List<String> currencies,
    @Default(<ConfigLanguage>[]) List<ConfigLanguage> languages,
    @JsonKey(name: 'consultation_channels')
    @Default(<String>['chat', 'voice', 'video'])
    List<String> consultationChannels,
    @JsonKey(name: 'min_recharge')
    @Default(MoneyAmount(amount: '100.00', currency: 'INR'))
    MoneyAmount minRecharge,
    @Default(ConfigFeatures()) ConfigFeatures features,
    @Default(ConfigSupport()) ConfigSupport support,
    @Default(ConfigAuth()) ConfigAuth auth,
  }) = _RemoteConfig;

  const RemoteConfig._();

  factory RemoteConfig.fromJson(Map<String, dynamic> json) =>
      _$RemoteConfigFromJson(json);

  /// Safe defaults used before the first successful fetch.
  factory RemoteConfig.fallback() => const RemoteConfig(
    languages: [
      ConfigLanguage(code: 'en', name: 'English'),
      ConfigLanguage(code: 'hi', name: 'हिन्दी'),
    ],
  );
}

@freezed
abstract class ConfigLanguage with _$ConfigLanguage {
  const factory ConfigLanguage({required String code, required String name}) =
      _ConfigLanguage;

  factory ConfigLanguage.fromJson(Map<String, dynamic> json) =>
      _$ConfigLanguageFromJson(json);
}

@freezed
abstract class MoneyAmount with _$MoneyAmount {
  const factory MoneyAmount({
    required String amount,
    required String currency,
  }) = _MoneyAmount;

  factory MoneyAmount.fromJson(Map<String, dynamic> json) =>
      _$MoneyAmountFromJson(json);
}

@freezed
abstract class ConfigFeatures with _$ConfigFeatures {
  const factory ConfigFeatures({
    @Default(true) bool livestream,
    @Default(true) bool gifting,
    @Default(true) bool referrals,
  }) = _ConfigFeatures;

  factory ConfigFeatures.fromJson(Map<String, dynamic> json) =>
      _$ConfigFeaturesFromJson(json);
}

/// Which login method the app should use (`GET /api/v1/config` -> `auth`).
/// `firebase` true → run the firebase_auth phone flow and POST /auth/firebase;
/// otherwise the built-in OTP flow (POST /auth/otp/*).
@freezed
abstract class ConfigAuth with _$ConfigAuth {
  const factory ConfigAuth({
    @Default(false) bool firebase,
    @Default(true) bool otp,
    @JsonKey(name: 'firebase_project_id') @Default('') String firebaseProjectId,
  }) = _ConfigAuth;

  factory ConfigAuth.fromJson(Map<String, dynamic> json) =>
      _$ConfigAuthFromJson(json);
}

@freezed
abstract class ConfigSupport with _$ConfigSupport {
  const factory ConfigSupport({
    @Default('') String email,
    @Default('') String whatsapp,
    @JsonKey(name: 'help_url') @Default('') String helpUrl,
    @JsonKey(name: 'terms_url') @Default('') String termsUrl,
    @JsonKey(name: 'privacy_url') @Default('') String privacyUrl,
  }) = _ConfigSupport;

  factory ConfigSupport.fromJson(Map<String, dynamic> json) =>
      _$ConfigSupportFromJson(json);
}
