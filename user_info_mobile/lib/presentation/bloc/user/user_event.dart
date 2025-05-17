abstract class UserEvent {}

class GetUsersRequested extends UserEvent {
  final String? search;
  final int page;
  final int perPage;

  GetUsersRequested({this.search, this.page = 1, this.perPage = 10});
}

class GetUserDetailsRequested extends UserEvent {
  final int userId;

  GetUserDetailsRequested(this.userId);
}
