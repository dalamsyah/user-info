import 'package:user_info_mobile/domain/entities/user.dart';

abstract class UserRepository {
  Future<({List<User> users, int currentPage, int lastPage, int total})>
  getUsers({String? search, int page = 1, int perPage = 10});

  Future<User> getUserDetails(int userId);
}
