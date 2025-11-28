import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import '../../service/api_service.dart';
import 'connection_state.dart';

/// Cubit para manejar la verificación de conexión con el backend
class ConnectionCubit extends Cubit<ServerConnectionState> {
  final ApiService apiService;

  ConnectionCubit({required this.apiService}) : super(const ConnectionChecking());

  /// Verifica la conexión con el backend
  Future<void> checkConnection() async {
    if (isClosed) return;
    emit(const ConnectionChecking());

    try {
      debugPrint('🔍 Verificando conexión con el backend...');
      
      final result = await apiService.checkHealth();

      if (isClosed) return;
      
      if (result['success'] == true) {
        debugPrint('✅ Conexión exitosa: ${result['data']}');
        emit(ConnectionSuccess(result['data']));
      } else {
        final statusCode = result['statusCode'] as int;
        final message = result['message'] as String;
        
        debugPrint('❌ Error de conexión: [$statusCode] $message');
        emit(ConnectionError(
          statusCode: statusCode,
          message: message,
        ));
      }
    } catch (e) {
      if (isClosed) return;
      debugPrint('❌ Excepción en checkConnection: $e');
      emit(ConnectionError(
        statusCode: 0,
        message: 'Error inesperado: ${e.toString()}',
      ));
    }
  }

  /// Reintentar conexión
  Future<void> retry() async {
    await checkConnection();
  }
}
