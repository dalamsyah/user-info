import 'dart:io';

import 'package:user_info_mobile/domain/entities/user.dart';

abstract class ProfileRepository {
  Future<User> getProfile();

  Future<User> updateProfile({
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
  });
}
