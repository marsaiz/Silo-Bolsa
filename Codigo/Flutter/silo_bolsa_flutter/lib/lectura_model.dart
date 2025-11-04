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
    // Algunas APIs envían 'Z' (UTC) aunque el valor ya esté en hora local.
    // Aquí ignoramos cualquier sufijo de zona (Z o ±HH:MM) y tratamos la fecha como local "naive".
    final raw = json['fechaHoraLectura'] as String;
    final localLike = raw.replaceFirst(RegExp(r'(Z|[+\-]\d{2}:\d{2})$'), '');

    return Lectura(
      fechaHoraLectura: DateTime.parse(localLike),
      // Las claves de los sensores se leen como double
      temp: (json['temp'] as num).toDouble(),
      humedad: (json['humedad'] as num).toDouble(),
      dioxidoDeCarbono: (json['dioxidoDeCarbono'] as num).toDouble(),
    );
  }
}
