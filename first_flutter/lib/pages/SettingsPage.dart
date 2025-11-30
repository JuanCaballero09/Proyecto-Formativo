import 'package:flutter/material.dart';
import 'package:first_flutter/widgets/language_selector.dart';
import 'package:first_flutter/widgets/theme_selector.dart';
import 'package:first_flutter/l10n/app_localizations.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settingsLabel),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPreferenceRow(
              context: context,
              icon: Icons.language,
              label: AppLocalizations.of(context)!.language,
              widget: const LanguageSelector(),
            ),
            const SizedBox(height: 15),
            _buildPreferenceRow(
              context: context,
              icon: Icons.brightness_6,
              label: AppLocalizations.of(context)!.theme,
              widget: const ThemeSelector(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreferenceRow({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Widget widget,
  }) {
    final theme = Theme.of(context);
    final Color tileBg = theme.colorScheme.surface;
    final Color iconColor = theme.iconTheme.color ??
        (theme.brightness == Brightness.dark ? Colors.white70 : Colors.black87);
    final TextStyle labelStyle = theme.textTheme.bodyLarge
            ?.copyWith(fontSize: 16, fontWeight: FontWeight.w500) ??
        TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurface);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: tileBg,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor),
              const SizedBox(width: 12),
              Text(
                label,
                style: labelStyle,
              )
            ],
          ),
          widget,
        ],
      ),
    );
  }
}
