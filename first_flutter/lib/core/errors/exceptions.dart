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
    String message = 'Error de conexión',
    String code = 'NET_ERR',
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(message, code, originalError, stackTrace);

  factory NetworkException.timeout() {
    return NetworkException(
      message: 'La solicitud tardó demasiado. Intenta de nuevo.',
      code: 'TIMEOUT',
    );
  }

  factory NetworkException.noInternet() {
    return NetworkException(
      message: 'No hay conexión a internet.',
      code: 'NO_INTERNET',
    );
  }

  factory NetworkException.serverError() {
    return NetworkException(
      message: 'Error del servidor. Intenta más tarde.',
      code: 'SERVER_ERROR',
    );
  }
}

/// Exception for authentication related errors
class AuthException extends AppException {
  AuthException({
    String message = 'Error de autenticación',
    String code = 'AUTH_ERR',
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(message, code, originalError, stackTrace);

  factory AuthException.invalidCredentials() {
    return AuthException(
      message: 'Correo o contraseña inválidos.',
      code: 'INVALID_CREDENTIALS',
    );
  }

  factory AuthException.userNotFound() {
    return AuthException(
      message: 'El usuario no existe.',
      code: 'USER_NOT_FOUND',
    );
  }

  factory AuthException.accountDisabled() {
    return AuthException(
      message: 'Esta cuenta ha sido desactivada.',
      code: 'ACCOUNT_DISABLED',
    );
  }

  factory AuthException.sessionExpired() {
    return AuthException(
      message: 'Tu sesión ha expirado. Por favor inicia sesión de nuevo.',
      code: 'SESSION_EXPIRED',
    );
  }
}

/// Exception for data processing related errors
class DataException extends AppException {
  DataException({
    String message = 'Error en los datos',
    String code = 'DATA_ERR',
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(message, code, originalError, stackTrace);

  factory DataException.parseError() {
    return DataException(
      message: 'Error al procesar los datos.',
      code: 'PARSE_ERR',
    );
  }

  factory DataException.emptyData() {
    return DataException(
      message: 'No hay datos disponibles.',
      code: 'EMPTY_DATA',
    );
  }
}

/// Exception for validation related errors
class ValidationException extends AppException {
  ValidationException({
    String message = 'Error de validación',
    String code = 'VAL_ERR',
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(message, code, originalError, stackTrace);

  factory ValidationException.emptyEmail() {
    return ValidationException(
      message: 'Por favor ingresa tu correo electrónico.',
      code: 'EMPTY_EMAIL',
    );
  }

  factory ValidationException.invalidEmail() {
    return ValidationException(
      message: 'Ingresa un correo electrónico válido.',
      code: 'INVALID_EMAIL',
    );
  }

  factory ValidationException.emptyPassword() {
    return ValidationException(
      message: 'Por favor ingresa tu contraseña.',
      code: 'EMPTY_PASSWORD',
    );
  }

  factory ValidationException.weakPassword() {
    return ValidationException(
      message: 'La contraseña debe tener al menos 6 caracteres.',
      code: 'WEAK_PASSWORD',
    );
  }

  factory ValidationException.passwordMismatch() {
    return ValidationException(
      message: 'Las contraseñas no coinciden.',
      code: 'PASSWORD_MISMATCH',
    );
  }
}

/// Exception for operation related errors
class OperationException extends AppException {
  OperationException({
    String message = 'Error en la operación',
    String code = 'OPERATION_ERR',
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(message, code, originalError, stackTrace);
}
