import 'package:user_info_mobile/core/error/exceptions.dart';
import 'package:user_info_mobile/core/error/failures.dart';
import 'package:user_info_mobile/core/network/network_info.dart';
import 'package:user_info_mobile/data/datasources/remote/user_remote_data_source.dart';
import 'package:user_info_mobile/domain/entities/user.dart';
import 'package:user_info_mobile/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  UserRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<({List<User> users, int currentPage, int lastPage, int total})>
  getUsers({String? search, int page = 1, int perPage = 10}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getUsers(
          search: search,
          page: page,
          perPage: perPage,
        );
        return (
          users: result.data.data,
          currentPage: result.data.currentPage,
          lastPage: result.data.lastPage,
          total: result.data.total,
        );
      } on ServerException catch (e) {
        throw ServerFailure(e.message);
      }
    } else {
      throw NetworkFailure('No internet connection');
    }
  }

  @override
  Future<User> getUserDetails(int userId) async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.getUserDetails(userId);
        return user;
      } on ServerException catch (e) {
        throw ServerFailure(e.message);
      }
    } else {
      throw NetworkFailure('No internet connection');
    }
  }
}
