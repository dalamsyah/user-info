import 'package:user_info_mobile/domain/entities/user.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final User user;

  ProfileLoaded(this.user);
}

class ProfileUpdated extends ProfileState {
  final User user;

  ProfileUpdated(this.user);
}

class ProfileFailure extends ProfileState {
  final String message;

  ProfileFailure(this.message);
}
