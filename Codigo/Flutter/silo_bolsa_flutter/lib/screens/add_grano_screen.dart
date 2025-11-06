// Archivo: lib/screens/add_grano_screen.dart

import 'package:flutter/material.dart';
import '../api_service.dart';

class AddGranoScreen extends StatefulWidget {
  const AddGranoScreen({super.key});

  @override
  State<AddGranoScreen> createState() => _AddGranoScreenState();
}

class _AddGranoScreenState extends State<AddGranoScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();
  
  final _descripcionController = TextEditingController();
  final _tempMinController = TextEditingController();
  final _tempMaxController = TextEditingController();
  final _humedadMinController = TextEditingController();
  final _humedadMaxController = TextEditingController();
  final _co2MinController = TextEditingController();
  final _co2MaxController = TextEditingController();
  
  bool _isLoading = false;

  @override
  void dispose() {
    _descripcionController.dispose();
    _tempMinController.dispose();
    _tempMaxController.dispose();
    _humedadMinController.dispose();
    _humedadMaxController.dispose();
    _co2MinController.dispose();
    _co2MaxController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final granoData = {
        // No enviamos idGrano porque es autoincremental en el backend
        'descripcion': _descripcionController.text.isEmpty ? null : _descripcionController.text,
        'tempMin': double.parse(_tempMinController.text),
        'tempMax': double.parse(_tempMaxController.text),
        'humedadMin': double.parse(_humedadMinController.text),
        'humedadMax': double.parse(_humedadMaxController.text),
        'nivelDioxidoMin': double.parse(_co2MinController.text),
        'nivelDioxidoMax': double.parse(_co2MaxController.text),
      };

      await _apiService.createGrano(granoData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Grano creado exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al crear grano: $e'),
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
        title: const Text('Nuevo Tipo de Grano', style: TextStyle(color: Colors.white)),
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
                'Información del Grano',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              
              // Descripción
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(
                  labelText: 'Nombre/Descripción',
                  hintText: 'Ej: Trigo, Maíz, Soja',
                  prefixIcon: Icon(Icons.grass),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La descripción es requerida';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              
              // Temperatura
              const Text(
                'Rango de Temperatura (°C)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _tempMinController,
                      decoration: const InputDecoration(
                        labelText: 'Mínima',
                        hintText: '10',
                        prefixIcon: Icon(Icons.thermostat),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Requerido';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Inválido';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _tempMaxController,
                      decoration: const InputDecoration(
                        labelText: 'Máxima',
                        hintText: '30',
                        prefixIcon: Icon(Icons.thermostat),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Requerido';
                        }
                        final max = double.tryParse(value);
                        final min = double.tryParse(_tempMinController.text);
                        if (max == null) {
                          return 'Inválido';
                        }
                        if (min != null && max <= min) {
                          return 'Debe ser > mín';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Humedad
              const Text(
                'Rango de Humedad (%)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _humedadMinController,
                      decoration: const InputDecoration(
                        labelText: 'Mínima',
                        hintText: '30',
                        prefixIcon: Icon(Icons.water_drop),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Requerido';
                        }
                        final val = double.tryParse(value);
                        if (val == null || val < 0 || val > 100) {
                          return 'Debe ser 0-100';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _humedadMaxController,
                      decoration: const InputDecoration(
                        labelText: 'Máxima',
                        hintText: '70',
                        prefixIcon: Icon(Icons.water_drop),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Requerido';
                        }
                        final max = double.tryParse(value);
                        final min = double.tryParse(_humedadMinController.text);
                        if (max == null || max < 0 || max > 100) {
                          return 'Debe ser 0-100';
                        }
                        if (min != null && max <= min) {
                          return 'Debe ser > mín';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // CO2
              const Text(
                'Rango de CO2 (PPM)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _co2MinController,
                      decoration: const InputDecoration(
                        labelText: 'Mínimo',
                        hintText: '400',
                        prefixIcon: Icon(Icons.cloud),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Requerido';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Inválido';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _co2MaxController,
                      decoration: const InputDecoration(
                        labelText: 'Máximo',
                        hintText: '2000',
                        prefixIcon: Icon(Icons.cloud),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Requerido';
                        }
                        final max = double.tryParse(value);
                        final min = double.tryParse(_co2MinController.text);
                        if (max == null) {
                          return 'Inválido';
                        }
                        if (min != null && max <= min) {
                          return 'Debe ser > mín';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Botón de submit
              ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.green,
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
                    : const Text('Crear Tipo de Grano', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
