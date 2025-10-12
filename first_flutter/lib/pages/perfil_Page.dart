import 'package:first_flutter/bloc/auth_event.dart';
import 'package:first_flutter/l10n/app_localizations.dart';
import 'package:first_flutter/service/ApiService.dart';
import 'package:first_flutter/widgets/language_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';

// 🔹 Color naranja global
const kOrange = Color(0xFFFF9800);

class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          // 🔹 Vista del perfil cuando hay sesión
          return Scaffold(
            backgroundColor: Colors.grey[100],
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(70),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Mi Perfil",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            body: ListView(
              children: [
                // Encabezado dinámico del perfil
                Container(
                  color: const Color.fromARGB(255, 252, 252, 252),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.black,
                        child: Icon(Icons.person, color: Colors.white, size: 40),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.user.name,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              state.user.email,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Texto Personal Info
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    AppLocalizations.of(context)!.personalInfo,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Selector de idioma
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.language, color: Colors.black),
                      const SizedBox(width: 16),
                      Text(
                        AppLocalizations.of(context)!.language,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Spacer(),
                      const LanguageSelector(),
                    ],
                  ),
                ),

                // Lista de opciones
                _buildDisabledTile(
                    Icons.restaurant_menu, AppLocalizations.of(context)!.orders),
                _buildDisabledTile(Icons.receipt_long, 'Datos de facturación'),
                _buildDisabledTile(Icons.location_on,
                    AppLocalizations.of(context)!.addresses),
                _buildDisabledTile(
                    Icons.edit, AppLocalizations.of(context)!.editProfile),
                _buildDisabledTile(Icons.privacy_tip,
                    AppLocalizations.of(context)!.privacyPolicy),
                _buildDisabledTile(Icons.help_outline,
                    AppLocalizations.of(context)!.helpSupport),
                _buildDisabledTile(Icons.article,
                    AppLocalizations.of(context)!.termsConditions),

                const SizedBox(height: 10),
                const Divider(),

                // Cerrar sesión
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: Text(
                    AppLocalizations.of(context)!.logout,
                    style: const TextStyle(color: Colors.red),
                  ),
                  onTap: () async {
                    final api = ApiService();
                    final success = await api.logout();
                    if (success) {
                      // ignore: use_build_context_synchronously
                      context.read<AuthBloc>().add(LogoutRequested());
                      Navigator.pushNamedAndRemoveUntil(
                        // ignore: use_build_context_synchronously
                        context,
                        '/welcome',
                        (route) => false,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Error al cerrar sesión")),
                      );
                    }
                  },
                ),
              ],
            ),
          );
        } else {
          // 🔹 Vista cuando NO hay sesión
          return Scaffold(
            body: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 🔹 Logo arriba
                    Image.asset(
                      "assets/loogo.jpg",
                      width: 120,
                      height: 120,
                    ),
                    const SizedBox(height: 20),

                    // Texto de bienvenida
                    const Text(
                      "Bienvenido a Bitevia",
                      style:
                          TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),

                    // Subtítulo
                    const Text(
                      "Inicia sesión o regístrate para continuar",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    const SizedBox(height: 30),

                    // Botón Iniciar Sesión
                    SizedBox(
                      width: 220,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "/login");
                        },
                        style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromRGBO(237, 88, 33, 1), 
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Iniciar Sesión',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Botón Registrarse
                    SizedBox(
                      width: 220,
                      height: 50,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "/register");
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Registrarse',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Link ¿Olvidaste tu contraseña?
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/forgot-password");
                      },
                      child: const Text(
                        "¿Olvidaste tu contraseña?",
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Separador con línea
                    Row(
                      children: const [
                        Expanded(child: Divider(thickness: 1)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text("O continúa con"),
                        ),
                        Expanded(child: Divider(thickness: 1)),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Botones sociales
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.g_mobiledata,
                              size: 40, color: Colors.black),
                          onPressed: () {
                            // TODO: Login con Google
                          },
                        ),
                        const SizedBox(width: 20),
                        IconButton(
                          icon: const Icon(Icons.facebook,
                              size: 40, color: Colors.blue),
                          onPressed: () {
                            // TODO: Login con Facebook
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  // ✅ Helper para los ítems inactivos
  Widget _buildDisabledTile(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.black38,
      ),
      onTap: null,
    );
  }
}
