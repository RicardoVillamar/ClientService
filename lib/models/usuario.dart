enum TipoUsuario {
  empleado('Empleado'),
  administrador('Administrador');

  const TipoUsuario(this.displayName);
  final String displayName;

  static TipoUsuario fromString(String value) {
    switch (value.toLowerCase()) {
      case 'empleado':
        return TipoUsuario.empleado;
      case 'administrador':
        return TipoUsuario.administrador;
      default:
        return TipoUsuario.empleado;
    }
  }
}

class Usuario {
  final String? id;
  final String email;
  final String password;
  final TipoUsuario tipo;
  final String? empleadoId; // Solo para usuarios tipo empleado
  final String nombre;
  final String apellido;
  final bool activo;
  final DateTime fechaCreacion;
  final DateTime? ultimoAcceso;

  Usuario({
    this.id,
    required this.email,
    required this.password,
    required this.tipo,
    this.empleadoId,
    required this.nombre,
    required this.apellido,
    this.activo = true,
    required this.fechaCreacion,
    this.ultimoAcceso,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password, // En producción, esto debería estar hasheado
      'tipo': tipo.name,
      'empleadoId': empleadoId,
      'nombre': nombre,
      'apellido': apellido,
      'activo': activo,
      'fechaCreacion': fechaCreacion.toIso8601String(),
      'ultimoAcceso': ultimoAcceso?.toIso8601String(),
    };
  }

  factory Usuario.fromMap(Map<String, dynamic> map, String id) {
    return Usuario(
      id: id,
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      tipo: TipoUsuario.fromString(map['tipo'] ?? 'empleado'),
      empleadoId: map['empleadoId'],
      nombre: map['nombre'] ?? '',
      apellido: map['apellido'] ?? '',
      activo: map['activo'] ?? true,
      fechaCreacion:
          DateTime.tryParse(map['fechaCreacion'] ?? '') ?? DateTime.now(),
      ultimoAcceso: map['ultimoAcceso'] != null
          ? DateTime.tryParse(map['ultimoAcceso'])
          : null,
    );
  }

  String get nombreCompleto => '$nombre $apellido';

  bool get esAdministrador => tipo == TipoUsuario.administrador;
  bool get esEmpleado => tipo == TipoUsuario.empleado;

  Usuario copyWith({
    String? id,
    String? email,
    String? password,
    TipoUsuario? tipo,
    String? empleadoId,
    String? nombre,
    String? apellido,
    bool? activo,
    DateTime? fechaCreacion,
    DateTime? ultimoAcceso,
  }) {
    return Usuario(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      tipo: tipo ?? this.tipo,
      empleadoId: empleadoId ?? this.empleadoId,
      nombre: nombre ?? this.nombre,
      apellido: apellido ?? this.apellido,
      activo: activo ?? this.activo,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      ultimoAcceso: ultimoAcceso ?? this.ultimoAcceso,
    );
  }
}
