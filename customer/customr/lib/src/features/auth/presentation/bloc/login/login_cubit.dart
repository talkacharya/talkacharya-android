import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/config/config_repository.dart';
import '../../../../../core/network/api_exception.dart';
import '../../../../../core/network/friendly_error.dart';
import '../../../../../core/profile/active_profile_store.dart';
import '../../../../../core/utils/validators.dart';
import '../../../data/auth_repository.dart';
import '../../../data/firebase_phone_auth.dart';
import '../auth/auth_bloc.dart';

part 'login_state.dart';

/// Drives the two-step phone -> OTP flow. On success it pushes [AuthLoggedIn]
/// into [AuthBloc] and the router swaps to the app shell.
///
/// Two backends: **Firebase phone auth** (when `GET /config` -> `auth.firebase`)
/// or the legacy server OTP. The UI is identical; only the mechanics differ.
class LoginCubit extends Cubit<LoginState> {
  LoginCubit({
    required AuthRepository repo,
    required AuthBloc authBloc,
    ActiveProfileStore? profileStore,
    ConfigRepository? config,
    FirebasePhoneAuth? firebasePhoneAuth,
  }) : _repo = repo,
       _authBloc = authBloc,
       _profileStore = profileStore,
       _config = config,
       _firebase = firebasePhoneAuth,
       super(const LoginState());

  final AuthRepository _repo;
  final AuthBloc _authBloc;
  final ActiveProfileStore? _profileStore;
  final ConfigRepository? _config;
  final FirebasePhoneAuth? _firebase;

  /// Firebase callbacks can land after the login screen is gone (e.g. a late
  /// auto-retrieval) — drop those instead of throwing on a closed cubit.
  @override
  void emit(LoginState state) {
    if (!isClosed) super.emit(state);
  }

  bool get _firebaseMode =>
      _firebase != null && (_config?.value.auth.firebase ?? false);

  Future<void> requestOtp(String rawPhone) async {
    final e164 = Validators.toE164(rawPhone);
    if (e164 == null) {
      emit(state.copyWith(error: 'Enter a valid mobile number.'));
      return;
    }
    emit(state.copyWith(submitting: true, error: null, phone: e164));

    if (_firebaseMode) {
      await _firebase!.sendCode(
        e164,
        resendToken: state.resendToken,
        onCodeSent: (verificationId, resendToken) => emit(
          state.copyWith(
            submitting: false,
            step: LoginStep.enterOtp,
            verificationId: verificationId,
            resendToken: resendToken,
            challengeExpiresAt: DateTime.now().add(const Duration(seconds: 60)),
          ),
        ),
        onAutoVerified: _completeWithFirebaseToken,
        onError: (message) =>
            emit(state.copyWith(submitting: false, error: message)),
      );
      return;
    }

    try {
      final result = await _repo.requestOtp(e164);
      emit(
        state.copyWith(
          submitting: false,
          step: LoginStep.enterOtp,
          challengeExpiresAt: result.expiresAt,
          devCode: result.devCode,
          clearDevCode: result.devCode == null,
        ),
      );
    } on ApiException catch (e) {
      emit(state.copyWith(submitting: false, error: e.message));
    }
  }

  Future<void> verifyOtp(String code) async {
    if (!Validators.isValidOtp(code)) {
      emit(state.copyWith(error: 'Enter the 6-digit code.'));
      return;
    }
    emit(state.copyWith(submitting: true, error: null));

    if (_firebaseMode) {
      final verificationId = state.verificationId;
      if (verificationId == null) {
        emit(state.copyWith(submitting: false, error: 'Request a new code.'));
        return;
      }
      try {
        final idToken = await _firebase!.confirmCode(
          verificationId,
          code.trim(),
        );
        await _completeWithFirebaseToken(idToken);
      } on FirebasePhoneAuthException catch (e) {
        emit(state.copyWith(submitting: false, error: e.message));
      } catch (e) {
        emit(state.copyWith(submitting: false, error: friendlyError(e)));
      }
      return;
    }

    try {
      final user = await _repo.verifyOtp(phone: state.phone, code: code.trim());
      emit(state.copyWith(submitting: false));
      _profileStore?.markLoginGatePending();
      _authBloc.add(AuthLoggedIn(user));
    } on ApiException catch (e) {
      emit(state.copyWith(submitting: false, error: e.message));
    }
  }

  Future<void> _completeWithFirebaseToken(String idToken) async {
    try {
      final user = await _repo.loginWithFirebase(idToken);
      emit(state.copyWith(submitting: false));
      _profileStore?.markLoginGatePending();
      _authBloc.add(AuthLoggedIn(user));
    } on ApiException catch (e) {
      emit(state.copyWith(submitting: false, error: e.message));
    } catch (e) {
      emit(state.copyWith(submitting: false, error: friendlyError(e)));
    }
  }

  void editPhone() =>
      emit(state.copyWith(step: LoginStep.enterPhone, error: null));

  Future<void> resendOtp() => requestOtp(state.phone);
}
