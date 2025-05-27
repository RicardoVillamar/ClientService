class Cliente {
  final String? id;
  final String nombreComercial;
  final String ruc;
  final String direccion;
  final String telefono;
  final String correo;
  final String personaContacto;
  final String cedula;

  Cliente({
    this.id,
    required this.nombreComercial,
    required this.ruc,
    required this.direccion,
    required this.telefono,
    required this.correo,
    required this.personaContacto,
    required this.cedula,
  });

  Map<String, dynamic> toMap() {
    return {
      'nombre_comercial': nombreComercial,
      'ruc': ruc,
      'direccion': direccion,
      'telefono': telefono,
      'correo': correo,
      'persona_contacto': personaContacto,
      'cedula': cedula,
    };
  }

  factory Cliente.fromMap(Map<String, dynamic> map, String id) {
    return Cliente(
      id: id,
      nombreComercial: map['nombre_comercial'] ?? '',
      ruc: map['ruc'] ?? '',
      direccion: map['direccion'] ?? '',
      telefono: map['telefono'] ?? '',
      correo: map['correo'] ?? '',
      personaContacto: map['persona_contacto'] ?? '',
      cedula: map['cedula'] ?? '',
    );
  }
}
