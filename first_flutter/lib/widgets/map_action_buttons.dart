import 'package:flutter/material.dart';

/// Widget que contiene los botones de acción del mapa
/// 
/// Incluye:
/// - Botón de modo de medición
/// - Botón de ubicación actual
class MapActionButtons extends StatelessWidget {
  /// Callback cuando se presiona el botón de ubicación actual
  final VoidCallback onLocationPressed;
  
  /// Callback cuando se presiona el botón de modo de medición
  final VoidCallback onMeasurePressed;
  
  /// Indica si se está cargando la ubicación
  final bool isLoadingLocation;
  
  /// Indica si el modo de medición está activo
  final bool isMeasuringMode;

  const MapActionButtons({
    Key? key,
    required this.onLocationPressed,
    required this.onMeasurePressed,
    required this.isLoadingLocation,
    required this.isMeasuringMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Botón para modo de medición
        FloatingActionButton(
          onPressed: onMeasurePressed,
          backgroundColor: isMeasuringMode 
            ? Colors.blue 
            : const Color.fromRGBO(237, 88, 33, 1),
          heroTag: 'measureButton',
          child: Icon(
            isMeasuringMode ? Icons.close : Icons.straighten,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 10),
        // Botón de ubicación actual
        FloatingActionButton(
          onPressed: onLocationPressed,
          backgroundColor: const Color.fromRGBO(237, 88, 33, 1),
          heroTag: 'locationButton',
          child: isLoadingLocation
            ? const CircularProgressIndicator(color: Colors.white)
            : const Icon(Icons.my_location, color: Colors.white),
        ),
      ],
    );
  }
}