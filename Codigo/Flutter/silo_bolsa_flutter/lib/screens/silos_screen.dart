// Archivo: lib/screens/silos_screen.dart

import 'package:flutter/material.dart';
import '../api_service.dart';
import '../silo_model.dart';
import 'package:intl/intl.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    onPressed: () {
                      setState(() {
                        _futureSilos = _apiService.fetchSilos();
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
                      silo.nombre,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (silo.descripcion != null)
                          Text(silo.descripcion!),
                        if (silo.ubicacion != null)
                          Text('Ubicación: ${silo.ubicacion}'),
                        if (silo.capacidadToneladas != null)
                          Text('Capacidad: ${silo.capacidadToneladas} ton'),
                        if (silo.fechaLlenado != null)
                          Text('Llenado: ${DateFormat('dd/MM/yyyy').format(silo.fechaLlenado!)}'),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // TODO: Navegar a detalle del silo
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Detalle de ${silo.nombre}')),
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
        onPressed: () {
          // TODO: Agregar nuevo silo
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Función de agregar silo en desarrollo')),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
