// Archivo: lib/screens/location_picker_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart'; // Para LatLng

class LocationPickerScreen extends StatefulWidget {
  final LatLng? initialLocation; // Ubicación inicial opcional
  final double initialZoom;

  const LocationPickerScreen({
    Key? key,
    this.initialLocation,
    this.initialZoom = 15.0, // Zoom por defecto
  }) : super(key: key);

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  LatLng? _pickedLocation; // La ubicación seleccionada por el usuario
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _pickedLocation = widget.initialLocation;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Selecciona Ubicación', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _pickedLocation ?? const LatLng(-35.9167, -64.2954), // Buenos Aires por defecto
              initialZoom: widget.initialZoom,
              onTap: (tapPosition, latLng) {
                // Cuando el usuario toca el mapa
                setState(() {
                  _pickedLocation = latLng;
                });
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app_mapa_osm', // Tu package name
              ),
              if (_pickedLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _pickedLocation!,
                      width: 80,
                      height: 80,
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 40.0,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          // Un icono flotante para indicar el centro de la pantalla
          // Puede ser útil si no se quiere depender solo del tap
          // Center(
          //   child: Icon(
          //     Icons.add_location_alt,
          //     color: Colors.blue.withOpacity(0.7),
          //     size: 50,
          //   ),
          // ),
        ],
      ),
      floatingActionButton: _pickedLocation == null
          ? null // No mostrar el botón si no hay ubicación seleccionada
          : FloatingActionButton.extended(
              onPressed: () {
                // Devolver la ubicación seleccionada a la pantalla anterior
                Navigator.pop(context, _pickedLocation);
              },
              label: const Text('Confirmar Ubicación'),
              icon: const Icon(Icons.check),
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}