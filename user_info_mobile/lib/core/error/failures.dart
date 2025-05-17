abstract class Failure {
  final String message;
  final Map<String, dynamic>? error;

  Failure(this.message, {this.error = const {}});

  @override
  String toString() {
    if (error != null && error!.isNotEmpty) {
      return '$runtimeType: $message — Details: ${_formatError(error!)}';
    }
    return '$runtimeType: $message';
  }

  String _formatError(Map<String, dynamic> err) {
    return err.entries.map((e) => '${e.key}: ${e.value}').join(', ');
  }
}

class ServerFailure extends Failure {
  ServerFailure(super.message, {super.error});
}

class AuthenticationFailure extends Failure {
  AuthenticationFailure(super.message, {super.error});
}

class NetworkFailure extends Failure {
  NetworkFailure(super.message, {super.error});
}

class ValidationFailure extends Failure {
  ValidationFailure(super.message, {super.error});
}
