// Archivo: lib/grano_model.dart

class Grano {
  final int idGrano;
  final String? descripcion;
  final double humedadMax;
  final double humedadMin;
  final double tempMax;
  final double tempMin;
  final double nivelDioxidoMax;
  final double nivelDioxidoMin;
  
  Grano({
    required this.idGrano,
    this.descripcion,
    required this.humedadMax,
    required this.humedadMin,
    required this.tempMax,
    required this.tempMin,
    required this.nivelDioxidoMax,
    required this.nivelDioxidoMin,
  });

  factory Grano.fromJson(Map<String, dynamic> json) {
    return Grano(
      idGrano: json['idGrano'] as int,
      descripcion: json['descripcion'] as String?,
      humedadMax: (json['humedadMax'] as num).toDouble(),
      humedadMin: (json['humedadMin'] as num).toDouble(),
      tempMax: (json['tempMax'] as num).toDouble(),
      tempMin: (json['tempMin'] as num).toDouble(),
      nivelDioxidoMax: (json['nivelDioxidoMax'] as num).toDouble(),
      nivelDioxidoMin: (json['nivelDioxidoMin'] as num).toDouble(),
    );
  }
}
