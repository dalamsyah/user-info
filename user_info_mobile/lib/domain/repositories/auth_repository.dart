import 'package:user_info_mobile/domain/entities/user.dart';

abstract class AuthRepository {
  Future<({User user, String token})> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  });

  Future<({User user, String token})> login({
    required String email,
    required String password,
  });

  Future<void> forgotPassword({required String email});

  Future<void> resetPassword({
    required String email,
    required String password,
    required String passwordConfirmation,
    required String token,
  });

  Future<void> logout();

  Future<bool> isAuthenticated();

  Future<User?> getCurrentUser();
}
