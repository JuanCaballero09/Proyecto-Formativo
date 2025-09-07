/// Base exception class for the application
abstract class AppException implements Exception {
  final String message;
  final String? code;
  
  AppException(this.message, [this.code]);
  
  @override
  String toString() => 'AppException: [$code] $message';
}

/// Exception for network related errors
class NetworkException extends AppException {
  NetworkException([String message = 'Error de conexión']) 
    : super(message, 'NET_ERR');
}

/// Exception for authentication related errors
class AuthException extends AppException {
  AuthException([String message = 'Error de autenticación']) 
    : super(message, 'AUTH_ERR');
}

/// Exception for data processing related errors
class DataException extends AppException {
  DataException([String message = 'Error en los datos']) 
    : super(message, 'DATA_ERR');
}

/// Exception for validation related errors
class ValidationException extends AppException {
  ValidationException([String message = 'Error de validación']) 
    : super(message, 'VAL_ERR');
}
