class NotificacionSistema {
  final String id;
  final String titulo;
  final String mensaje;
  final DateTime fechaCreacion;
  final TipoNotificacion tipo;
  final PrioridadNotificacion prioridad;
  final String? accion; // ID de la acción a realizar al tocar
  final Map<String, dynamic>? datos; // Datos adicionales
  bool leida;
  bool mostrada; // Si ya se mostró como notificación flash

  NotificacionSistema({
    required this.id,
    required this.titulo,
    required this.mensaje,
    required this.fechaCreacion,
    required this.tipo,
    required this.prioridad,
    this.accion,
    this.datos,
    this.leida = false,
    this.mostrada = false,
  });

  factory NotificacionSistema.fromJson(Map<String, dynamic> json) {
    return NotificacionSistema(
      id: json['id'],
      titulo: json['titulo'],
      mensaje: json['mensaje'],
      fechaCreacion: DateTime.parse(json['fechaCreacion']),
      tipo: TipoNotificacion.values.firstWhere(
        (e) => e.name == json['tipo'],
        orElse: () => TipoNotificacion.sistema,
      ),
      prioridad: PrioridadNotificacion.values.firstWhere(
        (e) => e.name == json['prioridad'],
        orElse: () => PrioridadNotificacion.media,
      ),
      accion: json['accion'],
      datos: json['datos'],
      leida: json['leida'] ?? false,
      mostrada: json['mostrada'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'mensaje': mensaje,
      'fechaCreacion': fechaCreacion.toIso8601String(),
      'tipo': tipo.name,
      'prioridad': prioridad.name,
      'accion': accion,
      'datos': datos,
      'leida': leida,
      'mostrada': mostrada,
    };
  }

  NotificacionSistema copyWith({
    String? id,
    String? titulo,
    String? mensaje,
    DateTime? fechaCreacion,
    TipoNotificacion? tipo,
    PrioridadNotificacion? prioridad,
    String? accion,
    Map<String, dynamic>? datos,
    bool? leida,
    bool? mostrada,
  }) {
    return NotificacionSistema(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      mensaje: mensaje ?? this.mensaje,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      tipo: tipo ?? this.tipo,
      prioridad: prioridad ?? this.prioridad,
      accion: accion ?? this.accion,
      datos: datos ?? this.datos,
      leida: leida ?? this.leida,
      mostrada: mostrada ?? this.mostrada,
    );
  }
}

enum TipoNotificacion {
  sistema('Sistema'),
  servicio('Servicio'),
  mantenimiento('Mantenimiento'),
  facturacion('Facturación'),
  recordatorio('Recordatorio'),
  error('Error'),
  exito('Éxito');

  const TipoNotificacion(this.displayName);
  final String displayName;
}

enum PrioridadNotificacion {
  baja('Baja'),
  media('Media'),
  alta('Alta'),
  critica('Crítica');

  const PrioridadNotificacion(this.displayName);
  final String displayName;
}
