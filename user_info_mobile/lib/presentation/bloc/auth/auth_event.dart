// bloc/auth_event.dart
abstract class AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  AuthLoginRequested({required this.email, required this.password});
}

class AuthRegisterRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String passwordConfirmation;

  AuthRegisterRequested({
    required this.name,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
  });
}

class AuthLogoutRequested extends AuthEvent {}

class AuthCheckRequested extends AuthEvent {}

class AuthGetCurrentUserRequested extends AuthEvent {}

class AuthForgotPasswordRequested extends AuthEvent {
  final String email;

  AuthForgotPasswordRequested({required this.email});
}

class AuthResetPasswordRequested extends AuthEvent {
  final String email;
  final String password;
  final String passwordConfirmation;
  final String token;

  AuthResetPasswordRequested({
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    required this.token,
  });
}
