import 'package:cloud_firestore/cloud_firestore.dart';

class Asistencia {
  final String id;
  final String cedula;
  final String? email;
  final String fecha; // Formato: yyyy-MM-dd
  final String horaEntrada; // Formato: HH:mm
  final String? horaSalida; // Formato: HH:mm o null si no ha salido
  final Timestamp timestamp;

  Asistencia({
    required this.id,
    required this.cedula,
    this.email,
    required this.fecha,
    required this.horaEntrada,
    this.horaSalida,
    required this.timestamp,
  });

  factory Asistencia.fromMap(Map<String, dynamic> map, String id) {
    return Asistencia(
      id: id,
      cedula: map['cedula'] ?? '',
      email: map['email'],
      fecha: map['fecha'] ?? '',
      horaEntrada: map['horaEntrada'] ?? '',
      horaSalida: map['horaSalida'],
      timestamp: map['timestamp'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cedula': cedula,
      'email': email,
      'fecha': fecha,
      'horaEntrada': horaEntrada,
      'horaSalida': horaSalida,
      'timestamp': timestamp,
    };
  }
}
