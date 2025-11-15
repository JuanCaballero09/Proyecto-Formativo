import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final _storage = const FlutterSecureStorage();
  
  AuthBloc() : super(AuthInitial()) {
    on<CheckAuthStatus>((event, emit) async {
      try {
        // Verificar si hay token y datos de usuario guardados
        final token = await _storage.read(key: 'token');
        final userName = await _storage.read(key: 'user_name');
        final userApellido = await _storage.read(key: 'user_apellido');
        final userEmail = await _storage.read(key: 'user_email');
        
        if (token != null && userEmail != null) {
          // Hay sesión activa
          final fullName = '${userName ?? ''} ${userApellido ?? ''}'.trim();
          final user = User(
            name: fullName.isEmpty ? 'Usuario' : fullName,
            email: userEmail,
          );
          emit(Authenticated(user));
        } else {
          // No hay sesión
          emit(Unauthenticated());
        }
      } catch (e) {
        emit(AuthError('Error al verificar sesión', errorCode: 'CHECK_AUTH_ERR'));
      }
    });
    
    on<LoginRequested>((event, emit) async {
      try {
        emit(AuthLoading());
        
        // Validar campos
        if (event.email.isEmpty) {
          emit(AuthError('El correo no puede estar vacío', errorCode: 'EMPTY_EMAIL'));
          return;
        }
        if (event.password.isEmpty) {
          emit(AuthError('La contraseña no puede estar vacía', errorCode: 'EMPTY_PASSWORD'));
          return;
        }
        
        // Validar formato de email
        if (!_isValidEmail(event.email)) {
          emit(AuthError('Ingresa un correo electrónico válido', errorCode: 'INVALID_EMAIL'));
          return;
        }
        
        // Validar longitud de contraseña
        if (event.password.length < 6) {
          emit(AuthError('La contraseña debe tener al menos 6 caracteres', errorCode: 'SHORT_PASSWORD'));
          return;
        }
        
        // Crear usuario con los datos recibidos del login
        final user = User(
          name: event.userName ?? "Usuario",
          email: event.email,
        );
        emit(Authenticated(user));
      } catch (e) {
        emit(AuthError('Error durante el login: ${e.toString()}', errorCode: 'LOGIN_ERR'));
      }
    });

    on<LogoutRequested>((event, emit) async {
      try {
        await _storage.deleteAll();
        emit(Unauthenticated());
      } catch (e) {
        emit(AuthError('Error al cerrar sesión', errorCode: 'LOGOUT_ERR'));
      }
    });

    on<ClearError>((event, emit) async {
      emit(Unauthenticated());
    });
  }

  /// Validar formato de email
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    );
    return emailRegex.hasMatch(email);
  }
}
