import 'package:cloud_firestore/cloud_firestore.dart';

enum CargoEmpleado {
  tecnico('Técnico'),
  escavador('Escavador'),
  electricista('Electricista'),
  ayudante('Ayudante'),
  conductor('Conductor');

  const CargoEmpleado(this.displayName);
  final String displayName;

  static CargoEmpleado fromString(String value) {
    switch (value.toLowerCase()) {
      case 'técnico':
      case 'tecnico':
        return CargoEmpleado.tecnico;
      case 'escavador':
      case 'excavador':
        return CargoEmpleado.escavador;
      case 'electricista':
        return CargoEmpleado.electricista;
      case 'ayudante':
        return CargoEmpleado.ayudante;
      case 'conductor':
        return CargoEmpleado.conductor;
      default:
        return CargoEmpleado.tecnico; // Default fallback
    }
  }

  static List<String> get allDisplayNames =>
      CargoEmpleado.values.map((e) => e.displayName).toList();
}

class Empleado {
  final String? id;
  final String nombre;
  final String apellido;
  final String cedula;
  final String direccion;
  final String telefono;
  final String correo;
  final CargoEmpleado cargo;
  final DateTime fechaContratacion;
  final String fotoUrl;

  Empleado({
    this.id,
    required this.nombre,
    required this.apellido,
    required this.cedula,
    required this.direccion,
    required this.telefono,
    required this.correo,
    required this.cargo,
    required this.fechaContratacion,
    this.fotoUrl = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'apellido': apellido,
      'cedula': cedula,
      'direccion': direccion,
      'telefono': telefono,
      'correo': correo,
      'cargo': cargo.displayName,
      'fechaContratacion': fechaContratacion,
      'fotoUrl': fotoUrl,
    };
  }

  factory Empleado.fromMap(Map<String, dynamic> map, String id) {
    return Empleado(
      id: id,
      nombre: map['nombre'] ?? '',
      apellido: map['apellido'] ?? '',
      cedula: map['cedula'] ?? '',
      direccion: map['direccion'] ?? '',
      telefono: map['telefono'] ?? '',
      correo: map['correo'] ?? '',
      cargo: CargoEmpleado.fromString(map['cargo'] ?? ''),
      fechaContratacion: (map['fechaContratacion'] as Timestamp).toDate(),
      fotoUrl: map['fotoUrl'],
    );
  }

  String get cargoDisplayName => cargo.displayName;

  String get nombreCompleto => '$nombre $apellido';

  String get nombreCompletoConCargo => '$nombreCompleto - ${cargo.displayName}';
}
