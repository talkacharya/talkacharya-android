import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_user.freezed.dart';
part 'auth_user.g.dart';

/// Mirrors identity.serializers.UserSerializer.
@freezed
abstract class AuthUser with _$AuthUser {
  const factory AuthUser({
    required String id,
    required String phone,
    @JsonKey(name: 'full_name') @Default('') String fullName,
    @JsonKey(name: 'display_name') @Default('') String displayName,
    @Default('') String email,
    String? avatar,
    @JsonKey(name: 'preferred_language')
    @Default('en')
    String preferredLanguage,
    @JsonKey(name: 'preferred_currency')
    @Default('INR')
    String preferredCurrency,
    @Default('') String country,
    @JsonKey(name: 'account_status') @Default('active') String accountStatus,
    @JsonKey(name: 'is_astrologer') @Default(false) bool isAstrologer,
    @JsonKey(name: 'is_staff') @Default(false) bool isStaff,
  }) = _AuthUser;

  const AuthUser._();

  factory AuthUser.fromJson(Map<String, dynamic> json) =>
      _$AuthUserFromJson(json);

  String get shortName => displayName.isNotEmpty
      ? displayName
      : (fullName.isNotEmpty ? fullName : phone);
}
