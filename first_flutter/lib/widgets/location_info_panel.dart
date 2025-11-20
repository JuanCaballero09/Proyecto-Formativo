import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

/// Widget que muestra la información de ubicación y distancia
/// 
/// Muestra:
/// - La dirección actual seleccionada
/// - La distancia calculada (si está disponible)
class LocationInfoPanel extends StatelessWidget {
  /// La dirección actual para mostrar
  final String address;
  
  /// La distancia calculada en kilómetros (opcional)
  final double? distance;

  const LocationInfoPanel({
    Key? key,
    required this.address,
    this.distance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppLocalizations.of(context)!.selectedAddress,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            address,
            style: const TextStyle(fontSize: 14),
          ),
          if (distance != null) ...[
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.distanceLabel,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${distance!.toStringAsFixed(2)} km',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ],
      ),
    );
  }
}