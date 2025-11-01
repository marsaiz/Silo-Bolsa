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
      // Parseamos la fecha tal como viene; DateTime.parse respeta zona horaria si trae 'Z' u offset.
      // Para mostrar, usaremos toLocal() en la UI.
      fechaHoraLectura: DateTime.parse(json['fechaHoraLectura']),
      // Las claves de los sensores se leen como double
      temp: (json['temp'] as num).toDouble(),
      humedad: (json['humedad'] as num).toDouble(),
      dioxidoDeCarbono: (json['dioxidoDeCarbono'] as num).toDouble(),
    );
  }
}
