import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/astro/models/astro_profile.dart';
import '../../../../core/astro/onboarding_store.dart';
import '../../data/onboarding_repository.dart';
import '../../../../core/network/friendly_error.dart';

class OnboardingState extends Equatable {
  const OnboardingState({
    this.loading = true,
    this.saving = false,
    this.profile,
    this.error,
    this.missing = const [],
  });

  final bool loading;
  final bool saving;
  final AstroProfile? profile;
  final String? error;
  final List<String> missing;

  List<String> get gaps => profile?.gaps ?? const [];

  OnboardingState copyWith({
    bool? loading,
    bool? saving,
    AstroProfile? profile,
    Object? error = _sentinel,
    List<String>? missing,
  }) => OnboardingState(
    loading: loading ?? this.loading,
    saving: saving ?? this.saving,
    profile: profile ?? this.profile,
    error: error == _sentinel ? this.error : error as String?,
    missing: missing ?? this.missing,
  );

  static const _sentinel = Object();

  @override
  List<Object?> get props => [loading, saving, profile, error, missing];
}

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit({
    required OnboardingRepository repo,
    required OnboardingStore store,
  }) : _repo = repo,
       _store = store,
       super(const OnboardingState());

  final OnboardingRepository _repo;
  final OnboardingStore _store;

  Future<void> load() async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final p = await _repo.profile();
      emit(state.copyWith(loading: false, profile: p));
    } catch (e) {
      emit(state.copyWith(loading: false, error: _message(e)));
    }
  }

  Future<bool> saveProfile({
    String? headline,
    String? bio,
    int? yearsExperience,
    List<String>? skillSlugs,
    String? primarySkillSlug,
    List<String>? languageCodes,
  }) => _run(
    () => _repo.updateProfile(
      headline: headline,
      bio: bio,
      yearsExperience: yearsExperience,
      skillSlugs: skillSlugs,
      primarySkillSlug: primarySkillSlug,
      languageCodes: languageCodes,
    ),
  );

  Future<bool> uploadKyc({
    required String docType,
    String? number,
    ({List<int> bytes, String filename})? file,
  }) =>
      _run(() => _repo.uploadKyc(docType: docType, number: number, file: file));

  Future<bool> saveBank({
    required String holder,
    required String accountNumber,
    String? ifsc,
    String? bankName,
  }) => _run(
    () => _repo.setBankAccount(
      accountHolderName: holder,
      accountNumber: accountNumber,
      ifsc: ifsc,
      bankName: bankName,
    ),
  );

  Future<bool> submit() async {
    emit(state.copyWith(saving: true, error: null, missing: const []));
    try {
      final res = await _repo.submit();
      if (!res.ok) {
        emit(state.copyWith(saving: false, missing: res.missing));
        return false;
      }
      await _refresh();
      emit(state.copyWith(saving: false));
      return true;
    } catch (e) {
      emit(state.copyWith(saving: false, error: _message(e)));
      return false;
    }
  }

  Future<bool> _run(Future<void> Function() action) async {
    emit(state.copyWith(saving: true, error: null));
    try {
      await action();
      await _refresh();
      emit(state.copyWith(saving: false));
      return true;
    } catch (e) {
      emit(state.copyWith(saving: false, error: _message(e)));
      return false;
    }
  }

  static String _message(Object e) => friendlyError(e);

  Future<void> _refresh() async {
    final p = await _repo.profile();
    emit(state.copyWith(profile: p));
    await _store.refresh();
  }
}
