import 'package:user_info_mobile/domain/entities/user.dart';
import 'package:user_info_mobile/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<({User user, String token})> call({
    required String email,
    required String password,
  }) {
    return repository.login(email: email, password: password);
  }
}
