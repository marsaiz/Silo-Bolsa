// Archivo: lib/lectura_model.dart

class Lectura {
  final DateTime fechaHoraLectura;
  final double temp;
  final double humedad;
  final double dioxidoDeCarbono;

  Lectura({
    required this.fechaHoraLectura,
    required this.temp,
    required this.humedad,
    required this.dioxidoDeCarbono,
  });

  // Constructor para crear una Lectura desde el JSON
  factory Lectura.fromJson(Map<String, dynamic> json) {
    return Lectura(
      // La clave 'fechaHoraLectura' se convierte a objeto DateTime
      // Normalizamos a UTC por si el backend envía 'Z' (ISO 8601 UTC)
      fechaHoraLectura: DateTime.parse(json['fechaHoraLectura']).toUtc(), 
      // Las claves de los sensores se leen como double
      temp: (json['temp'] as num).toDouble(),
      humedad: (json['humedad'] as num).toDouble(),
      dioxidoDeCarbono: (json['dioxidoDeCarbono'] as num).toDouble(),
    );
  }
}