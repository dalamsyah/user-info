import 'dart:io';
import 'package:dio/dio.dart';
import 'package:user_info_mobile/core/error/exceptions.dart';
import 'package:user_info_mobile/core/network/api_client.dart';
import 'package:user_info_mobile/core/util/constants.dart';
import 'package:user_info_mobile/data/models/user_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserModel> getProfile();

  Future<UserModel> updateProfile({
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
    File? profilePhoto,
  });
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiClient client;

  ProfileRemoteDataSourceImpl({required this.client});

  @override
  Future<UserModel> getProfile() async {
    final response = await client.get(ApiConstants.profile);

    if (response['status']) {
      return UserModel.fromJson(response['user']);
    } else {
      throw ServerException(response['message'] ?? 'Failed to fetch profile');
    }
  }

  @override
  Future<UserModel> updateProfile({
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
    File? profilePhoto,
  }) async {
    final formData = FormData();

    formData.fields.add(MapEntry('name', name));
    formData.fields.add(MapEntry('email', email));

    if (currentPassword != null) {
      formData.fields.add(MapEntry('current_password', currentPassword));
    }

    if (password != null) {
      formData.fields.add(MapEntry('password', password));
    }

    if (passwordConfirmation != null) {
      formData.fields.add(
        MapEntry('password_confirmation', passwordConfirmation),
      );
    }

    if (bio != null) {
      formData.fields.add(MapEntry('bio', bio));
    }

    if (phone != null) {
      formData.fields.add(MapEntry('phone', phone));
    }

    if (address != null) {
      formData.fields.add(MapEntry('address', address));
    }

    if (hobbies != null) {
      for (int i = 0; i < hobbies.length; i++) {
        formData.fields.add(MapEntry('hobbies[$i]', hobbies[i]));
      }
    }

    if (favoriteFoods != null) {
      for (int i = 0; i < favoriteFoods.length; i++) {
        formData.fields.add(MapEntry('favorite_foods[$i]', favoriteFoods[i]));
      }
    }

    if (height != null) {
      formData.fields.add(MapEntry('height', height.toString()));
    }

    if (weight != null) {
      formData.fields.add(MapEntry('weight', weight.toString()));
    }

    if (birthdate != null) {
      formData.fields.add(MapEntry('birthdate', birthdate));
    }

    if (occupation != null) {
      formData.fields.add(MapEntry('occupation', occupation));
    }

    if (socialMediaLinks != null) {
      for (int i = 0; i < socialMediaLinks.length; i++) {
        formData.fields.add(
          MapEntry('social_media_links[$i]', socialMediaLinks[i]),
        );
      }
    }

    if (website != null) {
      formData.fields.add(MapEntry('website', website));
    }

    if (profilePhoto != null) {
      formData.files.add(
        MapEntry(
          'profile_photo',
          await MultipartFile.fromFile(
            profilePhoto.path,
            filename: profilePhoto.path.split('/').last,
          ),
        ),
      );
    }

    final response = await client.postMultipart(
      ApiConstants.profile,
      formData: formData,
    );

    if (response['status']) {
      return UserModel.fromJson(response['user']);
    } else {
      throw ServerException(response['message'] ?? 'Failed to update profile');
    }
  }
}
