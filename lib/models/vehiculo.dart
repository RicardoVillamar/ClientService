enum EstadoAlquiler {
  pendiente('Pendiente'),
  enProceso('En Proceso'),
  completado('Completado'),
  cancelado('Cancelado');

  const EstadoAlquiler(this.displayName);
  final String displayName;

  static EstadoAlquiler fromString(String value) {
    switch (value.toLowerCase()) {
      case 'pendiente':
        return EstadoAlquiler.pendiente;
      case 'en proceso':
      case 'enproceso':
        return EstadoAlquiler.enProceso;
      case 'completado':
        return EstadoAlquiler.completado;
      case 'cancelado':
        return EstadoAlquiler.cancelado;
      default:
        return EstadoAlquiler.pendiente;
    }
  }

  static List<String> get allDisplayNames =>
      EstadoAlquiler.values.map((e) => e.displayName).toList();
}

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
  final EstadoAlquiler estado;
  final DateTime? fechaCancelacion;
  final String? motivoCancelacion;

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
    this.estado = EstadoAlquiler.pendiente,
    this.fechaCancelacion,
    this.motivoCancelacion,
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
      'estado': estado.displayName,
      'fechaCancelacion': fechaCancelacion?.toIso8601String(),
      'motivoCancelacion': motivoCancelacion,
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
      estado: EstadoAlquiler.fromString(map['estado'] ?? 'pendiente'),
      fechaCancelacion: map['fechaCancelacion'] != null
          ? DateTime.tryParse(map['fechaCancelacion'].toString())
          : null,
      motivoCancelacion: map['motivoCancelacion'],
    );
  }

  // Métodos de conveniencia
  bool get estaCancelado => estado == EstadoAlquiler.cancelado;
  bool get estaCompletado => estado == EstadoAlquiler.completado;
  bool get estaPendiente => estado == EstadoAlquiler.pendiente;
  bool get estaEnProceso => estado == EstadoAlquiler.enProceso;

  // Método para cancelar
  Alquiler cancelar(String motivo) {
    return Alquiler(
      id: id,
      nombreComercial: nombreComercial,
      direccion: direccion,
      telefono: telefono,
      correo: correo,
      tipoVehiculo: tipoVehiculo,
      fechaReserva: fechaReserva,
      fechaTrabajo: fechaTrabajo,
      montoAlquiler: montoAlquiler,
      personalAsistio: personalAsistio,
      estado: EstadoAlquiler.cancelado,
      fechaCancelacion: DateTime.now(),
      motivoCancelacion: motivo,
    );
  }

  // Método para retomar
  Alquiler retomar() {
    return Alquiler(
      id: id,
      nombreComercial: nombreComercial,
      direccion: direccion,
      telefono: telefono,
      correo: correo,
      tipoVehiculo: tipoVehiculo,
      fechaReserva: fechaReserva,
      fechaTrabajo: fechaTrabajo,
      montoAlquiler: montoAlquiler,
      personalAsistio: personalAsistio,
      estado: EstadoAlquiler.pendiente,
      fechaCancelacion: null,
      motivoCancelacion: null,
    );
  }
}
