// Archivo: lib/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'lectura_model.dart';
import 'silo_model.dart';
import 'grano_model.dart';
import 'alerta_model.dart';

class ApiService {
  final String _baseUrl = 'https://remarkable-healing-production.up.railway.app/api';
  
  String get _lecturasUrl => '$_baseUrl/lecturas';
  String get _silosUrl => '$_baseUrl/silos';
  String get _granosUrl => '$_baseUrl/granos';
  String get _alertasUrl => '$_baseUrl/alertas';

  Future<List<Lectura>> fetchLecturas() async {
    final response = await http.get(Uri.parse(_lecturasUrl));

    if (response.statusCode == 200) {
      // 1. Decodificar la respuesta JSON (que es una lista con el formato .NET)
      // El formato de tu API devuelve una estructura como { $id: "1", $values: [...] }
      final jsonResponse = jsonDecode(response.body);
      
      // 2. Extraer el array de lecturas desde la clave '$values'
      final List<dynamic> lecturasJson = jsonResponse['\$values'];
      
      // 3. Mapear cada elemento del JSON a un objeto Lectura
      return lecturasJson.map((jsonItem) {
        // Tu JSON tiene los identificadores "$id", "0", "1", etc.
        // Necesitamos encontrar el objeto real dentro de estas claves de identificador
        // El objeto de lectura real está dentro del valor del ID, no es un array directo.
        
        // El JSON de tu API no es un array simple, es un objeto que contiene una lista
        // de objetos anidados ({"$id":"2", "idLectura": ...})
        // La mejor manera de manejar esto es iterar sobre los objetos dentro de '$values'
        // y extraer los campos.
        
        // Nota: Para simplificar, asumiremos que los campos 'temp', 'humedad', etc., 
        // están directamente en cada objeto de lectura, lo cual parece ser el caso 
        // si ignoramos los marcadores de serialización de .NET.
        
        // Iteramos sobre la lista y extraemos las propiedades. 
        // Los valores de tu API parecen ser objetos con IDs anidados, lo que complica
        // un poco la decodificación. Usaremos una implementación más robusta.

        // Por ahora, asumamos que si el objeto tiene 'temp', es una lectura válida.
        if (jsonItem is Map<String, dynamic> && jsonItem.containsKey('temp')) {
          return Lectura.fromJson(jsonItem);
        }
        
        // Si el formato es como lo enviaste (ej. $id"2"idLectura...), el JSON Parser 
        // fallará. Asumo que el JSON real que devuelve la API es estándar, como:
        // [ { "idLectura": "...", "temp": 26.92, ... }, { ... } ]
        
        // Si el JSON es realmente el formato serializado de .NET, la estructura
        // para acceder a los datos es más compleja (requiere un análisis del JSON real).
        
        // **Implementación para JSON real que parece provenir de tu servidor:**
        // (Asumiendo que el JSON es un objeto con $values que es una lista de mapas)
        
        // Para ignorar los $id anidados, si el objeto es de la forma:
        // "$id": "2", "idLectura": "...", "temp": 26.92...
        // y ha sido decodificado como Map<String, dynamic>
        
        // Si la clave no es '$id', se intenta mapear.
        final Map<String, dynamic> lecturaMap = jsonItem;
        return Lectura.fromJson(lecturaMap);

      }).toList();
      
    } else {
      // Si la respuesta no es 200 (OK), lanza un error.
      throw Exception('Fallo al cargar las lecturas de la API');
    }
  }

  // Método para obtener todos los silos
  Future<List<Silo>> fetchSilos() async {
    final response = await http.get(Uri.parse(_silosUrl));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final List<dynamic> silosJson = jsonResponse['\$values'];
      
      return silosJson.map((jsonItem) {
        if (jsonItem is Map<String, dynamic>) {
          return Silo.fromJson(jsonItem);
        }
        throw Exception('Formato de silo inválido');
      }).toList();
    } else {
      throw Exception('Fallo al cargar los silos de la API');
    }
  }

  // Método para obtener todos los granos
  Future<List<Grano>> fetchGranos() async {
    final response = await http.get(Uri.parse(_granosUrl));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final List<dynamic> granosJson = jsonResponse['\$values'];
      
      return granosJson.map((jsonItem) {
        if (jsonItem is Map<String, dynamic>) {
          return Grano.fromJson(jsonItem);
        }
        throw Exception('Formato de grano inválido');
      }).toList();
    } else {
      throw Exception('Fallo al cargar los granos de la API');
    }
  }

  // Método para obtener todas las alertas
  Future<List<Alerta>> fetchAlertas() async {
    final response = await http.get(Uri.parse(_alertasUrl));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final List<dynamic> alertasJson = jsonResponse['\$values'];
      
      return alertasJson.map((jsonItem) {
        if (jsonItem is Map<String, dynamic>) {
          return Alerta.fromJson(jsonItem);
        }
        throw Exception('Formato de alerta inválido');
      }).toList();
    } else {
      throw Exception('Fallo al cargar las alertas de la API');
    }
  }

  // Método para crear un nuevo silo
  Future<void> createSilo(Map<String, dynamic> siloData) async {
    final response = await http.post(
      Uri.parse(_silosUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(siloData),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Fallo al crear el silo: ${response.statusCode}');
    }
  }

  // Método para crear un nuevo grano
  Future<void> createGrano(Map<String, dynamic> granoData) async {
    final response = await http.post(
      Uri.parse(_granosUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(granoData),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Fallo al crear el grano: ${response.statusCode}');
    }
  }
}