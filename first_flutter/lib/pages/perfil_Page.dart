import 'package:first_flutter/bloc/auth/auth_event.dart';
import 'package:first_flutter/l10n/app_localizations.dart';
import 'package:first_flutter/pages/SettingsPage.dart';
import 'package:first_flutter/pages/privacy_policy_page.dart';
import 'package:first_flutter/service/api_service.dart';
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
                AppLocalizations.of(context)!.myProfileLabel,
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

                      Text(
                        AppLocalizations.of(context)!.activeAccount,
                        style: const TextStyle(
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
                  AppLocalizations.of(context)!.configurationLabel,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),

                ),
                const SizedBox(height: 10),
              _buildOption(
                  icon: Icons.settings,
                  label: AppLocalizations.of(context)!.adjustmentsLabel,
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
                  AppLocalizations.of(context)!.accountLabel,
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
  label: AppLocalizations.of(context)!.privacyPolicyMenuLabel,
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

_buildMenuTile(
  context,
  icon: Icons.info_outline,
  label: AppLocalizations.of(context)!.aboutLabel,
  onTap: () {
    showAboutDialog(
      context: context,
      applicationName: "Bitevia",
      applicationVersion: "4.3.3",
      applicationIcon: Image.asset("assets/logobitevia.png", width: 60, height: 60),
      children: [
        Text(AppLocalizations.of(context)!.systemDescriptionLabel),
        const SizedBox(height: 10),
        Text(AppLocalizations.of(context)!.allRightsReserved),
      ],
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
                      final theme = Theme.of(context);
                      final isDark = theme.brightness == Brightness.dark;
                      
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (context) => Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Ícono
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.logout_rounded,
                                    color: Colors.red,
                                    size: 32,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                
                                // Título
                                Text(
                                  AppLocalizations.of(context)!.logoutDialogTitle,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.white : Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                
                                // Mensaje
                                Text(
                                  AppLocalizations.of(context)!.logoutDialogMessage,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                
                                // Botones
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: () => Navigator.pop(context, false),
                                        style: OutlinedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(vertical: 14),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          side: BorderSide(
                                            color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                                          ),
                                        ),
                                        child: Text(
                                          AppLocalizations.of(context)!.cancelLabel,
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: isDark ? Colors.grey[300] : Colors.grey[700],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () => Navigator.pop(context, true),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(vertical: 14),
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                        child: Text(
                                          AppLocalizations.of(context)!.logoutLabel,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
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
                        children: [
                          const Icon(Icons.logout, color: Colors.red, size: 22),
                          const SizedBox(width: 16),
                          Text(
                            AppLocalizations.of(context)!.logoutLabel,
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
          backgroundColor: bgColor,
          appBar: AppBar(
            backgroundColor: cardColor,
            elevation: 1,
            title: Text(
              AppLocalizations.of(context)!.myProfileLabel,
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
              //      PERFIL INVITADO
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
                    // Avatar invitado
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.withOpacity(0.3),
                      ),
                      child: const CircleAvatar(
                        radius: 48,
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.person_outline, size: 55, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Título
                    Text(
                      AppLocalizations.of(context)!.guestLabel,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      AppLocalizations.of(context)!.guestMessage,
                      style: TextStyle(
                        fontSize: 14,
                        color: subtitleColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Botones de Login y Register
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: SizedBox(
                  width: double.infinity,
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
                      style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pushNamed(context, "/register"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color.fromRGBO(237, 88, 33, 1),
                      side: const BorderSide(color: Color.fromRGBO(237, 88, 33, 1)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(AppLocalizations.of(context)!.registerLabel, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ===========================
              //     CONFIGURACIÓN
              // ===========================
              Text(
                AppLocalizations.of(context)!.configurationLabel,
                style: TextStyle(
                  color: textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              _buildOption(
                icon: Icons.settings,
                label: AppLocalizations.of(context)!.adjustmentsLabel,
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
                AppLocalizations.of(context)!.informationLabel,
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
                label: AppLocalizations.of(context)!.privacyPolicyMenuLabel,
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
              _buildMenuTile(
                context,
                icon: Icons.info_outline,
                label: AppLocalizations.of(context)!.aboutLabel,
                onTap: () {
                  showAboutDialog(
                    context: context,
                    applicationName: "Bitevia",
                    applicationVersion: "4.3.3",
                    applicationIcon: Image.asset("assets/logobitevia.png", width: 60, height: 60),
                    children: [
                      Text(AppLocalizations.of(context)!.systemDescriptionLabel),
                      const SizedBox(height: 10),
                      const Text("© 2025 Bitevia. Todos los derechos reservados."),
                    ],
                  );
                },
                cardColor: cardColor,
                textColor: textColor,
                iconColor: iconColor,
                arrowColor: arrowColor,
              ),

              const SizedBox(height: 20),
            ],
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
