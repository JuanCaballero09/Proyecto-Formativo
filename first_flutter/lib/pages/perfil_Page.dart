import 'package:first_flutter/bloc/auth/auth_event.dart';
import 'package:first_flutter/l10n/app_localizations.dart';
import 'package:first_flutter/pages/SettingsPage.dart';
import 'package:first_flutter/pages/privacy_policy_page.dart';
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
        // ==================================
        //          USUARIO AUTENTICADO
        // ==================================
        if (state is Authenticated) {
          return Scaffold(
            backgroundColor: bgColor,
            appBar: AppBar(
              backgroundColor: cardColor,
              elevation: 1,
              title: Text(

                "Mi Perfil",

                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
            body: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // ===========================
                //      PERFIL CENTRADO
                // ===========================
                Container(
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      if (!isDark)
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                    ],
                  ),

                padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      // Avatar centrado
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [kOrange, Color(0xFFFF6E40)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: const CircleAvatar(
                          radius: 48,
                          backgroundColor: Colors.transparent,

                          child: Icon(Icons.person, size: 55, color: Colors.white),

                        ),
                      ),

                      const SizedBox(height: 16),


                      // Nombre
                      Text(
                        state.user.name,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),

                      const SizedBox(height: 6),

                      // Correo
                      Text(
                        state.user.email,
                        style: TextStyle(
                          fontSize: 14,
                          color: subtitleColor,
                        ),
                      ),

                      const SizedBox(height: 6),

                      const Text(
                        "Cuenta Activa ✓",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                 // ===========================
                //         CUENTA
                // ===========================
                Text(
                  "Configuración",
                  style: TextStyle(
                    color: textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),

                ),
                const SizedBox(height: 10),
              _buildOption(
                  icon: Icons.settings,
                  label: "Ajustes",
                  widget: Icon(Icons.chevron_right, color: arrowColor),
                  cardColor: cardColor,
                  textColor: textColor,
                  iconColor: iconColor,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SettingsPage()),
                    );
                  },
                ),

                const SizedBox(height: 20),
              
                // ===========================
                //         CUENTA
                // ===========================
                Text(
                  "Cuenta",
                  style: TextStyle(
                    color: textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
_buildMenuTile(
  context,
  icon: Icons.privacy_tip,
  label: "Política de Privacidad",
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PrivacyPolicyPage()),
    );
  },
  cardColor: cardColor,
  textColor: textColor,
  iconColor: iconColor,
  arrowColor: arrowColor,
),





                const SizedBox(height: 20),


                Divider(color: arrowColor),

                // ===========================
                //      CERRAR SESIÓN
                // ===========================
                Padding(

                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: InkWell(
                    onTap: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Cerrar sesión'),
                          content: const Text(
                              '¿Estás seguro de que deseas cerrar sesión?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Cerrar sesión',
                                  style: TextStyle(color: Colors.red)),

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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
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

                const SizedBox(height: 20),
                Divider(color: arrowColor),
              ],
            ),
          );

        }

        // ==================================
        //        VISTA SIN SESIÓN
        // ==================================
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
                      color:
                          theme.textTheme.bodyMedium?.color?.withOpacity(0.7),

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
                        AppLocalizations.of(context)?.login ??
                            'Iniciar Sesión',
                        style: const TextStyle(
                            fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),


                  const SizedBox(height: 12),

                  SizedBox(
                    width: 220,
                    height: 50,
                    child: OutlinedButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, "/register"),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: theme.textTheme.bodyLarge?.color,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),

                        ),
                      ),

                      child: const Text('Registrarse',
                          style: TextStyle(fontSize: 18)),

                    ),
                  ),

                  const SizedBox(height: 20),

                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/forgot-password");
                    },
                    child: Text(
                      AppLocalizations.of(context)?.forgotPassword ??
                          '¿Olvidaste tu contraseña?',
                      style: const TextStyle(color: Colors.blueAccent),
                    ),
                  ),
                  ],
                ),
              ),
            ),
          );
        }
    );
  }


 // 🔹 MENÚ GENERAL (Mis pedidos, privacidad, etc.)
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

          child: Row(
            children: [
              Icon(icon, color: iconColor, size: 22),
              const SizedBox(width: 16),
              Text(
                label,
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Icon(Icons.chevron_right, color: arrowColor, size: 22),
            ],
          ),
        ),
      ),
    ),
  );
}
}
// 🔹 Opción grande (Ajustes)
Widget _buildOption({
  required IconData icon,
  required String label,
  required Widget widget,
  required Color cardColor,
  required Color textColor,
  required Color iconColor,
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
            color: cardColor,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(icon, color: iconColor, size: 22),
              const SizedBox(width: 16),
              Text(
                label,
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              widget,
            ],
          ),
        ),
      ),
    ),
  );
}
