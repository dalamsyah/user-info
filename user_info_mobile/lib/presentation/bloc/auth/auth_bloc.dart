import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_info_mobile/domain/usecases/auth/forgot_password_usecase.dart';
import 'package:user_info_mobile/domain/usecases/auth/get_current_user_usecase.dart';
import 'package:user_info_mobile/domain/usecases/auth/is_authenticated_usecase.dart';
import 'package:user_info_mobile/domain/usecases/auth/login_usecase.dart';
import 'package:user_info_mobile/domain/usecases/auth/logout_usecase.dart';
import 'package:user_info_mobile/domain/usecases/auth/register_usecase.dart';
import 'package:user_info_mobile/domain/usecases/auth/reset_password_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;
  final IsAuthenticatedUseCase isAuthenticatedUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final ForgotPasswordUseCase forgotPasswordUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
    required this.isAuthenticatedUseCase,
    required this.getCurrentUserUseCase,
    required this.forgotPasswordUseCase,
    required this.resetPasswordUseCase,
  }) : super(AuthInitial()) {
    on<AuthLoginRequested>(_onLogin);
    on<AuthRegisterRequested>(_onRegister);
    on<AuthLogoutRequested>(_onLogout);
    on<AuthCheckRequested>(_onCheckAuth);
    on<AuthGetCurrentUserRequested>(_onGetCurrentUser);
    on<AuthForgotPasswordRequested>(_onForgotPassword);
    on<AuthResetPasswordRequested>(_onResetPassword);
  }

  Future<void> _onLogin(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final result = await loginUseCase(
        email: event.email,
        password: event.password,
      );
      emit(AuthAuthenticated(result.user));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onRegister(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final result = await registerUseCase(
        name: event.name,
        email: event.email,
        password: event.password,
        passwordConfirmation: event.passwordConfirmation,
      );
      emit(AuthAuthenticated(result.user));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onLogout(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await logoutUseCase();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onCheckAuth(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    final isLoggedIn = await isAuthenticatedUseCase();
    if (!isLoggedIn) {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onGetCurrentUser(
    AuthGetCurrentUserRequested event,
    Emitter<AuthState> emit,
  ) async {
    final user = await getCurrentUserUseCase();
    if (user == null) {
      emit(AuthUnauthenticated());
    } else {
      emit(AuthAuthenticated(user));
    }
  }

  Future<void> _onForgotPassword(
    AuthForgotPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await forgotPasswordUseCase(email: event.email);
      emit(AuthForgotPasswordSuccess());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onResetPassword(
    AuthResetPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await resetPasswordUseCase(
        email: event.email,
        password: event.password,
        passwordConfirmation: event.passwordConfirmation,
        token: event.token,
      );
      emit(AuthResetPasswordSuccess());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
