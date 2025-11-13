import 'package:first_flutter/bloc/auth/auth_event.dart';
import 'package:first_flutter/l10n/app_localizations.dart';
import 'package:first_flutter/service/api_service.dart';
import 'package:first_flutter/widgets/language_selector.dart';
import 'package:first_flutter/widgets/theme_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_state.dart';

const kOrange = Color(0xFFFF9800);

class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // 👈 accedemos al tema actual
    final isDark = theme.brightness == Brightness.dark;

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          return Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(70),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Mi Perfil",
                        style: theme.textTheme.titleLarge?.copyWith(
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
                // 🔸 Encabezado del perfil
                Container(
                  color: theme.cardColor,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
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
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              state.user.email,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 🔸 Información personal
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    AppLocalizations.of(context)?.personalInfo ?? 'Información Personal',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // 🔸 Selector de idioma
                _configRow(
                  icon: Icons.language,
                  text: AppLocalizations.of(context)?.language ?? 'Idioma',
                  trailing: const LanguageSelector(),
                  context: context,
                ),

                // 🔸 Selector de tema
                _configRow(
                  icon: Icons.brightness_6,
                  text: 'Tema',
                  trailing: const ThemeSelector(),
                  context: context,
                ),

                const Divider(),

                // 🔸 Lista de opciones
                _optionTile(
                  icon: Icons.restaurant_menu,
                  text: AppLocalizations.of(context)?.orders ?? 'Pedidos',
                  context: context,
                ),
                _optionTile(
                  icon: Icons.receipt_long,
                  text: 'Datos de facturación',
                  context: context,
                ),
                _optionTile(
                  icon: Icons.location_on,
                  text: AppLocalizations.of(context)?.addresses ?? 'Direcciones',
                  context: context,
                ),
                _optionTile(
                  icon: Icons.edit,
                  text: AppLocalizations.of(context)?.editProfile ?? 'Editar Perfil',
                  context: context,
                ),
                _optionTile(
                  icon: Icons.privacy_tip,
                  text: AppLocalizations.of(context)?.privacyPolicy ?? 'Política de Privacidad',
                  context: context,
                ),
                _optionTile(
                  icon: Icons.help_outline,
                  text: AppLocalizations.of(context)?.helpSupport ?? 'Ayuda y Soporte',
                  context: context,
                ),
                _optionTile(
                  icon: Icons.article,
                  text: AppLocalizations.of(context)?.termsConditions ?? 'Términos y Condiciones',
                  context: context,
                ),

                const Divider(),

                // 🔸 Cerrar sesión
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: Text(
                    AppLocalizations.of(context)?.logout ?? 'Cerrar Sesión',
                    style: const TextStyle(color: Colors.red),
                  ),
                  onTap: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Cerrar sesión'),
                        content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text(
                              'Cerrar sesión',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );

                    if (confirmed == true) {
                      final api = ApiService();
                      await api.logout();
                      if (!context.mounted) return;
                      context.read<AuthBloc>().add(LogoutRequested());
                    }
                  },
                ),

                const SizedBox(height: 8),

                // 🔸 Versión
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Center(
                    child: Text(
                      'v4.3.3',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          // 🔸 Vista sin sesión
          return Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            body: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/loogo.jpg", width: 120, height: 120),
                    const SizedBox(height: 20),
                    Text(
                      "Bienvenido a Bitevia",
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Inicia sesión o regístrate para continuar",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Botón Iniciar Sesión
                    SizedBox(
                      width: 220,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pushNamed(context, "/login"),
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
                        onPressed: () => Navigator.pushNamed(context, "/register"),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: theme.textTheme.bodyLarge?.color,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Registrarse', style: TextStyle(fontSize: 18)),
                      ),
                    ),

                    const SizedBox(height: 20),

                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, "/forgot-password"),
                      child: const Text("¿Olvidaste tu contraseña?"),
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

  /// 🔹 Row para configuraciones (Idioma / Tema)
  Widget _configRow({
    required IconData icon,
    required String text,
    required Widget trailing,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: theme.iconTheme.color),
          const SizedBox(width: 16),
          Text(text, style: theme.textTheme.bodyMedium),
          const Spacer(),
          trailing,
        ],
      ),
    );
  }

  /// 🔹 Opción de menú
  Widget _optionTile({
    required IconData icon,
    required String text,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(icon, color: theme.iconTheme.color?.withOpacity(0.7)),
      title: Text(
        text,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios,
          size: 16, color: theme.iconTheme.color?.withOpacity(0.5)),
      enabled: false,
    );
  }
}
