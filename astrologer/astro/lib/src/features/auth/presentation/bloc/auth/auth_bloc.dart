import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/network/api_exception.dart';
import '../../../data/auth_repository.dart';
import '../../../data/models/auth_user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

/// App-wide session state. The router listens to this to gate routes.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._repo) : super(const AuthState.unknown()) {
    on<AuthStarted>(_onStarted);
    on<AuthLoggedIn>((e, emit) => emit(AuthState.authenticated(e.user)));
    on<AuthUserUpdated>((e, emit) async {
      if (state.status != AuthStatus.authenticated) return;
      await _repo.cacheUser(e.user);
      emit(AuthState.authenticated(e.user));
    });
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

    // Open instantly with the cached user; verify against /me in the background.
    final cached = await _repo.cachedUser();
    if (cached != null) emit(AuthState.authenticated(cached));

    try {
      final user = await _repo.currentUser();
      emit(AuthState.authenticated(user));
    } on ApiException catch (e) {
      if (e.isNetwork) {
        // Offline / server unreachable — keep the session. Screens refetch when
        // connectivity returns; a genuine auth failure would be a 401, handled by
        // the interceptor (which fires AuthSessionExpired on refresh failure).
        if (cached == null) emit(const AuthState.unauthenticated());
        return;
      }
      await _repo.logout();
      emit(const AuthState.unauthenticated());
    } catch (_) {
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
