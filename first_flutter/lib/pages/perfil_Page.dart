import 'package:first_flutter/bloc/auth/auth_event.dart';
import 'package:first_flutter/l10n/app_localizations.dart';
import 'package:first_flutter/service/api_service.dart';
import 'package:first_flutter/widgets/language_selector.dart';
import 'package:first_flutter/widgets/theme_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_state.dart';

// 🔹 Colores globales
const kOrange = Color(0xFFFF9800);
const kDarkGray = Color(0xFF424242);
const kLightGray = Color(0xFFFAFAFA);

class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          // 🔹 Vista del perfil cuando hay sesión
          return Scaffold(
            backgroundColor: kLightGray,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 1,
              title: Text(
                AppLocalizations.of(context)?.profile ?? "Mi Perfil",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: kDarkGray,
                ),
              ),
              centerTitle: false,
            ),
            body: ListView(
              children: [
                // 🔹 Encabezado del perfil mejorado
                Container(
                  margin: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Row(
                    children: [
                      // Avatar con fondo gradiente
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [kOrange, Color(0xFFFF6E40)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: const CircleAvatar(
                          radius: 32,
                          backgroundColor: Colors.transparent,
                          child: Icon(Icons.person, color: Colors.white, size: 42),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Información del usuario
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.user.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: kDarkGray,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              state.user.email,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black54,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Cuenta Activa ✓',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.green,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Botón Editar Perfil
                      IconButton(
                        onPressed: () {
                          // TODO: Navegar a editar perfil
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Editar perfil - Próximamente'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        icon: const Icon(Icons.edit, color: kOrange),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // 🔹 Sección Preferencias
                _buildSectionTitle(context, 'Preferencias'),

                // Selector de idioma
                _buildPreferenceRow(
                  icon: Icons.language,
                  label: AppLocalizations.of(context)?.language ?? 'Idioma',
                  widget: const LanguageSelector(),
                ),

                // Selector de tema
                _buildPreferenceRow(
                  icon: Icons.brightness_6,
                  label: 'Tema',
                  widget: const ThemeSelector(),
                ),

                const SizedBox(height: 12),

                // 🔹 Sección Cuenta
                _buildSectionTitle(context, 'Cuenta'),

                // Pedidos
                _buildMenuTile(
                  context,
                  icon: Icons.receipt_long,
                  label: AppLocalizations.of(context)?.orders ?? 'Mis Pedidos',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Mis Pedidos - Próximamente'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),

                // Direcciones
                _buildMenuTile(
                  context,
                  icon: Icons.location_on,
                  label: AppLocalizations.of(context)?.addresses ?? 'Mis Direcciones',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Mis Direcciones - Próximamente'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),

                // Datos de facturación
                _buildMenuTile(
                  context,
                  icon: Icons.receipt,
                  label: 'Datos de Facturación',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Datos de Facturación - Próximamente'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 12),

                // 🔹 Sección Legal e Información
                _buildSectionTitle(context, 'Información'),

                // Ayuda y Soporte
                _buildMenuTile(
                  context,
                  icon: Icons.help_outline,
                  label: AppLocalizations.of(context)?.helpSupport ?? 'Ayuda y Soporte',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Ayuda y Soporte - Próximamente'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),

                // Política de Privacidad
                _buildMenuTile(
                  context,
                  icon: Icons.privacy_tip,
                  label: AppLocalizations.of(context)?.privacyPolicy ?? 'Política de Privacidad',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Política de Privacidad - Próximamente'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),

                // Términos y Condiciones
                _buildMenuTile(
                  context,
                  icon: Icons.article,
                  label: AppLocalizations.of(context)?.termsConditions ?? 'Términos y Condiciones',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Términos y Condiciones - Próximamente'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 16),
                const Divider(height: 1),

                // 🔹 Cerrar sesión
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
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
                                child: const Text('Cerrar sesión', style: TextStyle(color: Colors.red)),
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
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        child: Row(
                          children: const [
                            Icon(Icons.logout, color: Colors.red, size: 22),
                            SizedBox(width: 16),
                            Text(
                              'Cerrar Sesión',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Versión de la app
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Center(
                    child: Text(
                      'v4.3.3',
                      style: TextStyle(
                        color: Colors.black38,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
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
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  // 🔹 Métodos auxiliares para construir widgets reutilizables

  /// Construye un título de sección
  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.black54,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  /// Construye una fila de preferencia
  Widget _buildPreferenceRow({
    required IconData icon,
    required String label,
    required Widget widget,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(icon, color: kOrange, size: 20),
              const SizedBox(width: 16),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  color: kDarkGray,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              widget,
            ],
          ),
        ),
      ),
    );
  }

  /// Construye un elemento de menú con ícono y navegación
  Widget _buildMenuTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(icon, color: kOrange, size: 20),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      label,
                      style: const TextStyle(
                        fontSize: 15,
                        color: kDarkGray,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.black26,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
