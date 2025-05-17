class ServerException implements Exception {
  final String message;
  ServerException(this.message);
}

class NotFoundException implements Exception {
  final String message;
  NotFoundException(this.message);
}

class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException(this.message);
}

class ValidationException implements Exception {
  final String message;
  final Map<String, dynamic>? errors;
  ValidationException(this.message, this.errors);
}

class TimeoutException implements Exception {
  final String message;
  TimeoutException(this.message);
}

class RequestCancelledException implements Exception {
  final String message;
  RequestCancelledException(this.message);
}
