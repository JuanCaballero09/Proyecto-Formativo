import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';
import '../l10n/app_localizations.dart';

/// Página que muestra un mapa interactivo para seleccionar ubicaciones
class MapaOSMPage extends StatefulWidget {
  @override
  State<MapaOSMPage> createState() => _MapaOSMPageState();
}

class _MapaOSMPageState extends State<MapaOSMPage> {
  // Controlador del mapa para manejar zoom y posición
  final MapController _mapController = MapController();
  
  // Posición inicial del marcador (Barranquilla)
  LatLng _currentPosition = LatLng(10.96854, -74.78132);
  
  // Estado de arrastre del marcador
  bool _isDragging = false;

  // Dirección actual
  String _currentAddress = '';

  // Obtener la dirección a partir de las coordenadas
  Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          _currentAddress = 
            '${place.street}, '
            '${place.subLocality}, '
            '${place.locality}, '
            '${place.country}';
        });
      }
    } catch (e) {
      setState(() {
        _currentAddress = 'No se pudo obtener la dirección';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Obtener la dirección inicial
    _getAddressFromLatLng(_currentPosition);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.selectLocation,
        style: TextStyle(color: Colors.white)
        ),
        backgroundColor: const Color.fromRGBO(237, 88, 33, 1),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: _currentPosition,
          initialZoom: 13.0,
          onTap: (tapPosition, point) async {
            setState(() {
              _currentPosition = point;
              _isDragging = true;
            });
            
            // Obtener la dirección del nuevo punto
            await _getAddressFromLatLng(point);
            
            // Animar el marcador
            Future.delayed(const Duration(milliseconds: 500), () {
              setState(() {
                _isDragging = false;
              });
            });
          },
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
            userAgentPackageName: 'com.tuempresa.tuapp',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: _currentPosition,
                width: 40,
                height: 40,
                child: AnimatedScale(
                  duration: const Duration(milliseconds: 200),
                  scale: _isDragging ? 1.5 : 1.0,
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
              ),
            ],
          ),
        ],
      )),
      // Panel de información de la dirección
      Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Dirección seleccionada:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _currentAddress,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    ],
  ),
    );
  }
}

