// Archivo: lib/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'lectura_model.dart'; // Importa el modelo

class ApiService {
  final String _apiUrl = 'https://remarkable-healing-production.up.railway.app/api/lecturas';

  Future<List<Lectura>> fetchLecturas() async {
    final response = await http.get(Uri.parse(_apiUrl));

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
}