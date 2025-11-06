// Archivo: lib/silo_model.dart

class Silo {
  final String idSilo;
  final String nombre;
  final String? descripcion;
  final DateTime? fechaLlenado;
  final double? capacidadToneladas;
  final String? ubicacion;
  final String? idGrano;
  
  Silo({
    required this.idSilo,
    required this.nombre,
    this.descripcion,
    this.fechaLlenado,
    this.capacidadToneladas,
    this.ubicacion,
    this.idGrano,
  });

  factory Silo.fromJson(Map<String, dynamic> json) {
    return Silo(
      idSilo: json['idSilo'] as String,
      nombre: json['nombre'] as String,
      descripcion: json['descripcion'] as String?,
      fechaLlenado: json['fechaLlenado'] != null 
          ? DateTime.parse(json['fechaLlenado'] as String)
          : null,
      capacidadToneladas: json['capacidadToneladas'] != null
          ? (json['capacidadToneladas'] as num).toDouble()
          : null,
      ubicacion: json['ubicacion'] as String?,
      idGrano: json['idGrano'] as String?,
    );
  }
}
