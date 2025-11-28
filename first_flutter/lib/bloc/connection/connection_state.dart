import 'package:equatable/equatable.dart';

/// Estados de conexión con el backend
abstract class ServerConnectionState extends Equatable {
  const ServerConnectionState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial - verificando conexión
class ConnectionChecking extends ServerConnectionState {
  const ConnectionChecking();
}

/// Conexión exitosa
class ConnectionSuccess extends ServerConnectionState {
  final Map<String, dynamic> healthData;

  const ConnectionSuccess(this.healthData);

  @override
  List<Object?> get props => [healthData];
}

/// Error de conexión con código de estado y mensaje
class ConnectionError extends ServerConnectionState {
  final int statusCode;
  final String message;

  const ConnectionError({
    required this.statusCode,
    required this.message,
  });

  @override
  List<Object?> get props => [statusCode, message];

  /// Determina si el error es crítico (sin conexión/timeout)
  bool get isCritical => statusCode == 0 || statusCode == 408;

  /// Determina si es un error de servidor
  bool get isServerError => statusCode >= 500;

  /// Determina si es un error de cliente
  bool get isClientError => statusCode >= 400 && statusCode < 500;

  /// Mensaje amigable según el tipo de error
  String get friendlyMessage {
    if (isCritical) {
      return 'No se puede conectar al servidor. Verifica tu conexión a internet.';
    } else if (isServerError) {
      return 'El servidor está experimentando problemas. Intenta más tarde.';
    } else if (isClientError) {
      return 'Hubo un problema con la solicitud.';
    }
    return message;
  }
}
