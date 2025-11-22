/// Base exception class for the application
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;
  final StackTrace? stackTrace;
  
  AppException(
    this.message, [
    this.code,
    this.originalError,
    this.stackTrace,
  ]);
  
  @override
  String toString() => 'AppException: [$code] $message';
}

/// Exception for network related errors
class NetworkException extends AppException {
  NetworkException({
    String message = 'Network connection error',
    String code = 'NET_ERR',
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(message, code, originalError, stackTrace);

  factory NetworkException.timeout() {
    return NetworkException(
      message: 'Request timed out. Please try again.',
      code: 'TIMEOUT',
    );
  }

  factory NetworkException.noInternet() {
      return NetworkException(
      message: 'No internet connection.',
      code: 'NO_INTERNET',
    );
  }

  factory NetworkException.serverError() {
      return NetworkException(
      message: 'Server error. Please try again later.',
      code: 'SERVER_ERROR',
    );
  }
}

/// Exception for authentication related errors
class AuthException extends AppException {
  AuthException({
    String message = 'Authentication error',
    String code = 'AUTH_ERR',
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(message, code, originalError, stackTrace);

  factory AuthException.invalidCredentials() {
      return AuthException(
      message: 'Invalid email or password.',
      code: 'INVALID_CREDENTIALS',
    );
  }

  factory AuthException.userNotFound() {
      return AuthException(
      message: 'User not found.',
      code: 'USER_NOT_FOUND',
    );
  }

  factory AuthException.accountDisabled() {
      return AuthException(
      message: 'This account has been disabled.',
      code: 'ACCOUNT_DISABLED',
    );
  }

  factory AuthException.sessionExpired() {
      return AuthException(
      message: 'Your session has expired. Please log in again.',
      code: 'SESSION_EXPIRED',
    );
  }
}

/// Exception for data processing related errors
class DataException extends AppException {
  DataException({
    String message = 'Data error',
    String code = 'DATA_ERR',
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(message, code, originalError, stackTrace);

  factory DataException.parseError() {
      return DataException(
      message: 'Error processing data.',
      code: 'PARSE_ERR',
    );
  }

  factory DataException.emptyData() {
      return DataException(
      message: 'No data available.',
      code: 'EMPTY_DATA',
    );
  }
}

/// Exception for validation related errors
class ValidationException extends AppException {
  ValidationException({
    String message = 'Validation error',
    String code = 'VAL_ERR',
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(message, code, originalError, stackTrace);

  factory ValidationException.emptyEmail() {
      return ValidationException(
      message: 'Please enter your email address.',
      code: 'EMPTY_EMAIL',
    );
  }

  factory ValidationException.invalidEmail() {
      return ValidationException(
      message: 'Enter a valid email address.',
      code: 'INVALID_EMAIL',
    );
  }

  factory ValidationException.emptyPassword() {
      return ValidationException(
      message: 'Please enter your password.',
      code: 'EMPTY_PASSWORD',
    );
  }

  factory ValidationException.weakPassword() {
      return ValidationException(
      message: 'Password must be at least 6 characters.',
      code: 'WEAK_PASSWORD',
    );
  }

  factory ValidationException.passwordMismatch() {
      return ValidationException(
      message: 'Passwords do not match.',
      code: 'PASSWORD_MISMATCH',
    );
  }
}

/// Exception for operation related errors
class OperationException extends AppException {
  OperationException({
    String message = 'Operation error',
    String code = 'OPERATION_ERR',
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(message, code, originalError, stackTrace);
}
