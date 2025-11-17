// Archivo: lib/screens/granos_screen.dart

import 'package:flutter/material.dart';
import '../api_service.dart';
import '../grano_model.dart';
import 'add_grano_screen.dart';

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
      backgroundColor: Colors.transparent,
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
                      grano.descripcion ?? 'Grano ID: ${grano.idGrano}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('ID: ${grano.idGrano}'),
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
                            _buildParameterRow(
                              Icons.thermostat,
                              'Temperatura',
                              '${grano.tempMin}°C - ${grano.tempMax}°C',
                              Colors.red,
                            ),
                            _buildParameterRow(
                              Icons.water_drop,
                              'Humedad',
                              '${grano.humedadMin}% - ${grano.humedadMax}%',
                              Colors.blue,
                            ),
                            _buildParameterRow(
                              Icons.cloud,
                              'CO2',
                              '${grano.nivelDioxidoMin} - ${grano.nivelDioxidoMax} PPM',
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
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddGranoScreen()),
          );
          
          // Si se creó un grano, recargar la lista
          if (result == true) {
            setState(() {
              _futureGranos = _apiService.fetchGranos();
            });
          }
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
