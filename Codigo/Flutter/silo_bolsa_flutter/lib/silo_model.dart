// Archivo: lib/silo_model.dart

class Silo {
  final String idSilo;
  final double latitud;
  final double longitud;
  final int capacidad;
  final int tipoGrano;
  final String? descripcion;
  
  Silo({
    required this.idSilo,
    required this.latitud,
    required this.longitud,
    required this.capacidad,
    required this.tipoGrano,
    this.descripcion,
  });

  factory Silo.fromJson(Map<String, dynamic> json) {
    return Silo(
      idSilo: json['idSilo'] as String,
      latitud: (json['latitud'] as num).toDouble(),
      longitud: (json['longitud'] as num).toDouble(),
      capacidad: json['capacidad'] as int,
      tipoGrano: json['tipoGrano'] as int,
      descripcion: json['descripcion'] as String?,
    );
  }
}
