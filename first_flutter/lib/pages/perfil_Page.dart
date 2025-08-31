import 'package:first_flutter/bloc/auth_event.dart';
import 'package:first_flutter/l10n/app_localizations.dart';
import 'package:first_flutter/pages/register_page.dart';
import 'package:first_flutter/widgets/language_selector.dart';
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
            backgroundColor: Colors.grey[100], // 👉 color de fondo
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(70),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    
                  ),
                ),
              ),
            ),
            body: ListView(
              children: [
                // Encabezado dinámico del perfil
                Container(
                  color: const Color.fromARGB(255, 252, 252, 252), // 👉 encabezado con color suave
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 20),
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
                              state.user.name, // dinámico del usuario
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              state.user.email, // dinámico del usuario
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
                _buildDisabledTile(Icons.restaurant_menu,
                    AppLocalizations.of(context)!.orders),
                _buildDisabledTile(Icons.receipt_long, 'Datos de facturación'),
                _buildDisabledTile(Icons.location_on,
                    AppLocalizations.of(context)!.addresses),
                _buildDisabledTile(Icons.edit,
                    AppLocalizations.of(context)!.editProfile),
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
                  onTap: () {
                    context.read<AuthBloc>().add(LogoutRequested());
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/welcome',
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
          );
        } else {
        // 🔹 Vista cuando NO hay sesión
return Scaffold(
  body: Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.account_circle, size: 120, color: Colors.blueGrey),
        const SizedBox(height: 24),

        // Botón Iniciar Sesión
        SizedBox(
          width: 220,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, "/login");
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: kOrange,
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
      ],
    ),
  ),
);

        }
      },
    );
  }

  // Widget helper para los ítems inactivos
  Widget _buildDisabledTile(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title),
      trailing:
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black38),
      onTap: null,
    );
  }
}
