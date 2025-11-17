// Archivo: lib/screens/silos_screen.dart

import 'package:flutter/material.dart';
import '../api_service.dart';
import '../silo_model.dart';
import 'add_silo_screen.dart';
import 'map_screen.dart'; // ¡Importa tu MapScreen aquí!

class SilosScreen extends StatefulWidget {
  const SilosScreen({super.key});

  @override
  State<SilosScreen> createState() => _SilosScreenState();
}

class _SilosScreenState extends State<SilosScreen> {
  late Future<List<Silo>> _futureSilos;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _futureSilos = _apiService.fetchSilos();
  }

  // Método para recargar la lista de silos
  void _refreshSilos() {
    setState(() {
      _futureSilos = _apiService.fetchSilos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Silos', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<Silo>>(
        future: _futureSilos,
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
                  Text('Error al cargar silos: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _refreshSilos, // Usa el método de refresco
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
                  Icon(Icons.inventory_2_outlined, size: 48, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No hay silos registrados.'),
                ],
              ),
            );
          } else {
            final silos = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: silos.length,
              itemBuilder: (context, index) {
                final silo = silos[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: const Icon(Icons.inventory_2, color: Colors.white),
                    ),
                    title: Text(
                      // Muestra el ID completo o un fragmento, como prefieras
                      'Silo: ${silo.idSilo}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (silo.descripcion != null && silo.descripcion!.isNotEmpty)
                          Text('Descripción: ${silo.descripcion!}'),
                        Text('Capacidad: ${silo.capacidad} kg'),
                        Text('Tipo de grano: ${silo.tipoGrano}'),
                        // Agrega una fila para mostrar la ubicación y el botón
                        Row(
                          children: [
                            Text('Ubicación: ${silo.latitud.toStringAsFixed(4)}, ${silo.longitud.toStringAsFixed(4)}'),
                            const Spacer(), // Empuja el botón al final de la fila
                            // Botón para ver en el mapa
                            ElevatedButton.icon(
                              onPressed: () {
                                // Navegar a MapScreen cuando se presione el botón
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MapScreen(
                                      latitude: silo.latitud,
                                      longitude: silo.longitud,
                                      title: 'Ubicación de Silo ${silo.idSilo.substring(0, 8)}',
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.map, size: 18),
                              label: const Text('Ver Mapa'),
                              style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  minimumSize: Size.zero, // Para hacer el botón más compacto
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Para reducir el área de tap invisible
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Eliminamos el trailing de flecha si ya no lo usas, o lo puedes mover
                    // trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Puedes mantener esta navegación para ver el detalle del silo
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Detalle de Silo ${silo.idSilo}')),
                      );
                    },
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
            MaterialPageRoute(builder: (context) => const AddSiloScreen()),
          );

          // Si se creó un silo, recargar la lista
          if (result == true) {
            _refreshSilos(); // Usa el método de refresco
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}