import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/api_paths.dart';
import 'models/astro_profile.dart';

/// Where the astrologer is in onboarding — the router gate reads [stage].
enum OnboardingStage {
  loading,
  notAstrologer,
  wizard, // draft / rejected — has gaps to fill or was sent back
  underReview,
  approved,
  suspended,
}

/// Single source of truth for the astrologer's onboarding status. Mirrors the
/// customer app's `ActiveProfileStore` pattern: a [ChangeNotifier] the router
/// listens to. Loaded on cold start, refreshed after `POST /astro/onboarding/*`.
class OnboardingStore extends ChangeNotifier {
  OnboardingStore(this._dio, this._storage);

  final Dio _dio;
  final FlutterSecureStorage _storage;
  static const _key = 'ta_onboarding_status';

  AstroProfile? _profile;
  AstroProfile? get profile => _profile;
  String? get profileId => _profile?.id;
  List<String> get gaps => _profile?.gaps ?? const [];

  OnboardingStage _stage = OnboardingStage.loading;
  OnboardingStage get stage => _stage;

  bool _loginGatePending = false;
  bool get loginGatePending => _loginGatePending;

  void markLoginGatePending() {
    _loginGatePending = true;
    notifyListeners();
  }

  /// Cold start: use the cached status for an instant gate decision, then verify.
  Future<void> load() async {
    try {
      final cached = await _storage.read(key: _key);
      if (cached != null && cached.isNotEmpty) {
        _stage = _stageFor(OnboardingStatus.parse(cached), const []);
      }
    } catch (_) {}
    notifyListeners();
    await refresh();
  }

  Future<void> refresh() async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        ApiPaths.astroOnboarding,
      );
      if (res.statusCode == 200 && res.data != null) {
        _profile = AstroProfile.fromJson(res.data!);
        _stage = _stageFor(
          _profile!.status,
          _profile!.gaps,
          _profile!.hasProfile,
        );
        await _storage.write(key: _key, value: _profile!.status.name);
      }
    } on DioException catch (e) {
      // 403 => not an astrologer account; keep any cached stage on a network error
      if (e.response?.statusCode == 403) {
        _stage = OnboardingStage.notAstrologer;
      }
    } catch (e, st) {
      // A parse failure here would leave the gate on the splash forever.
      debugPrint('OnboardingStore.refresh failed: $e\n$st');
    }
    notifyListeners();
  }

  void clearGate() {
    _loginGatePending = false;
    notifyListeners();
  }

  Future<void> clear() async {
    _profile = null;
    _stage = OnboardingStage.loading;
    _loginGatePending = false;
    try {
      await _storage.delete(key: _key);
    } catch (_) {}
    notifyListeners();
  }

  static OnboardingStage _stageFor(
    OnboardingStatus status,
    List<String> gaps, [
    bool hasProfile = true,
  ]) {
    return switch (status) {
      OnboardingStatus.approved => OnboardingStage.approved,
      OnboardingStatus.submitted ||
      OnboardingStatus.underReview => OnboardingStage.underReview,
      OnboardingStatus.suspended => OnboardingStage.suspended,
      OnboardingStatus.draft ||
      OnboardingStatus.rejected => OnboardingStage.wizard,
      OnboardingStatus.unknown =>
        hasProfile ? OnboardingStage.wizard : OnboardingStage.notAstrologer,
    };
  }
}
