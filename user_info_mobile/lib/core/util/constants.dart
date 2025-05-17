import 'package:flutter/material.dart';
import 'package:user_info_mobile/presentation/pages/auth/forgot_password_page.dart';
import 'package:user_info_mobile/presentation/pages/auth/login_page.dart';
import 'package:user_info_mobile/presentation/pages/auth/register_page.dart';
import 'package:user_info_mobile/presentation/pages/home/home_page.dart';
import 'package:user_info_mobile/presentation/pages/profile/profile_page.dart';
import 'package:user_info_mobile/presentation/pages/user/user_details_page.dart';
import 'package:user_info_mobile/presentation/pages/user/users_list_page.dart';

class ApiConstants {
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  // Auth endpoints
  static const String register = '/register';
  static const String login = '/login';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String logout = '/logout';

  // Profile endpoints
  static const String profile = '/profile';

  // User endpoints
  static const String users = '/users';
}

class StorageKeys {
  static const String token = 'access_token';
  static const String user = 'user_data';
}

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String profile = '/profile';
  static const String users = '/users';
  static const String home = '/home';
  static const String userDetails = '/user-detail';

  static final routes = {
    login: (context) => LoginPage(),
    register: (context) => RegisterPage(),
    forgotPassword: (context) => ForgotPasswordPage(),
    profile: (context) => ProfilePage(),
    users: (context) => UserListPage(),
    home: (context) => HomePage(),
    userDetails: (context) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      final userId = args?['id'];
      return UserDetailsPage(userId: userId);
    },
  };
}
