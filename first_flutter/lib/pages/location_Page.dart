import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../l10n/app_localizations.dart';

class MapaOSMPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final LatLng barranquilla = LatLng(10.96854, -74.78132);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.selectLocation),
        backgroundColor: const Color.fromRGBO(237, 88, 33, 1),
        foregroundColor: Colors.white,
      ),
      body: FlutterMap(
        options: MapOptions(
          center: barranquilla,
          zoom: 13.0,
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
                point: barranquilla,
                width: 80,
                height: 80,
                builder: (context) => const Icon(
                  Icons.location_pin,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

