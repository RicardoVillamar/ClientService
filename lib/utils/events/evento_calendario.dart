import 'package:client_service/models/camara.dart';
import 'package:client_service/models/instalacion.dart';
import 'package:client_service/models/vehiculo.dart';

enum TipoServicio {
  camara('Mantenimiento de Cámara'),
  instalacion('Instalación de Postes'),
  alquiler('Alquiler de Vehículo');

  const TipoServicio(this.displayName);
  final String displayName;
}

class EventoCalendario {
  final String id;
  final String titulo;
  final String descripcion;
  final DateTime fecha;
  final String horaInicio;
  final String? horaFin;
  final TipoServicio tipo;
  final String estado;
  final String? direccion;
  final String? tecnico;
  final dynamic servicioOriginal; // Camara, Instalacion o Alquiler

  EventoCalendario({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.fecha,
    required this.horaInicio,
    this.horaFin,
    required this.tipo,
    required this.estado,
    this.direccion,
    this.tecnico,
    this.servicioOriginal,
  });

  // Factory para crear desde Camara
  factory EventoCalendario.fromCamara(Camara camara) {
    return EventoCalendario(
      id: camara.id ?? '',
      titulo: 'Mantenimiento - ${camara.nombreComercial}',
      descripcion: camara.descripcion,
      fecha: camara.fechaMantenimiento,
      horaInicio: '08:00', // Hora por defecto
      tipo: TipoServicio.camara,
      estado: camara.estado.displayName,
      direccion: camara.direccion,
      tecnico: camara.tecnico,
      servicioOriginal: camara,
    );
  }

  // Factory para crear desde Instalacion
  factory EventoCalendario.fromInstalacion(Instalacion instalacion) {
    return EventoCalendario(
      id: instalacion.id ?? '',
      titulo: 'Instalación - ${instalacion.nombreComercial}',
      descripcion: instalacion.descripcion,
      fecha: instalacion.fechaInstalacion,
      horaInicio: instalacion.horaInicio,
      horaFin: instalacion.horaFin,
      tipo: TipoServicio.instalacion,
      estado: instalacion.estado.displayName,
      direccion: instalacion.direccion,
      tecnico: instalacion.cargoPuesto,
      servicioOriginal: instalacion,
    );
  }

  // Factory para crear desde Alquiler
  factory EventoCalendario.fromAlquiler(Alquiler alquiler) {
    return EventoCalendario(
      id: alquiler.id ?? '',
      titulo: 'Alquiler - ${alquiler.nombreComercial}',
      descripcion: 'Vehículo: ${alquiler.tipoVehiculo}',
      fecha: alquiler.fechaTrabajo,
      horaInicio: '08:00', // Hora por defecto
      tipo: TipoServicio.alquiler,
      estado: alquiler.estado.displayName,
      direccion: alquiler.direccion,
      tecnico: alquiler.personalAsistio,
      servicioOriginal: alquiler,
    );
  }

  // Obtener color según el tipo de servicio
  String get colorHex {
    switch (tipo) {
      case TipoServicio.camara:
        return '#4CAF50'; // Verde
      case TipoServicio.instalacion:
        return '#2196F3'; // Azul
      case TipoServicio.alquiler:
        return '#FF9800'; // Naranja
    }
  }

  // Obtener color según el estado
  String get estadoColorHex {
    switch (estado.toLowerCase()) {
      case 'pendiente':
        return '#FF9800'; // Naranja
      case 'en proceso':
      case 'enproceso':
        return '#2196F3'; // Azul
      case 'completado':
        return '#4CAF50'; // Verde
      case 'cancelado':
        return '#F44336'; // Rojo
      default:
        return '#9E9E9E'; // Gris
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventoCalendario &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
