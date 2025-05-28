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
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fechaInstalacion': fechaInstalacion,
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
    };
  }

  factory Instalacion.fromMap(Map<String, dynamic> map, String id) {
    return Instalacion(
      id: id,
      fechaInstalacion: map['fechaInstalacion'],
      cedula: map['cedula'],
      nombreComercial: map['nombreComercial'],
      direccion: map['direccion'],
      item: map['item'],
      descripcion: map['descripcion'],
      horaInicio: map['horaInicio'],
      horaFin: map['horaFin'],
      tipoTrabajo: map['tipoTrabajo'],
      cargoPuesto: map['cargoPuesto'],
      telefono: map['telefono'],
      numeroTarea: map['numeroTarea'],
    );
  }
}
