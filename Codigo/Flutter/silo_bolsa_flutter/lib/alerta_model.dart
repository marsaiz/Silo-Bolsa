// Archivo: lib/alerta_model.dart

class Alerta {
  final String idAlerta;
  final DateTime fechaHoraAlerta;
  final String tipoAlerta;
  final String? descripcion;
  final String estadoAlerta;
  final String? idLectura;
  final String idSilo;
  
  Alerta({
    required this.idAlerta,
    required this.fechaHoraAlerta,
    required this.tipoAlerta,
    this.descripcion,
    required this.estadoAlerta,
    this.idLectura,
    required this.idSilo,
  });

  factory Alerta.fromJson(Map<String, dynamic> json) {
    return Alerta(
      idAlerta: json['idAlerta'] as String,
      fechaHoraAlerta: DateTime.parse(json['fechaHoraAlerta'] as String),
      tipoAlerta: json['tipoAlerta'] as String,
      descripcion: json['descripcion'] as String?,
      estadoAlerta: json['estadoAlerta'] as String,
      idLectura: json['idLectura'] as String?,
      idSilo: json['idSilo'] as String,
    );
  }
  
  // Método helper para obtener color según el tipo de alerta
  String getColorByType() {
    switch (tipoAlerta.toLowerCase()) {
      case 'temperatura':
        return 'red';
      case 'humedad':
        return 'blue';
      case 'co2':
      case 'dioxido de carbono':
        return 'green';
      default:
        return 'orange';
    }
  }
}
