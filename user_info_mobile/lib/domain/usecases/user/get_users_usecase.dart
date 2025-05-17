import 'package:user_info_mobile/domain/entities/user.dart';
import 'package:user_info_mobile/domain/repositories/user_repository.dart';

class GetUsersUsecase {
  final UserRepository userRepository;

  GetUsersUsecase(this.userRepository);

  Future<({List<User> users, int currentPage, int lastPage, int total})> call({
    String? search,
    int page = 1,
    int perPage = 10,
  }) {
    return userRepository.getUsers(
      search: search,
      page: page,
      perPage: perPage,
    );
  }
}
