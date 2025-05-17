import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_info_mobile/domain/usecases/profile/get_profile_usecase.dart';
import 'package:user_info_mobile/domain/usecases/profile/update_profile_usecase.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUsecase getProfileUseCase;
  final UpdateProfileUsecase updateProfileUseCase;

  ProfileBloc({
    required this.getProfileUseCase,
    required this.updateProfileUseCase,
  }) : super(ProfileInitial()) {
    on<GetProfileRequested>(_onGetProfile);
    on<UpdateProfileRequested>(_onUpdateProfile);
  }

  Future<void> _onGetProfile(
    GetProfileRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      final user = await getProfileUseCase();
      emit(ProfileLoaded(user));
    } catch (e) {
      emit(ProfileFailure(e.toString()));
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfileRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      final user = await updateProfileUseCase(
        name: event.name,
        email: event.email,
        currentPassword: event.currentPassword,
        password: event.password,
        passwordConfirmation: event.passwordConfirmation,
        bio: event.bio,
        phone: event.phone,
        address: event.address,
        hobbies: event.hobbies,
        favoriteFoods: event.favoriteFoods,
        height: event.height,
        weight: event.weight,
        birthdate: event.birthdate,
        occupation: event.occupation,
        socialMediaLinks: event.socialMediaLinks,
        website: event.website,
        profilePhotoPath: event.profilePhotoPath,
      );
      emit(ProfileUpdated(user));
    } catch (e) {
      emit(ProfileFailure(e.toString()));
    }
  }
}
