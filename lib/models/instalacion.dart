import 'package:cloud_firestore/cloud_firestore.dart';

enum EstadoInstalacion {
  pendiente('Pendiente'),
  enProceso('En Proceso'),
  completado('Completado'),
  cancelado('Cancelado');

  const EstadoInstalacion(this.displayName);
  final String displayName;

  static EstadoInstalacion fromString(String value) {
    switch (value.toLowerCase()) {
      case 'pendiente':
        return EstadoInstalacion.pendiente;
      case 'en proceso':
      case 'enproceso':
        return EstadoInstalacion.enProceso;
      case 'completado':
        return EstadoInstalacion.completado;
      case 'cancelado':
        return EstadoInstalacion.cancelado;
      default:
        return EstadoInstalacion.pendiente;
    }
  }

  static List<String> get allDisplayNames =>
      EstadoInstalacion.values.map((e) => e.displayName).toList();
}

class Instalacion {
  final String? id;
  final DateTime fechaInstalacion;
  final String cedula;
  final String nombreComercial;
  final String direccion;
  final String item;
  final String descripcion;
  final String horaInicio;
  final String horaFin;
  final String tipoTrabajo;
  final String cargoPuesto;
  final String telefono;
  final String numeroTarea;
  final EstadoInstalacion estado;
  final DateTime? fechaCancelacion;
  final String? motivoCancelacion;

  Instalacion({
    this.id,
    required this.fechaInstalacion,
    required this.cedula,
    required this.nombreComercial,
    required this.direccion,
    required this.item,
    required this.descripcion,
    required this.horaInicio,
    required this.horaFin,
    required this.tipoTrabajo,
    required this.cargoPuesto,
    required this.telefono,
    required this.numeroTarea,
    this.estado = EstadoInstalacion.pendiente,
    this.fechaCancelacion,
    this.motivoCancelacion,
  });

  Map<String, dynamic> toMap() {
    return {
      'fechaInstalacion': Timestamp.fromDate(fechaInstalacion),
      'cedula': cedula,
      'nombreComercial': nombreComercial,
      'direccion': direccion,
      'item': item,
      'descripcion': descripcion,
      'horaInicio': horaInicio,
      'horaFin': horaFin,
      'tipoTrabajo': tipoTrabajo,
      'cargoPuesto': cargoPuesto,
      'telefono': telefono,
      'numeroTarea': numeroTarea,
      'estado': estado.displayName,
      'fechaCancelacion': fechaCancelacion != null
          ? Timestamp.fromDate(fechaCancelacion!)
          : null,
      'motivoCancelacion': motivoCancelacion,
    };
  }

  factory Instalacion.fromMap(Map<String, dynamic> map, String id) {
    return Instalacion(
      id: id,
      fechaInstalacion: map['fechaInstalacion'] is Timestamp
          ? (map['fechaInstalacion'] as Timestamp).toDate()
          : DateTime.tryParse(map['fechaInstalacion'].toString()) ??
              DateTime.now(),
      cedula: map['cedula'] ?? '',
      nombreComercial: map['nombreComercial'] ?? '',
      direccion: map['direccion'] ?? '',
      item: map['item'] ?? '',
      descripcion: map['descripcion'] ?? '',
      horaInicio: map['horaInicio'] ?? '',
      horaFin: map['horaFin'] ?? '',
      tipoTrabajo: map['tipoTrabajo'] ?? '',
      cargoPuesto: map['cargoPuesto'] ?? '',
      telefono: map['telefono'] ?? '',
      numeroTarea: map['numeroTarea'] ?? '',
      estado: EstadoInstalacion.fromString(map['estado'] ?? 'pendiente'),
      fechaCancelacion: map['fechaCancelacion'] != null
          ? (map['fechaCancelacion'] is Timestamp
              ? (map['fechaCancelacion'] as Timestamp).toDate()
              : DateTime.tryParse(map['fechaCancelacion'].toString()))
          : null,
      motivoCancelacion: map['motivoCancelacion'],
    );
  }

  // Métodos de conveniencia
  bool get estaCancelado => estado == EstadoInstalacion.cancelado;
  bool get estaCompletado => estado == EstadoInstalacion.completado;
  bool get estaPendiente => estado == EstadoInstalacion.pendiente;
  bool get estaEnProceso => estado == EstadoInstalacion.enProceso;

  // Método para cancelar
  Instalacion cancelar(String motivo) {
    return Instalacion(
      id: id,
      fechaInstalacion: fechaInstalacion,
      cedula: cedula,
      nombreComercial: nombreComercial,
      direccion: direccion,
      item: item,
      descripcion: descripcion,
      horaInicio: horaInicio,
      horaFin: horaFin,
      tipoTrabajo: tipoTrabajo,
      cargoPuesto: cargoPuesto,
      telefono: telefono,
      numeroTarea: numeroTarea,
      estado: EstadoInstalacion.cancelado,
      fechaCancelacion: DateTime.now(),
      motivoCancelacion: motivo,
    );
  }

  // Método para retomar
  Instalacion retomar() {
    return Instalacion(
      id: id,
      fechaInstalacion: fechaInstalacion,
      cedula: cedula,
      nombreComercial: nombreComercial,
      direccion: direccion,
      item: item,
      descripcion: descripcion,
      horaInicio: horaInicio,
      horaFin: horaFin,
      tipoTrabajo: tipoTrabajo,
      cargoPuesto: cargoPuesto,
      telefono: telefono,
      numeroTarea: numeroTarea,
      estado: EstadoInstalacion.pendiente,
      fechaCancelacion: null,
      motivoCancelacion: null,
    );
  }
}
