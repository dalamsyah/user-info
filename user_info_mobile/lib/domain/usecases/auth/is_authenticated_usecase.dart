import 'package:user_info_mobile/domain/repositories/auth_repository.dart';

class IsAuthenticatedUseCase {
  final AuthRepository repository;

  IsAuthenticatedUseCase(this.repository);

  Future<bool> call() {
    return repository.isAuthenticated();
  }
}
