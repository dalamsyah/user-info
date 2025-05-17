import 'package:user_info_mobile/core/error/exceptions.dart';
import 'package:user_info_mobile/core/error/failures.dart';
import 'package:user_info_mobile/core/network/network_info.dart';
import 'package:user_info_mobile/data/datasources/local/auth_local_data_source.dart';
import 'package:user_info_mobile/data/datasources/remote/auth_remote_data_source.dart';
import 'package:user_info_mobile/domain/entities/user.dart';
import 'package:user_info_mobile/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<({User user, String token})> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.register(
          name: name,
          email: email,
          password: password,
          passwordConfirmation: passwordConfirmation,
        );

        // Cache the token and user data
        await localDataSource.cacheToken(result.token);
        await localDataSource.cacheUser(result.user);

        return (user: result.user, token: result.token);
      } on ServerException catch (e) {
        throw ServerFailure(e.message);
      } on ValidationException catch (e) {
        throw ValidationFailure(e.message, error: e.errors);
      }
    } else {
      throw NetworkFailure('No internet connection');
    }
  }

  @override
  Future<({User user, String token})> login({
    required String email,
    required String password,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.login(
          email: email,
          password: password,
        );

        await localDataSource.cacheToken(result.token);
        await localDataSource.cacheUser(result.user);

        return (user: result.user, token: result.token);
      } on ServerException catch (e) {
        throw ServerFailure(e.message);
      } on UnauthorizedException catch (e) {
        throw AuthenticationFailure(e.message);
      }
    } else {
      throw NetworkFailure('No internet connection');
    }
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.forgotPassword(email: email);
      } on ServerException catch (e) {
        throw ServerFailure(e.message);
      }
    } else {
      throw NetworkFailure('No internet connection');
    }
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String password,
    required String passwordConfirmation,
    required String token,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.resetPassword(
          email: email,
          password: password,
          passwordConfirmation: passwordConfirmation,
          token: token,
        );
      } on ServerException catch (e) {
        throw ServerFailure(e.message);
      } on ValidationException catch (e) {
        throw ValidationFailure(e.message, error: e.errors);
      }
    } else {
      throw NetworkFailure('No internet connection');
    }
  }

  @override
  Future<void> logout() async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.logout();
        await localDataSource.removeToken();
        await localDataSource.removeUser();
      } on ServerException catch (e) {
        throw ServerFailure(e.message);
      }
    } else {
      await localDataSource.removeToken();
      await localDataSource.removeUser();
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = await localDataSource.getToken();
    return token != null;
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      return await localDataSource.getUser();
    } on CacheException {
      return null;
    }
  }
}
