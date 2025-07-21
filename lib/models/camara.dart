import 'package:cloud_firestore/cloud_firestore.dart';

enum EstadoCamara {
  pendiente('Pendiente'),
  enProceso('En Proceso'),
  completado('Completado'),
  cancelado('Cancelado');

  const EstadoCamara(this.displayName);
  final String displayName;

  static EstadoCamara fromString(String value) {
    switch (value.toLowerCase()) {
      case 'pendiente':
        return EstadoCamara.pendiente;
      case 'en proceso':
      case 'enproceso':
        return EstadoCamara.enProceso;
      case 'completado':
        return EstadoCamara.completado;
      case 'cancelado':
        return EstadoCamara.cancelado;
      default:
        return EstadoCamara.pendiente;
    }
  }

  static List<String> get allDisplayNames =>
      EstadoCamara.values.map((e) => e.displayName).toList();
}

class Camara {
  final String? id;
  final String nombreComercial;
  final DateTime fechaMantenimiento;
  final String direccion;
  final String tecnico;
  final String descripcion;
  final double costo;
  final EstadoCamara estado;
  final DateTime? fechaCancelacion;
  final String? motivoCancelacion;

  Camara({
    this.id,
    required this.nombreComercial,
    required this.fechaMantenimiento,
    required this.direccion,
    required this.tecnico,
    required this.descripcion,
    required this.costo,
    this.estado = EstadoCamara.pendiente,
    this.fechaCancelacion,
    this.motivoCancelacion,
  });

  Map<String, dynamic> toMap() {
    return {
      'nombreComercial': nombreComercial,
      'fechaMantenimiento': fechaMantenimiento.toIso8601String(),
      'direccion': direccion,
      'tecnico': tecnico,
      'descripcion': descripcion,
      'costo': costo,
      'estado': estado.displayName,
      'fechaCancelacion': fechaCancelacion?.toIso8601String(),
      'motivoCancelacion': motivoCancelacion,
    };
  }

  factory Camara.fromMap(Map<String, dynamic> map, String id) {
    return Camara(
      id: id,
      nombreComercial: map['nombreComercial'] ?? '',
      fechaMantenimiento: map['fechaMantenimiento'] is Timestamp
          ? (map['fechaMantenimiento'] as Timestamp).toDate()
          : DateTime.tryParse(map['fechaMantenimiento'].toString()) ??
              DateTime.now(),
      direccion: map['direccion'] ?? '',
      tecnico: map['tecnico'] ?? '',
      descripcion: map['descripcion'] ?? '',
      costo: map['costo'] is int
          ? (map['costo'] as int).toDouble()
          : (map['costo'] is double
              ? map['costo']
              : double.tryParse(map['costo'].toString()) ?? 0.0),
      estado: EstadoCamara.fromString(map['estado'] ?? 'pendiente'),
      fechaCancelacion: map['fechaCancelacion'] != null
          ? (map['fechaCancelacion'] is Timestamp
              ? (map['fechaCancelacion'] as Timestamp).toDate()
              : DateTime.tryParse(map['fechaCancelacion'].toString()))
          : null,
      motivoCancelacion: map['motivoCancelacion'],
    );
  }

  // Métodos de conveniencia
  bool get estaCancelado => estado == EstadoCamara.cancelado;
  bool get estaCompletado => estado == EstadoCamara.completado;
  bool get estaPendiente => estado == EstadoCamara.pendiente;
  bool get estaEnProceso => estado == EstadoCamara.enProceso;

  // Método para cancelar
  Camara cancelar(String motivo) {
    return Camara(
      id: id,
      nombreComercial: nombreComercial,
      fechaMantenimiento: fechaMantenimiento,
      direccion: direccion,
      tecnico: tecnico,
      descripcion: descripcion,
      costo: costo,
      estado: EstadoCamara.cancelado,
      fechaCancelacion: DateTime.now(),
      motivoCancelacion: motivo,
    );
  }

  // Método para retomar
  Camara retomar() {
    return Camara(
      id: id,
      nombreComercial: nombreComercial,
      fechaMantenimiento: fechaMantenimiento,
      direccion: direccion,
      tecnico: tecnico,
      descripcion: descripcion,
      costo: costo,
      estado: EstadoCamara.pendiente,
      fechaCancelacion: null,
      motivoCancelacion: null,
    );
  }
}
