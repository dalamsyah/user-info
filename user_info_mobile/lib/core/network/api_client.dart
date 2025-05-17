import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_info_mobile/core/error/exceptions.dart';
import 'package:user_info_mobile/core/util/constants.dart';

abstract class ApiClient {
  Future<dynamic> get(String url, {Map<String, dynamic>? queryParameters});
  Future<dynamic> post(String url, {dynamic data});
  Future<dynamic> postMultipart(String url, {required FormData formData});
  String? getToken();
  Future<void> setToken(String token);
  Future<void> clearToken();
}

class ApiClientImpl implements ApiClient {
  final Dio dio;
  final SharedPreferences sharedPreferences;

  ApiClientImpl({required this.dio, required this.sharedPreferences}) {
    dio.options.baseUrl = ApiConstants.baseUrl;
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);
    dio.options.headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          return handler.next(e);
        },
      ),
    );
  }

  @override
  Future<dynamic> get(
    String url, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await dio.get(url, queryParameters: queryParameters);
      return response.data;
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  @override
  Future<dynamic> post(String url, {dynamic data}) async {
    try {
      final response = await dio.post(url, data: data);
      return response.data;
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  @override
  Future<dynamic> postMultipart(
    String url, {
    required FormData formData,
  }) async {
    try {
      final response = await dio.post(
        url,
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );
      return response.data;
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  @override
  String? getToken() {
    return sharedPreferences.getString(StorageKeys.token);
  }

  @override
  Future<void> setToken(String token) async {
    await sharedPreferences.setString(StorageKeys.token, token);
  }

  @override
  Future<void> clearToken() async {
    await sharedPreferences.remove(StorageKeys.token);
  }

  void _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw TimeoutException(e.message ?? "Connection timeout");
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final responseData = e.response?.data;
        switch (statusCode) {
          case 401:
            throw UnauthorizedException(
              responseData?['message'] ?? "Unauthorized",
            );
          case 404:
            throw NotFoundException(
              responseData?['message'] ?? "Resource not found",
            );
          case 422:
            throw ValidationException(
              responseData?['message'] ?? "Validation error",
              responseData?['errors'],
            );
          default:
            throw ServerException(
              responseData?['message'] ?? "Server error occurred",
            );
        }
      case DioExceptionType.cancel:
        throw RequestCancelledException("Request cancelled");
      default:
        throw ServerException("Connection error: ${e.message}");
    }
  }
}
