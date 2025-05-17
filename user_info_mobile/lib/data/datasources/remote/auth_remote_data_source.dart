import 'package:user_info_mobile/core/error/exceptions.dart';
import 'package:user_info_mobile/core/network/api_client.dart';
import 'package:user_info_mobile/core/util/constants.dart';
import 'package:user_info_mobile/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<({UserModel user, String token})> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  });

  Future<({UserModel user, String token})> login({
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
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient client;

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<({UserModel user, String token})> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    final response = await client.post(
      ApiConstants.register,
      data: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
    );

    if (response['status']) {
      return (
        user: UserModel.fromJson(response['user']),
        token: response['access_token'] as String,
      );
    } else {
      throw ServerException(response['message'] ?? 'Registration failed');
    }
  }

  @override
  Future<({UserModel user, String token})> login({
    required String email,
    required String password,
  }) async {
    final response = await client.post(
      ApiConstants.login,
      data: {'email': email, 'password': password},
    );

    if (response['status']) {
      return (
        user: UserModel.fromJson(response['user']),
        token: response['access_token'] as String,
      );
    } else {
      throw ServerException(response['message'] ?? 'Login failed');
    }
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    final response = await client.post(
      ApiConstants.forgotPassword,
      data: {'email': email},
    );

    if (!response['status']) {
      throw ServerException(
        response['message'] ?? 'Forgot password request failed',
      );
    }
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String password,
    required String passwordConfirmation,
    required String token,
  }) async {
    final response = await client.post(
      ApiConstants.resetPassword,
      data: {
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'token': token,
      },
    );

    if (!response['status']) {
      throw ServerException(response['message'] ?? 'Password reset failed');
    }
  }

  @override
  Future<void> logout() async {
    final response = await client.post(ApiConstants.logout);

    if (!response['status']) {
      throw ServerException(response['message'] ?? 'Logout failed');
    }
  }
}
