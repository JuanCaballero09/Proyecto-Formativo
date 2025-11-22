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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // 🎨 PALETA PERSONALIZADA SOLO PARA ESTA PÁGINA
    final bgColor = isDark ? const Color(0xFF121212) : kLightGray;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : kDarkGray;
    final subtitleColor = isDark ? Colors.white70 : Colors.black54;
    final iconColor = isDark ? Colors.white70 : kOrange;
    final arrowColor = isDark ? Colors.white38 : Colors.black26;

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          return Scaffold(
            backgroundColor: bgColor,
            appBar: AppBar(
              backgroundColor: cardColor,
              elevation: 1,
              title: Text(
                AppLocalizations.of(context)!.profile,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              centerTitle: false,
            ),
            body: ListView(
              children: [
                // 🔹 Encabezado del perfil
                Container(
                  margin: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      if (!isDark)
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
                      // Avatar con gradiente
                      Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
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

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.user.name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              state.user.email,
                              style: TextStyle(
                                fontSize: 13,
                                color: subtitleColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              AppLocalizations.of(context)!.activeAccount,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.green,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      IconButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(AppLocalizations.of(context)!.comingSoon),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        icon: Icon(Icons.edit, color: iconColor),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // 🔹 Sección Preferencias
                _buildSectionTitle(context, AppLocalizations.of(context)!.settings),

                _buildPreferenceRow(
                  icon: Icons.language,
                  label: AppLocalizations.of(context)!.language,
                  widget: const LanguageSelector(),
                  cardColor: cardColor,
                  textColor: textColor,
                  iconColor: iconColor,
                ),

                _buildPreferenceRow(
                  icon: Icons.brightness_6,
                  label: AppLocalizations.of(context)!.theme,
                  widget: const ThemeSelector(),
                  cardColor: cardColor,
                  textColor: textColor,
                  iconColor: iconColor,
                ),

                const SizedBox(height: 12),

                // 🔹 Sección Cuenta
                _buildSectionTitle(context, AppLocalizations.of(context)!.accountSettings),

                _buildMenuTile(
                  context,
                  icon: Icons.receipt_long,
                  label: "Mis Pedidos",
                  onTap: () {},
                  cardColor: cardColor,
                  textColor: textColor,
                  iconColor: iconColor,
                  arrowColor: arrowColor,
                ),

                _buildMenuTile(
                  context,
                  icon: Icons.location_on,
                  label: "Mis Direcciones",
                  onTap: () {},
                  cardColor: cardColor,
                  textColor: textColor,
                  iconColor: iconColor,
                  arrowColor: arrowColor,
                ),

                _buildMenuTile(
                  context,
                  icon: Icons.receipt,
                  label: "Datos de Facturación",
                  onTap: () {},
                  cardColor: cardColor,
                  textColor: textColor,
                  iconColor: iconColor,
                  arrowColor: arrowColor,
                ),

                const SizedBox(height: 12),

                // 🔹 Sección Legal e Información
                _buildSectionTitle(context, AppLocalizations.of(context)!.aboutUs),

                _buildMenuTile(
                  context,
                  icon: Icons.help_outline,
                  label: "Ayuda y Soporte",
                  onTap: () {},
                  cardColor: cardColor,
                  textColor: textColor,
                  iconColor: iconColor,
                  arrowColor: arrowColor,
                ),

                _buildMenuTile(
                  context,
                  icon: Icons.privacy_tip,
                  label: "Política de Privacidad",
                  onTap: () {},
                  cardColor: cardColor,
                  textColor: textColor,
                  iconColor: iconColor,
                  arrowColor: arrowColor,
                ),

                _buildMenuTile(
                  context,
                  icon: Icons.article,
                  label: AppLocalizations.of(context)!.termsConditions,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(AppLocalizations.of(context)?.comingSoon ?? 'Coming soon'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  label: "Términos y Condiciones",
                  onTap: () {},
                  cardColor: cardColor,
                  textColor: textColor,
                  iconColor: iconColor,
                  arrowColor: arrowColor,
                ),

                const SizedBox(height: 16),
                Divider(color: arrowColor, height: 1),

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
                            title: Text(AppLocalizations.of(context)!.logout),
                            content: Text(AppLocalizations.of(context)?.logoutConfirmation ?? 'Are you sure you want to logout?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: Text(AppLocalizations.of(context)!.cancel),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: Text(AppLocalizations.of(context)!.logout, style: const TextStyle(color: Colors.red)),
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
                          children: [
                            const Icon(Icons.logout, color: Colors.red, size: 22),
                            const SizedBox(width: 16),
                            Text(
                              AppLocalizations.of(context)!.logout,
                              style: const TextStyle(
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

                // Versión
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Center(
                    child: Text(
                      'v4.3.3',
                      style: TextStyle(
                        color: subtitleColor,
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
                      AppLocalizations.of(context)?.welcomeTitle ?? 'Bienvenido a Bitevia',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      AppLocalizations.of(context)?.guestAuthPrompt ?? 'Inicia sesión o regístrate para continuar',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
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
                        child: Text(
                          AppLocalizations.of(context)?.login ?? 'Iniciar Sesión',
                          style: const TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                      child: const Text(
                        'Iniciar Sesión',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

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
                        child: Text(AppLocalizations.of(context)?.register ?? 'Registrarse', style: const TextStyle(fontSize: 18)),
                      ),
                      child: const Text('Registrarse', style: TextStyle(fontSize: 18)),
                    ),
                  ),

                  const SizedBox(height: 20),

                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/forgot-password");
                      },
                      child: Text(
                        AppLocalizations.of(context)?.forgotPassword ?? '¿Olvidaste tu contraseña?',
                        style: const TextStyle(color: Colors.blueAccent),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // 🔹 Título de sección
  Widget _buildSectionTitle(BuildContext context, String title, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: textColor.withOpacity(0.7),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  // 🔹 Preferencias
  Widget _buildPreferenceRow({
    required IconData icon,
    required String label,
    required Widget widget,
    required Color cardColor,
    required Color textColor,
    required Color iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 16),
              Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  color: textColor,
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

  // 🔹 Elemento del menú
  Widget _buildMenuTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color cardColor,
    required Color textColor,
    required Color iconColor,
    required Color arrowColor,
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
              color: cardColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(icon, color: iconColor, size: 20),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 15,
                        color: textColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: arrowColor,
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

