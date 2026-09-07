import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/network/api_exception.dart';
import '../../../../../core/utils/validators.dart';
import '../../../data/auth_repository.dart';
import '../auth/auth_bloc.dart';

part 'login_state.dart';

/// Drives the two-step phone -> OTP flow. On success it pushes [AuthLoggedIn]
/// into [AuthBloc] and the router swaps to the app shell.
class LoginCubit extends Cubit<LoginState> {
  LoginCubit({required AuthRepository repo, required AuthBloc authBloc})
    : _repo = repo,
      _authBloc = authBloc,
      super(const LoginState());

  final AuthRepository _repo;
  final AuthBloc _authBloc;

  Future<void> requestOtp(String rawPhone) async {
    final e164 = Validators.toE164India(rawPhone);
    if (e164 == null) {
      emit(state.copyWith(error: 'Enter a valid 10-digit mobile number.'));
      return;
    }
    emit(state.copyWith(submitting: true, error: null, phone: e164));
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
    try {
      final user = await _repo.verifyOtp(phone: state.phone, code: code.trim());
      emit(state.copyWith(submitting: false));
      _authBloc.add(AuthLoggedIn(user));
    } on ApiException catch (e) {
      emit(state.copyWith(submitting: false, error: e.message));
    }
  }

  void editPhone() =>
      emit(state.copyWith(step: LoginStep.enterPhone, error: null));

  Future<void> resendOtp() => requestOtp(state.phone);
}
