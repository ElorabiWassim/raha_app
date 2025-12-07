/// Custom exception classes for better error handling

class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  AppException(this.message, {this.code, this.originalError});

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  NetworkException(String message, {String? code, dynamic originalError})
    : super(message, code: code, originalError: originalError);
}

class ApiException extends AppException {
  final int? statusCode;

  ApiException(
    String message, {
    this.statusCode,
    String? code,
    dynamic originalError,
  }) : super(message, code: code, originalError: originalError);
}

class ValidationException extends AppException {
  final Map<String, String>? fieldErrors;

  ValidationException(
    String message, {
    this.fieldErrors,
    String? code,
    dynamic originalError,
  }) : super(message, code: code, originalError: originalError);
}

class AuthenticationException extends AppException {
  AuthenticationException(String message, {String? code, dynamic originalError})
    : super(message, code: code, originalError: originalError);
}

class AuthorizationException extends AppException {
  AuthorizationException(String message, {String? code, dynamic originalError})
    : super(message, code: code, originalError: originalError);
}

class NotFoundException extends AppException {
  NotFoundException(String message, {String? code, dynamic originalError})
    : super(message, code: code, originalError: originalError);
}

class ServerException extends AppException {
  ServerException(String message, {String? code, dynamic originalError})
    : super(message, code: code, originalError: originalError);
}
