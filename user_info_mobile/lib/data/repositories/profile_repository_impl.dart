import 'dart:io';

import 'package:user_info_mobile/core/error/exceptions.dart';
import 'package:user_info_mobile/core/error/failures.dart';
import 'package:user_info_mobile/core/network/network_info.dart';
import 'package:user_info_mobile/data/datasources/remote/profile_remote_data_source.dart';
import 'package:user_info_mobile/domain/entities/user.dart';
import 'package:user_info_mobile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<User> getProfile() async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.getProfile();
        return user;
      } on ServerException catch (e) {
        throw ServerFailure(e.message);
      }
    } else {
      throw NetworkFailure('No internet connection');
    }
  }

  @override
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
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.updateProfile(
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
          profilePhoto: profilePhotoPath,
        );
        return user;
      } on ServerException catch (e) {
        throw ServerFailure(e.message);
      }
    } else {
      throw NetworkFailure('No internet connection');
    }
  }
}
