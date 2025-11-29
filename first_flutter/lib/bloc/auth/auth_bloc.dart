import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../service/api_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final _storage = const FlutterSecureStorage();
  final ApiService _apiService;
  
  AuthBloc({ApiService? apiService}) 
      : _apiService = apiService ?? ApiService(),
        super(AuthInitial()) {
    
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
        emit(AuthError('Error checking session', errorCode: 'CHECK_AUTH_ERR'));
      }
    });
    
    on<LoginRequested>((event, emit) async {
      try {
        emit(AuthLoading());
        
        // Validar campos
        if (event.email.isEmpty) {
          emit(AuthError('El email no puede estar vacío', errorCode: 'EMPTY_EMAIL'));
          return;
        }
        if (event.password.isEmpty) {
          emit(AuthError('La contraseña no puede estar vacía', errorCode: 'EMPTY_PASSWORD'));
          return;
        }
        
        // Validar formato de email
        if (!_isValidEmail(event.email)) {
          emit(AuthError('Ingresa un email válido', errorCode: 'INVALID_EMAIL'));
          return;
        }
        
        // Validar longitud de contraseña
        if (event.password.length < 6) {
          emit(AuthError('La contraseña debe tener al menos 6 caracteres', errorCode: 'SHORT_PASSWORD'));
          return;
        }
        
        // Llamar al API
        final userData = await _apiService.login(event.email, event.password);
        
        if (userData != null) {
          final fullName = '${userData['nombre'] ?? ''} ${userData['apellido'] ?? ''}'.trim();
          final user = User(
            name: fullName.isEmpty ? "Usuario" : fullName,
            email: event.email,
          );
          emit(Authenticated(user));
        } else {
          emit(AuthError('Credenciales incorrectas', errorCode: 'INVALID_CREDENTIALS'));
        }
      } catch (e) {
        emit(AuthError('Error al iniciar sesión: ${e.toString()}', errorCode: 'LOGIN_ERR'));
      }
    });

    on<RegisterRequested>((event, emit) async {
      try {
        emit(AuthLoading());
        
        // Validar campos
        if (event.nombre.isEmpty || event.apellido.isEmpty || 
            event.email.isEmpty || event.telefono.isEmpty) {
          emit(AuthError('Todos los campos son requeridos', errorCode: 'EMPTY_FIELDS'));
          return;
        }
        
        if (!_isValidEmail(event.email)) {
          emit(AuthError('Ingresa un email válido', errorCode: 'INVALID_EMAIL'));
          return;
        }
        
        if (event.password.length < 6) {
          emit(AuthError('La contraseña debe tener al menos 6 caracteres', errorCode: 'SHORT_PASSWORD'));
          return;
        }
        
        if (event.password != event.passwordConfirmation) {
          emit(AuthError('Las contraseñas no coinciden', errorCode: 'PASSWORD_MISMATCH'));
          return;
        }
        
        // Llamar al API
        final result = await _apiService.register(
          nombre: event.nombre,
          apellido: event.apellido,
          email: event.email,
          telefono: event.telefono,
          password: event.password,
          passwordConfirmation: event.passwordConfirmation,
        );
        
        if (result['success'] == true) {
          emit(RegistrationSuccess(result['message']));
        } else {
          emit(AuthError(result['message'], errorCode: 'REGISTRATION_ERR'));
        }
      } catch (e) {
        emit(AuthError('Error al registrar: ${e.toString()}', errorCode: 'REGISTRATION_ERR'));
      }
    });

    on<ForgotPasswordRequested>((event, emit) async {
      try {
        emit(AuthLoading());
        
        if (event.email.isEmpty) {
          emit(AuthError('El email no puede estar vacío', errorCode: 'EMPTY_EMAIL'));
          return;
        }
        
        if (!_isValidEmail(event.email)) {
          emit(AuthError('Ingresa un email válido', errorCode: 'INVALID_EMAIL'));
          return;
        }
        
        final result = await _apiService.forgotPassword(event.email);
        
        if (result['success'] == true) {
          emit(PasswordResetEmailSent(result['message']));
        } else {
          emit(AuthError(result['message'], errorCode: 'FORGOT_PASSWORD_ERR'));
        }
      } catch (e) {
        emit(AuthError('Error al enviar correo: ${e.toString()}', errorCode: 'FORGOT_PASSWORD_ERR'));
      }
    });

    on<ResendConfirmationRequested>((event, emit) async {
      try {
        emit(AuthLoading());
        
        if (event.email.isEmpty) {
          emit(AuthError('El email no puede estar vacío', errorCode: 'EMPTY_EMAIL'));
          return;
        }
        
        if (!_isValidEmail(event.email)) {
          emit(AuthError('Ingresa un email válido', errorCode: 'INVALID_EMAIL'));
          return;
        }
        
        final result = await _apiService.resendConfirmation(event.email);
        
        if (result['success'] == true) {
          emit(ConfirmationEmailSent(result['message']));
        } else {
          emit(AuthError(result['message'], errorCode: 'RESEND_CONFIRMATION_ERR'));
        }
      } catch (e) {
        emit(AuthError('Error al reenviar correo: ${e.toString()}', errorCode: 'RESEND_CONFIRMATION_ERR'));
      }
    });

    on<LogoutRequested>((event, emit) async {
      try {
        await _apiService.logout();
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
