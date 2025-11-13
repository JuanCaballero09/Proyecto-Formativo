import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final _storage = const FlutterSecureStorage();
  
  AuthBloc() : super(AuthInitial()) {
    on<CheckAuthStatus>((event, emit) async {
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
    });
    
    on<LoginRequested>((event, emit) async {
      // Crear usuario con los datos recibidos del login
      final user = User(
        name: event.userName ?? "Usuario",
        email: event.email,
      );
      emit(Authenticated(user));
    });

    on<LogoutRequested>((event, emit) async {
      emit(Unauthenticated());
    });
  }
}
