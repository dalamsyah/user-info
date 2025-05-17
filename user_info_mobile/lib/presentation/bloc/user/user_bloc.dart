import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_info_mobile/domain/usecases/user/get_user_details_usecase.dart';
import 'package:user_info_mobile/domain/usecases/user/get_users_usecase.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUsersUsecase getUsersUseCase;
  final GetUserDetailsUsecase getUserDetailsUseCase;

  UserBloc({required this.getUsersUseCase, required this.getUserDetailsUseCase})
    : super(UserInitial()) {
    on<GetUsersRequested>(_onGetUsers);
    on<GetUserDetailsRequested>(_onGetUserDetails);
  }

  Future<void> _onGetUsers(
    GetUsersRequested event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    try {
      final result = await getUsersUseCase(
        search: event.search,
        page: event.page,
        perPage: event.perPage,
      );
      emit(
        UsersLoaded(
          users: result.users,
          currentPage: result.currentPage,
          lastPage: result.lastPage,
          total: result.total,
        ),
      );
    } catch (e) {
      emit(UserFailure(e.toString()));
    }
  }

  Future<void> _onGetUserDetails(
    GetUserDetailsRequested event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    try {
      final user = await getUserDetailsUseCase(event.userId);
      emit(UserDetailsLoaded(user));
    } catch (e) {
      emit(UserFailure(e.toString()));
    }
  }
}
