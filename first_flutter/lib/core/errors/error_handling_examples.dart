import 'exceptions.dart';
import 'error_handler.dart';
import 'package:flutter/foundation.dart';

/// Ejemplos de uso del nuevo sistema de manejo de errores

class ErrorHandlingExamples {
  
  /// Ejemplo 1: Usar ErrorHandler para obtener mensaje amigable
  static void example1_GetErrorMessage() {
    try {
      // Algún código que puede fallar
      throw AuthException.invalidCredentials();
    } catch (error) {
      final message = ErrorHandler.getErrorMessage(error);
      debugPrint(message); // Output: "Correo o contraseña inválidos."
      
      final code = ErrorHandler.getErrorCode(error);
      debugPrint(code); // Output: "INVALID_CREDENTIALS"
    }
  }

  /// Ejemplo 2: Crear excepciones específicas
  static void example2_CreateSpecificExceptions() {
    // Network exceptions
    final noInternet = NetworkException.noInternet();
    debugPrint(noInternet.message); // "No hay conexión a internet."
    
    final timeout = NetworkException.timeout();
    debugPrint(timeout.message); // "La solicitud tardó demasiado. Intenta de nuevo."
    
    // Auth exceptions
    final invalidCreds = AuthException.invalidCredentials();
    debugPrint(invalidCreds.message); // "Correo o contraseña inválidos."
    
    final sessionExpired = AuthException.sessionExpired();
    debugPrint(sessionExpired.message); // "Tu sesión ha expirado..."
    
    // Validation exceptions
    final emptyEmail = ValidationException.emptyEmail();
    debugPrint(emptyEmail.message); // "Por favor ingresa tu correo electrónico."
    
    final weakPassword = ValidationException.weakPassword();
    debugPrint(weakPassword.message); // "La contraseña debe tener al menos 6 caracteres."
  }

  /// Ejemplo 6: Usar ErrorHandler para determinar criticidad
  static void example6_DetermineCriticalError() {
    try {
      throw NetworkException.noInternet();
    } catch (error) {
      if (ErrorHandler.isCriticalError(error)) {
        debugPrint('Error crítico - mostrar dialog importante');
      } else {
        debugPrint('Error regular - mostrar snackbar');
      }
    }
  }

  /// Ejemplo 7: Manejo de errores HTTP en login
  static Future<void> example7_LoginErrorHandling(String email, String password) async {
    try {
      // Validar campos
      if (email.isEmpty) {
        throw ValidationException.emptyEmail();
      }
      if (password.isEmpty) {
        throw ValidationException.emptyPassword();
      }
      if (password.length < 6) {
        throw ValidationException.weakPassword();
      }
      
      // Simular llamada API
      // final response = await apiService.login(email, password);
      
      // Si la respuesta falla
      throw OperationException(message: 'Error desconocido', code: 'UNKNOWN_ERR');
      
    } on ValidationException catch (e) {
      debugPrint('Validación fallida: ${e.message}');
      // Mostrar en formulario
    } on AuthException catch (e) {
      debugPrint('Autenticación fallida: ${e.message}');
      // Mostrar dialog o snackbar
    } on NetworkException catch (e) {
      debugPrint('Error de red: ${e.message}');
      // Mostrar opción de reintentar
    } on AppException catch (e) {
      debugPrint('Error: ${e.message}');
    }
  }

  /// Ejemplo 8: Crear excepción desde error HTTP
  static void example8_CreateExceptionFromHttp(int statusCode) {
    final exception = ErrorHandler.createException(
      Exception('HTTP Error'),
      statusCode: statusCode,
    );
    
    switch (statusCode) {
      case 401:
      case 403:
        debugPrint(exception.message); // "Correo o contraseña inválidos."
        break;
      case 404:
        debugPrint(exception.message); // "El usuario no existe."
        break;
      case 500:
        debugPrint(exception.message); // "Error del servidor..."
        break;
    }
  }

  /// Ejemplo 9: Encadenamiento de errores
  static void example9_ErrorChaining() {
    try {
      throw NetworkException(
        message: 'Conexión perdida',
        code: 'NETWORK_ERR',
        originalError: Exception('Socket error'),
      );
    } catch (error) {
      if (error is AppException && error.originalError != null) {
        debugPrint('Error original: ${error.originalError}');
      }
      
      // Mostrar al usuario
      debugPrint('Error: ${ErrorHandler.getErrorMessage(error)}');
    }
  }
}
