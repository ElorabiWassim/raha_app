import 'dart:io';
import 'package:http/http.dart' as http;
import '../exceptions/app_exceptions.dart';

class ErrorHandler {
  /// Handle HTTP errors and convert to appropriate exceptions
  static AppException handleHttpError(dynamic error) {
    if (error is SocketException) {
      return NetworkException(
        'No internet connection. Please check your network.',
        originalError: error,
      );
    }

    if (error is http.ClientException) {
      return NetworkException(
        'Failed to connect to the server. Please try again.',
        originalError: error,
      );
    }

    if (error is HttpException) {
      return NetworkException(
        'Network error occurred. Please try again.',
        originalError: error,
      );
    }

    if (error is FormatException) {
      return ApiException(
        'Invalid data format received from server.',
        originalError: error,
      );
    }

    return AppException(
      'An unexpected error occurred. Please try again.',
      originalError: error,
    );
  }

  /// Handle API response errors based on status code
  static AppException handleApiResponse(int statusCode, String? message) {
    switch (statusCode) {
      case 400:
        return ValidationException(
          message ?? 'Invalid request. Please check your input.',
          code: '400',
        );
      case 401:
        return AuthenticationException(
          message ?? 'Authentication failed. Please login again.',
          code: '401',
        );
      case 403:
        return AuthorizationException(
          message ?? 'You don\'t have permission to perform this action.',
          code: '403',
        );
      case 404:
        return NotFoundException(
          message ?? 'The requested resource was not found.',
          code: '404',
        );
      case 422:
        return ValidationException(
          message ?? 'Validation failed. Please check your input.',
          code: '422',
        );
      case 500:
      case 501:
      case 502:
      case 503:
        return ServerException(
          message ?? 'Server error occurred. Please try again later.',
          code: statusCode.toString(),
        );
      default:
        return ApiException(
          message ?? 'An error occurred. Please try again.',
          statusCode: statusCode,
        );
    }
  }

  /// Get user-friendly error message
  static String getUserMessage(dynamic error) {
    if (error is AppException) {
      return error.message;
    }

    if (error is SocketException) {
      return 'No internet connection. Please check your network.';
    }

    if (error is FormatException) {
      return 'Invalid data format. Please try again.';
    }

    return 'An unexpected error occurred. Please try again.';
  }

  /// Check if error is network related
  static bool isNetworkError(dynamic error) {
    return error is NetworkException ||
        error is SocketException ||
        error is HttpException;
  }

  /// Check if error is authentication related
  static bool isAuthError(dynamic error) {
    return error is AuthenticationException || error is AuthorizationException;
  }

  /// Log error for debugging (can be extended to use logging packages)
  static void logError(dynamic error, [StackTrace? stackTrace]) {
    print('ERROR: $error');
    if (stackTrace != null) {
      print('STACK TRACE: $stackTrace');
    }
  }
}
