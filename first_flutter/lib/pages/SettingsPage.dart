import 'package:flutter/material.dart';
import 'package:first_flutter/widgets/language_selector.dart';
import 'package:first_flutter/widgets/theme_selector.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajustes"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPreferenceRow(
              icon: Icons.language,
              label: "Idioma",
              widget: const LanguageSelector(),
            ),

            const SizedBox(height: 15),

            _buildPreferenceRow(
              icon: Icons.brightness_6,
              label: "Tema",
              widget: const ThemeSelector(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreferenceRow({
    required IconData icon,
    required String label,
    required Widget widget,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.grey[800]),
              const SizedBox(width: 12),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
          widget,
        ],
      ),
    );
  }
}
