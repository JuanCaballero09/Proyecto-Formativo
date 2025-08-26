import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: AppBar(
          automaticallyImplyLeading: false, // 👈 Esto quita la flecha
          backgroundColor: Colors.white,
          elevation: 0,
          flexibleSpace: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 6.0, right: 16.0, top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 100,
                    height: 70,
                    child: FittedBox(
                      child: Image.asset(
                        'assets/logoredondo.png',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
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
                        'HOLA, Andrw!',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'sdgy5j5c8t@privaterelay.appleid.com',
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              localizations.account,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54),
            ),
          ),
          const SizedBox(height: 8),

          // Lista de opciones (solo visual)
          _buildDisabledTile(Icons.restaurant_menu, 'Pedidos'),
          _buildDisabledTile(Icons.receipt_long, 'Datos de facturación'),
          _buildDisabledTile(Icons.location_on, 'Dirección de entrega'),
          _buildDisabledTile(Icons.edit, 'Editar perfil'),
          _buildDisabledTile(Icons.privacy_tip, 'Configuración de privacidad'),
          _buildDisabledTile(Icons.help_outline, 'Ayuda'),
          _buildDisabledTile(Icons.article, 'Términos legales'),
         

          const SizedBox(height: 10),
          const Divider(),

          // Cerrar sesión
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.black),
            title: Text(localizations.logout),
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