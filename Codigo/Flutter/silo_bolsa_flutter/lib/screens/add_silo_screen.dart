// Archivo: lib/screens/add_silo_screen.dart

import 'package:flutter/material.dart';
import '../api_service.dart';
import 'location_picker_screen.dart'; // ¡Importa la nueva pantalla!
import 'package:latlong2/latlong.dart'; // Necesitas esto para LatLng

class AddSiloScreen extends StatefulWidget {
  const AddSiloScreen({super.key});

  @override
  State<AddSiloScreen> createState() => _AddSiloScreenState();
}

class _AddSiloScreenState extends State<AddSiloScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();

  final _latitudController = TextEditingController();
  final _longitudController = TextEditingController();
  final _capacidadController = TextEditingController();
  final _tipoGranoController = TextEditingController();
  final _descripcionController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _latitudController.dispose();
    _longitudController.dispose();
    _capacidadController.dispose();
    _tipoGranoController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  // Nuevo método para abrir el selector de ubicación
  Future<void> _pickLocation() async {
    // Intenta usar la ubicación actual si ya está en los controladores
    LatLng? initialLocation;
    if (_latitudController.text.isNotEmpty && _longitudController.text.isNotEmpty) {
      try {
        initialLocation = LatLng(
          double.parse(_latitudController.text),
          double.parse(_longitudController.text),
        );
      } catch (e) {
        // Ignorar si los valores actuales no son válidos
      }
    }

    final LatLng? pickedLocation = await Navigator.push<LatLng>(
      context,
      MaterialPageRoute(
        builder: (context) => LocationPickerScreen(
          initialLocation: initialLocation,
        ),
      ),
    );

    if (pickedLocation != null) {
      setState(() {
        _latitudController.text = pickedLocation.latitude.toStringAsFixed(6);
        _longitudController.text = pickedLocation.longitude.toStringAsFixed(6);
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final siloData = {
        'latitud': double.parse(_latitudController.text),
        'longitud': double.parse(_longitudController.text),
        'capacidad': int.parse(_capacidadController.text),
        'tipoGrano': int.parse(_tipoGranoController.text),
        'descripcion': _descripcionController.text.isEmpty ? null : _descripcionController.text,
      };

      await _apiService.createSilo(siloData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Silo creado exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al crear silo: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Nuevo Silo', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Información del Silo',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Botón para abrir el mapa
              ElevatedButton.icon(
                onPressed: _pickLocation,
                icon: const Icon(Icons.map),
                label: const Text('Seleccionar Ubicación en el Mapa'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: Theme.of(context).colorScheme.secondary, // Un color diferente para distinguirlo
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 16),

              // Latitud (ahora se puede rellenar desde el mapa)
              TextFormField(
                controller: _latitudController,
                decoration: const InputDecoration(
                  labelText: 'Latitud',
                  hintText: '-34.6037',
                  prefixIcon: Icon(Icons.location_on),
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La latitud es requerida';
                  }
                  final lat = double.tryParse(value);
                  if (lat == null || lat < -90 || lat > 90) {
                    return 'Latitud inválida (-90 a 90)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Longitud (ahora se puede rellenar desde el mapa)
              TextFormField(
                controller: _longitudController,
                decoration: const InputDecoration(
                  labelText: 'Longitud',
                  hintText: '-58.3816',
                  prefixIcon: Icon(Icons.location_on),
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La longitud es requerida';
                  }
                  final lon = double.tryParse(value);
                  if (lon == null || lon < -180 || lon > 180) {
                    return 'Longitud inválida (-180 a 180)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Resto de los campos (Capacidad, Tipo de Grano, Descripción)
              TextFormField(
                controller: _capacidadController,
                decoration: const InputDecoration(
                  labelText: 'Capacidad (kg)',
                  hintText: '1000',
                  prefixIcon: Icon(Icons.scale),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La capacidad es requerida';
                  }
                  final cap = int.tryParse(value);
                  if (cap == null || cap <= 0) {
                    return 'Capacidad inválida (debe ser > 0)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _tipoGranoController,
                decoration: const InputDecoration(
                  labelText: 'Tipo de Grano (ID)',
                  hintText: '1',
                  prefixIcon: Icon(Icons.grass),
                  border: OutlineInputBorder(),
                  helperText: 'ID del tipo de grano desde la lista de granos',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El tipo de grano es requerido';
                  }
                  final tipo = int.tryParse(value);
                  if (tipo == null || tipo <= 0) {
                    return 'ID de grano inválido (debe ser > 0)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción (opcional)',
                  hintText: 'Silo ubicado en...',
                  prefixIcon: Icon(Icons.description),
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),

              // Botón de submit
              ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text('Crear Silo', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}