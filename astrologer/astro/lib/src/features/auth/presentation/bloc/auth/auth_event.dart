part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

/// Fired once at startup: decide authenticated vs not from stored tokens.
class AuthStarted extends AuthEvent {
  const AuthStarted();
}

/// Fired by the login flow after a successful verify.
class AuthLoggedIn extends AuthEvent {
  const AuthLoggedIn(this.user);
  final AuthUser user;
  @override
  List<Object?> get props => [user];
}

/// User tapped log out.
class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

/// Token refresh failed somewhere in the app; drop to the login screen.
class AuthSessionExpired extends AuthEvent {
  const AuthSessionExpired();
}
