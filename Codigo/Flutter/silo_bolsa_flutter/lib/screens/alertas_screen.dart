// Archivo: lib/screens/alertas_screen.dart

import 'package:flutter/material.dart';
import '../api_service.dart';
import '../alerta_model.dart';
import 'package:intl/intl.dart';

class AlertasScreen extends StatefulWidget {
  const AlertasScreen({super.key});

  @override
  State<AlertasScreen> createState() => _AlertasScreenState();
}

class _AlertasScreenState extends State<AlertasScreen> {
  late Future<List<Alerta>> _futureAlertas;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _futureAlertas = _apiService.fetchAlertas();
  }

  Color _getColorByType(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'temperatura':
        return Colors.red;
      case 'humedad':
        return Colors.blue;
      case 'co2':
      case 'dioxido de carbono':
        return Colors.green;
      default:
        return Colors.orange;
    }
  }

  IconData _getIconByType(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'temperatura':
        return Icons.thermostat;
      case 'humedad':
        return Icons.water_drop;
      case 'co2':
      case 'dioxido de carbono':
        return Icons.cloud;
      default:
        return Icons.warning;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Alertas', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<Alerta>>(
        future: _futureAlertas,
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
                  Text('Error al cargar alertas: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _futureAlertas = _apiService.fetchAlertas();
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
                  Icon(Icons.check_circle_outline, size: 48, color: Colors.green),
                  SizedBox(height: 16),
                  Text('No hay alertas activas.'),
                  SizedBox(height: 8),
                  Text(
                    'Todos los sensores están dentro de los parámetros normales.',
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          } else {
            final alertas = snapshot.data!;
            // Ordenar por fecha más reciente primero
            alertas.sort((a, b) => b.fechaHoraAlerta.compareTo(a.fechaHoraAlerta));

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: alertas.length,
              itemBuilder: (context, index) {
                final alerta = alertas[index];
                final color = _getColorByType(alerta.tipoAlerta);
                final icon = _getIconByType(alerta.tipoAlerta);

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: color.withOpacity(0.2),
                      child: Icon(icon, color: color),
                    ),
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            alerta.tipoAlerta,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: alerta.estadoAlerta.toLowerCase() == 'activa'
                                ? Colors.red.withOpacity(0.1)
                                : Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            alerta.estadoAlerta,
                            style: TextStyle(
                              fontSize: 12,
                              color: alerta.estadoAlerta.toLowerCase() == 'activa'
                                  ? Colors.red
                                  : Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        if (alerta.descripcion != null)
                          Text(alerta.descripcion!),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('dd/MM/yyyy HH:mm').format(alerta.fechaHoraAlerta),
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    isThreeLine: true,
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // TODO: Mostrar detalle de la alerta
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(alerta.tipoAlerta),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Estado: ${alerta.estadoAlerta}'),
                              const SizedBox(height: 8),
                              Text('Fecha: ${DateFormat('dd/MM/yyyy HH:mm').format(alerta.fechaHoraAlerta)}'),
                              if (alerta.descripcion != null) ...[
                                const SizedBox(height: 8),
                                Text('Descripción: ${alerta.descripcion}'),
                              ],
                              const SizedBox(height: 8),
                              Text('ID Silo: ${alerta.idSilo}'),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cerrar'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
