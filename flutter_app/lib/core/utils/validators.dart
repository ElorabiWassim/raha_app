/// Form validation utilities for the app
library;

class Validators {
  /// Validate email format
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  /// Validate phone number (Algerian format)
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    // Remove spaces and special characters
    final cleanedNumber = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');

    // Algerian phone numbers: 0X XX XX XX XX or +213 X XX XX XX XX
    final phoneRegex = RegExp(r'^(0|\+213)[5-7]\d{8}$');

    if (!phoneRegex.hasMatch(cleanedNumber)) {
      return 'Please enter a valid Algerian phone number';
    }

    return null;
  }

  /// Validate required field
  static String? validateRequired(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    return null;
  }

  /// Validate minimum length
  static String? validateMinLength(
    String? value,
    int minLength, {
    String? fieldName,
  }) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }

    if (value.length < minLength) {
      return '${fieldName ?? 'This field'} must be at least $minLength characters';
    }

    return null;
  }

  /// Validate maximum length
  static String? validateMaxLength(
    String? value,
    int maxLength, {
    String? fieldName,
  }) {
    if (value != null && value.length > maxLength) {
      return '${fieldName ?? 'This field'} must not exceed $maxLength characters';
    }

    return null;
  }

  /// Validate password strength
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }

    // Check for at least one uppercase letter
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }

    // Check for at least one lowercase letter
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }

    // Check for at least one digit
    if (!RegExp(r'\d').hasMatch(value)) {
      return 'Password must contain at least one number';
    }

    return null;
  }

  /// Validate number
  static String? validateNumber(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }

    if (double.tryParse(value) == null) {
      return 'Please enter a valid number';
    }

    return null;
  }

  /// Validate positive number
  static String? validatePositiveNumber(String? value, {String? fieldName}) {
    final numberError = validateNumber(value, fieldName: fieldName);
    if (numberError != null) {
      return numberError;
    }

    final number = double.parse(value!);
    if (number <= 0) {
      return '${fieldName ?? 'Value'} must be greater than 0';
    }

    return null;
  }

  /// Validate rating (1-5)
  static String? validateRating(double? value) {
    if (value == null || value < 1 || value > 5) {
      return 'Please provide a rating between 1 and 5';
    }

    return null;
  }

  /// Validate experience years
  static String? validateExperienceYears(String? value) {
    if (value == null || value.isEmpty) {
      return 'Years of experience is required';
    }

    final years = int.tryParse(value);
    if (years == null) {
      return 'Please enter a valid number';
    }

    if (years < 0) {
      return 'Years of experience cannot be negative';
    }

    if (years > 50) {
      return 'Please enter a realistic number of years';
    }

    return null;
  }

  /// Validate wilaya (Algerian provinces)
  static String? validateWilaya(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a wilaya';
    }

    return null;
  }

  /// Combine multiple validators
  static String? combineValidators(
    String? value,
    List<String? Function(String?)> validators,
  ) {
    for (final validator in validators) {
      final error = validator(value);
      if (error != null) {
        return error;
      }
    }
    return null;
  }
}
