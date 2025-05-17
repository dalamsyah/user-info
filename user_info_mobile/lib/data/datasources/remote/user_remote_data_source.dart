import 'package:user_info_mobile/core/error/exceptions.dart';
import 'package:user_info_mobile/core/network/api_client.dart';
import 'package:user_info_mobile/core/util/constants.dart';
import 'package:user_info_mobile/data/models/user_list_response_model.dart';
import 'package:user_info_mobile/data/models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<UserListResponseModel> getUsers({
    String? search,
    int page = 1,
    int perPage = 10,
  });

  Future<UserModel> getUserDetails(int userId);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final ApiClient client;

  UserRemoteDataSourceImpl({required this.client});

  @override
  Future<UserListResponseModel> getUsers({
    String? search,
    int page = 1,
    int perPage = 10,
  }) async {
    final queryParams = {
      'page': page.toString(),
      'per_page': perPage.toString(),
    };

    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }

    final response = await client.get(
      ApiConstants.users,
      queryParameters: queryParams,
    );

    if (response['status']) {
      return UserListResponseModel.fromJson(response);
    } else {
      throw ServerException(response['message'] ?? 'Failed to fetch users');
    }
  }

  @override
  Future<UserModel> getUserDetails(int userId) async {
    final response = await client.get('${ApiConstants.users}/$userId');

    if (response['status']) {
      return UserModel.fromJson(response['user']);
    } else {
      throw ServerException(
        response['message'] ?? 'Failed to fetch user details',
      );
    }
  }
}
