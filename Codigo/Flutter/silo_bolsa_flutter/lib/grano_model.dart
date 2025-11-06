// Archivo: lib/grano_model.dart

class Grano {
  final String idGrano;
  final String nombre;
  final String? descripcion;
  final double? tempMaxima;
  final double? tempMinima;
  final double? humedadMaxima;
  final double? humedadMinima;
  final double? co2Maximo;
  
  Grano({
    required this.idGrano,
    required this.nombre,
    this.descripcion,
    this.tempMaxima,
    this.tempMinima,
    this.humedadMaxima,
    this.humedadMinima,
    this.co2Maximo,
  });

  factory Grano.fromJson(Map<String, dynamic> json) {
    return Grano(
      idGrano: json['idGrano'] as String,
      nombre: json['nombre'] as String,
      descripcion: json['descripcion'] as String?,
      tempMaxima: json['tempMaxima'] != null
          ? (json['tempMaxima'] as num).toDouble()
          : null,
      tempMinima: json['tempMinima'] != null
          ? (json['tempMinima'] as num).toDouble()
          : null,
      humedadMaxima: json['humedadMaxima'] != null
          ? (json['humedadMaxima'] as num).toDouble()
          : null,
      humedadMinima: json['humedadMinima'] != null
          ? (json['humedadMinima'] as num).toDouble()
          : null,
      co2Maximo: json['co2Maximo'] != null
          ? (json['co2Maximo'] as num).toDouble()
          : null,
    );
  }
}
