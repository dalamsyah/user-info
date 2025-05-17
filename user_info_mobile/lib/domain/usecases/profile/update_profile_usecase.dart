import 'dart:io';

import 'package:user_info_mobile/domain/entities/user.dart';
import 'package:user_info_mobile/domain/repositories/profile_repository.dart';

class UpdateProfileUsecase {
  final ProfileRepository repository;

  UpdateProfileUsecase(this.repository);

  Future<User> call({
    required String name,
    required String email,
    String? currentPassword,
    String? password,
    String? passwordConfirmation,
    String? bio,
    String? phone,
    String? address,
    List<String>? hobbies,
    List<String>? favoriteFoods,
    int? height,
    int? weight,
    String? birthdate,
    String? occupation,
    List<String>? socialMediaLinks,
    String? website,
    File? profilePhotoPath,
  }) {
    return repository.updateProfile(
      name: name,
      email: email,
      currentPassword: currentPassword,
      password: password,
      passwordConfirmation: passwordConfirmation,
      bio: bio,
      phone: phone,
      address: address,
      hobbies: hobbies,
      favoriteFoods: favoriteFoods,
      height: height,
      weight: weight,
      birthdate: birthdate,
      occupation: occupation,
      socialMediaLinks: socialMediaLinks,
      website: website,
      profilePhotoPath: profilePhotoPath,
    );
  }
}
