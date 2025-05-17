import 'package:user_info_mobile/domain/entities/user.dart';
import 'package:user_info_mobile/domain/repositories/user_repository.dart';

class GetUserDetailsUsecase {
  final UserRepository userRepository;

  GetUserDetailsUsecase(this.userRepository);

  Future<User> call(int userId) async {
    return await userRepository.getUserDetails(userId);
  }
}
