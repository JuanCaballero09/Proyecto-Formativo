import 'exceptions.dart';

/// Clase para manejar y convertir excepciones a mensajes amigables
class ErrorHandler {
  /// Obtiene un mensaje amigable basado en la excepción
  static String getErrorMessage(dynamic error) {
    if (error is AppException) {
      return error.message;
    } else if (error is Exception) {
      return _handleException(error);
    } else {
      return 'Ocurrió un error inesperado. Intenta de nuevo.';
    }
  }

  /// Obtiene el código de error
  static String? getErrorCode(dynamic error) {
    if (error is AppException) {
      return error.code;
    }
    return null;
  }

  /// Maneja excepciones genéricas
  static String _handleException(Exception error) {
    final errorString = error.toString();
    
    if (errorString.contains('SocketException')) {
      return 'Error de conexión. Verifica tu internet.';
    } else if (errorString.contains('TimeoutException')) {
      return 'La solicitud tardó demasiado. Intenta de nuevo.';
    } else if (errorString.contains('FormatException')) {
      return 'Error al procesar los datos.';
    } else {
      return 'Ocurrió un error. Intenta de nuevo.';
    }
  }

  /// Determina si el error es crítico
  static bool isCriticalError(dynamic error) {
    if (error is AppException) {
      return error.code?.startsWith('NET_ERR') ?? false;
    }
    return false;
  }

  /// Obtiene un ícono basado en el tipo de error
  static String getErrorIcon(dynamic error) {
    if (error is NetworkException) {
      return '📡';
    } else if (error is AuthException) {
      return '🔐';
    } else if (error is ValidationException) {
      return '⚠️';
    } else if (error is DataException) {
      return '📊';
    } else {
      return '❌';
    }
  }

  /// Crea una excepción apropiada desde un error y un código de estado
  static AppException createException(dynamic error, {int? statusCode}) {
    if (error is AppException) {
      return error;
    }

    if (statusCode != null) {
      if (statusCode == 401 || statusCode == 403) {
        return AuthException.invalidCredentials();
      } else if (statusCode == 404) {
        return AuthException.userNotFound();
      } else if (statusCode >= 500) {
        return NetworkException.serverError();
      }
    }

    final errorString = error.toString().toLowerCase();
    if (errorString.contains('socket')) {
      return NetworkException.noInternet();
    } else if (errorString.contains('timeout')) {
      return NetworkException.timeout();
    }

    return OperationException(message: error.toString());
  }
}
