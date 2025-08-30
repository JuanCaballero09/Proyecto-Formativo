import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../widgets/language_selector.dart';

class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            body: ListView(
        children: [
          // Encabezado del perfil
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: const [
                CircleAvatar(
                  backgroundColor: Colors.black,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'HOLA, tuntung sahur',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'tralalerotralala.com',
                        style: TextStyle(fontSize: 14, color: Color.fromARGB(255, 206, 194, 187)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              AppLocalizations.of(context)!.personalInfo,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54),
            ),
          ),
          const SizedBox(height: 8),

          // Selector de idioma
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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

          // Lista de opciones (solo visual)
          _buildDisabledTile(Icons.restaurant_menu, AppLocalizations.of(context)!.orders),
          _buildDisabledTile(Icons.receipt_long, 'Datos de facturación'),
          _buildDisabledTile(Icons.location_on, AppLocalizations.of(context)!.addresses),
          _buildDisabledTile(Icons.edit, AppLocalizations.of(context)!.editProfile),
          _buildDisabledTile(Icons.privacy_tip, AppLocalizations.of(context)!.privacyPolicy),
          _buildDisabledTile(Icons.help_outline, AppLocalizations.of(context)!.helpSupport),
          _buildDisabledTile(Icons.article, AppLocalizations.of(context)!.termsConditions),
         

          const SizedBox(height: 10),
          const Divider(),

          // Cerrar sesión
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.black),
            title: Text(AppLocalizations.of(context)!.logout),
            onTap: () {
              // Acción funcional
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/welcome',
                (route) => false,
              );
            },
          ),
        ],
      ),
      // Barra de navegación inferior (opcional si ya la tienes)
    
    );
  }

  // Ítems inactivos (solo visual)
  Widget _buildDisabledTile(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black38),
      onTap: null, // No hace nada
    );
  }
}