import 'dart:io';

abstract class ProfileEvent {}

class GetProfileRequested extends ProfileEvent {}

class UpdateProfileRequested extends ProfileEvent {
  final String name;
  final String email;
  final String? currentPassword;
  final String? password;
  final String? passwordConfirmation;
  final String? bio;
  final String? phone;
  final String? address;
  final List<String>? hobbies;
  final List<String>? favoriteFoods;
  final int? height;
  final int? weight;
  final String? birthdate;
  final String? occupation;
  final List<String>? socialMediaLinks;
  final String? website;
  final File? profilePhotoPath;

  UpdateProfileRequested({
    required this.name,
    required this.email,
    this.currentPassword,
    this.password,
    this.passwordConfirmation,
    this.bio,
    this.phone,
    this.address,
    this.hobbies,
    this.favoriteFoods,
    this.height,
    this.weight,
    this.birthdate,
    this.occupation,
    this.socialMediaLinks,
    this.website,
    this.profilePhotoPath,
  });
}
