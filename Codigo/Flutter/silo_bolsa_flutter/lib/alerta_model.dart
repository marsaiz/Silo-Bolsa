// Archivo: lib/alerta_model.dart

class Alerta {
  final String idAlerta;
  final DateTime fechaHoraAlerta;
  final String? mensaje;
  final String idSilo;
  final bool correoEnviado;
  
  Alerta({
    required this.idAlerta,
    required this.fechaHoraAlerta,
    this.mensaje,
    required this.idSilo,
    required this.correoEnviado,
  });

  factory Alerta.fromJson(Map<String, dynamic> json) {
    return Alerta(
      idAlerta: json['idAlerta'] as String,
      fechaHoraAlerta: DateTime.parse(json['fechaHoraAlerta'] as String),
      mensaje: json['mensaje'] as String?,
      idSilo: json['idSilo'] as String,
      correoEnviado: json['correoEnviado'] as bool,
    );
  }
  
  // Método helper para obtener tipo de alerta desde el mensaje
  String getTipoAlerta() {
    if (mensaje == null) return 'General';
    
    final mensajeLower = mensaje!.toLowerCase();
    if (mensajeLower.contains('temperatura') || mensajeLower.contains('temp')) {
      return 'Temperatura';
    } else if (mensajeLower.contains('humedad')) {
      return 'Humedad';
    } else if (mensajeLower.contains('co2') || mensajeLower.contains('dióxido') || mensajeLower.contains('dioxido')) {
      return 'CO2';
    }
    return 'General';
  }
  
  // Método helper para obtener color según el tipo de alerta
  String getColorByType() {
    final tipo = getTipoAlerta();
    switch (tipo) {
      case 'Temperatura':
        return 'red';
      case 'Humedad':
        return 'blue';
      case 'CO2':
        return 'green';
      default:
        return 'orange';
    }
  }
}
