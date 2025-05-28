class Alquiler {
  final String? id;
  final String nombreComercial;
  final String direccion;
  final String telefono;
  final String correo;
  final String tipoVehiculo;
  final DateTime fechaReserva;
  final DateTime fechaTrabajo;
  final double montoAlquiler;
  final String personalAsistio;

  Alquiler({
    this.id,
    required this.nombreComercial,
    required this.direccion,
    required this.telefono,
    required this.correo,
    required this.tipoVehiculo,
    required this.fechaReserva,
    required this.fechaTrabajo,
    required this.montoAlquiler,
    required this.personalAsistio,
  });

  Map<String, dynamic> toMap() {
    return {
      'nombreComercial': nombreComercial,
      'direccion': direccion,
      'telefono': telefono,
      'correo': correo,
      'tipoVehiculo': tipoVehiculo,
      'fechaReserva': fechaReserva.toIso8601String(),
      'fechaTrabajo': fechaTrabajo.toIso8601String(),
      'montoAlquiler': montoAlquiler,
      'personalAsistio': personalAsistio,
    };
  }

  factory Alquiler.fromMap(Map<String, dynamic> map, String id) {
    return Alquiler(
      id: id,
      nombreComercial: map['nombreComercial'] ?? '',
      direccion: map['direccion'] ?? '',
      telefono: map['telefono'] ?? '',
      correo: map['correo'] ?? '',
      tipoVehiculo: map['tipoVehiculo'] ?? '',
      fechaReserva: DateTime.parse(map['fechaReserva']),
      fechaTrabajo: DateTime.parse(map['fechaTrabajo']),
      montoAlquiler: map['montoAlquiler']?.toDouble() ?? 0.0,
      personalAsistio: map['personalAsistio'] ?? '',
    );
  }
}
