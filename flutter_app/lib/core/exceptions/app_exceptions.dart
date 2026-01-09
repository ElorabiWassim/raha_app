/// Custom exception classes for better error handling
library;

class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  AppException(this.message, {this.code, this.originalError});

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  NetworkException(super.message, {super.code, super.originalError});
}

class ApiException extends AppException {
  final int? statusCode;

  ApiException(
    super.message, {
    this.statusCode,
    super.code,
    super.originalError,
  });
}

class ValidationException extends AppException {
  final Map<String, String>? fieldErrors;

  ValidationException(
    super.message, {
    this.fieldErrors,
    super.code,
    super.originalError,
  });
}

class AuthenticationException extends AppException {
  AuthenticationException(super.message, {super.code, super.originalError});
}

class AuthorizationException extends AppException {
  AuthorizationException(super.message, {super.code, super.originalError});
}

class NotFoundException extends AppException {
  NotFoundException(super.message, {super.code, super.originalError});
}

class ServerException extends AppException {
  ServerException(super.message, {super.code, super.originalError});
}
