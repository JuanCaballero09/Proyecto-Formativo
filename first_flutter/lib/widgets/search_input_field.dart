import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

/// Widget mejorado de barra de búsqueda con accesibilidad
/// Optimizado para experiencia táctil móvil - búsqueda automática
class SearchInputField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final VoidCallback? onClearPressed;
  final String? hintText;
  final bool enabled;

  const SearchInputField({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    this.onClearPressed,
    this.hintText,
    this.enabled = true,
  }) : super(key: key);

  @override
  State<SearchInputField> createState() => _SearchInputFieldState();
}

class _SearchInputFieldState extends State<SearchInputField> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;

    return TextField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      enabled: widget.enabled,
      onChanged: (value) {
        widget.onChanged(value);
        setState(() {}); // Actualizar para mostrar/ocultar sufijo
      },
      textInputAction: TextInputAction.none,
      keyboardType: TextInputType.text,
      maxLines: 1,
      style: theme.textTheme.bodyMedium?.copyWith(
        fontSize: 16,
      ),
      decoration: InputDecoration(
        hintText: widget.hintText ?? localizations.search,
        hintStyle: theme.inputDecorationTheme.hintStyle,
        prefixIcon: Tooltip(
          message: 'Buscar',
          child: Icon(
            Icons.search,
            color: theme.iconTheme.color,
            semanticLabel: 'Icono de búsqueda',
          ),
        ),
        suffixIcon: widget.controller.text.isNotEmpty
            ? Tooltip(
                message: 'Limpiar búsqueda',
                child: IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: theme.iconTheme.color,
                    semanticLabel: 'Limpiar',
                  ),
                  onPressed: widget.onClearPressed,
                  tooltip: 'Limpiar búsqueda',
                ),
              )
            : null,
        filled: true,
        fillColor: theme.inputDecorationTheme.fillColor ?? theme.cardColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: theme.dividerColor,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: theme.dividerColor,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: theme.primaryColor,
            width: 2,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: theme.dividerColor.withOpacity(0.5),
            width: 1,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 12,
        ),
      ),
    );
  }
}
