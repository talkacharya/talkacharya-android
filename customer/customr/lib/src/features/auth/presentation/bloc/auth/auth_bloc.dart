import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/auth_repository.dart';
import '../../../data/models/auth_user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

/// App-wide session state. The router listens to this to gate routes.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._repo) : super(const AuthState.unknown()) {
    on<AuthStarted>(_onStarted);
    on<AuthLoggedIn>((e, emit) => emit(AuthState.authenticated(e.user)));
    on<AuthLogoutRequested>(_onLogout);
    on<AuthSessionExpired>(
      (e, emit) => emit(const AuthState.unauthenticated()),
    );
  }

  final AuthRepository _repo;

  Future<void> _onStarted(AuthStarted event, Emitter<AuthState> emit) async {
    if (!await _repo.hasSession()) {
      emit(const AuthState.unauthenticated());
      return;
    }
    try {
      final user = await _repo.currentUser();
      emit(AuthState.authenticated(user));
    } catch (_) {
      // token invalid / offline with no cache -> treat as logged out
      await _repo.logout();
      emit(const AuthState.unauthenticated());
    }
  }

  Future<void> _onLogout(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _repo.logout();
    emit(const AuthState.unauthenticated());
  }
}
