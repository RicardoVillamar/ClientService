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
      fechaMantenimiento: DateTime.parse(map['fechaMantenimiento']),
      direccion: map['direccion'] ?? '',
      tecnico: map['tecnico'] ?? '',
      tipo: map['tipo'] ?? '',
      descripcion: map['descripcion'] ?? '',
      costo: (map['costo'] ?? 0).toDouble(),
    );
  }
}
