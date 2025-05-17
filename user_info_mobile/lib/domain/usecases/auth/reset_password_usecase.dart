import 'package:user_info_mobile/domain/repositories/auth_repository.dart';

class ResetPasswordUseCase {
  final AuthRepository repository;

  ResetPasswordUseCase(this.repository);

  Future<void> call({
    required String email,
    required String password,
    required String passwordConfirmation,
    required String token,
  }) {
    return repository.resetPassword(
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
      token: token,
    );
  }
}
