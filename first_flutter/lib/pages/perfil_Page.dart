import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';

class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          // 🔹 Vista del perfil cuando hay sesión
          return Scaffold(
            appBar: AppBar(title: const Text("Mi Perfil")),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 50,
                    child: Icon(Icons.person, size: 60),
                  ),
                  const SizedBox(height: 16),
                  Text(state.user.name,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(state.user.email,
                      style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
          );
        } else {
          // 🔹 Vista cuando NO hay sesión
          return Scaffold(
            appBar: AppBar(title: const Text("Perfil")),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.account_circle,
                      size: 120, color: Colors.blueGrey),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/login");
                    },
                    child: const Text("Iniciar Sesión"),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/register");
                    },
                    child: const Text("Registrarse"),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
