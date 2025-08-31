import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      // Aquí simulas login exitoso con datos de ejemplo
      final user = User(name: "Usuario Demo", email: event.email);
      emit(Authenticated(user));
    });

    on<LogoutRequested>((event, emit) async {
      emit(Unauthenticated());
    });
  }
}
