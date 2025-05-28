import 'package:cloud_firestore/cloud_firestore.dart';

class Empleado {
  final String? id;
  final String nombre;
  final String apellido;
  final String cedula;
  final String direccion;
  final String telefono;
  final String correo;
  final String cargo;
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
      'cargo': cargo,
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
      cargo: map['cargo'] ?? '',
      fechaContratacion: (map['fechaContratacion'] as Timestamp).toDate(),
      fotoUrl: map['fotoUrl'],
    );
  }
}
