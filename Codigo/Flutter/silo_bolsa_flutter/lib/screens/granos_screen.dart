// Archivo: lib/screens/granos_screen.dart

import 'package:flutter/material.dart';
import '../api_service.dart';
import '../grano_model.dart';

class GranosScreen extends StatefulWidget {
  const GranosScreen({super.key});

  @override
  State<GranosScreen> createState() => _GranosScreenState();
}

class _GranosScreenState extends State<GranosScreen> {
  late Future<List<Grano>> _futureGranos;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _futureGranos = _apiService.fetchGranos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Granos', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<Grano>>(
        future: _futureGranos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error al cargar granos: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _futureGranos = _apiService.fetchGranos();
                      });
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.grass_outlined, size: 48, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No hay granos registrados.'),
                ],
              ),
            );
          } else {
            final granos = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: granos.length,
              itemBuilder: (context, index) {
                final grano = granos[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ExpansionTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.green,
                      child: const Icon(Icons.grass, color: Colors.white),
                    ),
                    title: Text(
                      grano.nombre,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: grano.descripcion != null
                        ? Text(grano.descripcion!)
                        : null,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Parámetros de Almacenamiento:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            if (grano.tempMinima != null && grano.tempMaxima != null)
                              _buildParameterRow(
                                Icons.thermostat,
                                'Temperatura',
                                '${grano.tempMinima}°C - ${grano.tempMaxima}°C',
                                Colors.red,
                              ),
                            if (grano.humedadMinima != null && grano.humedadMaxima != null)
                              _buildParameterRow(
                                Icons.water_drop,
                                'Humedad',
                                '${grano.humedadMinima}% - ${grano.humedadMaxima}%',
                                Colors.blue,
                              ),
                            if (grano.co2Maximo != null)
                              _buildParameterRow(
                                Icons.cloud,
                                'CO2 Máximo',
                                '${grano.co2Maximo} PPM',
                                Colors.green,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Agregar nuevo grano
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Función de agregar grano en desarrollo')),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildParameterRow(IconData icon, String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 8),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value),
        ],
      ),
    );
  }
}
