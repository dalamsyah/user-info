import 'package:user_info_mobile/domain/entities/user.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UsersLoaded extends UserState {
  final List<User> users;
  final int currentPage;
  final int lastPage;
  final int total;

  UsersLoaded({
    required this.users,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });
}

class UserDetailsLoaded extends UserState {
  final User user;

  UserDetailsLoaded(this.user);
}

class UserFailure extends UserState {
  final String message;

  UserFailure(this.message);
}
