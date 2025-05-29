import 'package:cloud_firestore/cloud_firestore.dart';

class Camara {
  final String? id;
  final String nombreComercial;
  final DateTime fechaMantenimiento;
  final String direccion;
  final String tecnico;
  final String tipo;
  final String descripcion;
  final double costo;

  Camara({
    this.id,
    required this.nombreComercial,
    required this.fechaMantenimiento,
    required this.direccion,
    required this.tecnico,
    required this.tipo,
    required this.descripcion,
    required this.costo,
  });

  Map<String, dynamic> toMap() {
    return {
      'nombreComercial': nombreComercial,
      'fechaMantenimiento': fechaMantenimiento.toIso8601String(),
      'direccion': direccion,
      'tecnico': tecnico,
      'tipo': tipo,
      'descripcion': descripcion,
      'costo': costo,
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
      tipo: map['tipo'] ?? '',
      descripcion: map['descripcion'] ?? '',
      costo: map['costo'] is int
          ? (map['costo'] as int).toDouble()
          : (map['costo'] is double
              ? map['costo']
              : double.tryParse(map['costo'].toString()) ?? 0.0),
    );
  }
}
