import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart'; // Importa LatLng de latlong2

class MapScreen extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String title;

  const MapScreen({
    Key? key,
    required this.latitude,
    required this.longitude,
    this.title = 'Ubicación',
  }) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    final LatLng location = LatLng(widget.latitude, widget.longitude);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: location, // Centra el mapa en la ubicación dada
          initialZoom: 15.0, // Nivel de zoom inicial
        ),
        children: [ //contiene las capas del mapa
          // Capa de los mosaicos del mapa (OpenStreetMap)
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app_mapa_osm', // Reemplaza con tu package name
          ),
          // Capa para los marcadores
          MarkerLayer(
            markers: [
              Marker(
                point: location, // La posición del marcador
                width: 80,
                height: 80,
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 40.0,
                ),
                // Puedes agregar un GestureDetector si quieres que el marcador sea interactivo
                // builder: (context) => GestureDetector(
                //   onTap: () {
                //     ScaffoldMessenger.of(context).showSnackBar(
                //       SnackBar(content: Text(widget.title)),
                //     );
                //   },
                //   child: Icon(
                //     Icons.location_on,
                //     color: Colors.red,
                //     size: 40.0,
                //   ),
                // ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}