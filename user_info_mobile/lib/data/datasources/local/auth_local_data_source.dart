import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_info_mobile/core/util/constants.dart';
import 'package:user_info_mobile/data/models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheToken(String token);

  Future<String?> getToken();

  Future<void> removeToken();

  Future<void> cacheUser(UserModel user);

  Future<UserModel?> getUser();

  Future<void> removeUser();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheToken(String token) async {
    await sharedPreferences.setString(StorageKeys.token, token);
  }

  @override
  Future<String?> getToken() async {
    return sharedPreferences.getString(StorageKeys.token);
  }

  @override
  Future<void> removeToken() async {
    await sharedPreferences.remove(StorageKeys.token);
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    await sharedPreferences.setString(StorageKeys.user, user.toRawJson());
  }

  @override
  Future<UserModel?> getUser() async {
    final jsonString = sharedPreferences.getString(StorageKeys.user);
    if (jsonString != null) {
      try {
        return UserModel.fromRawJson(jsonString);
      } catch (e) {
        throw CacheException();
      }
    }
    return null;
  }

  @override
  Future<void> removeUser() async {
    await sharedPreferences.remove(StorageKeys.user);
  }
}

class CacheException implements Exception {}
