import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_state.dart';
import 'perfil_page.dart';

class PerfilWrapper extends StatelessWidget {
  const PerfilWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthInitial) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is Authenticated) {
          return const PerfilPage();
        } else if (state is Unauthenticated) {
          return const PerfilPage();
        } else {
          return const Scaffold(
            body: Center(child: Text("Error de autenticación")),
          );
        }
      },
    );
  }
}
