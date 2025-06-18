import 'package:cloud_firestore/cloud_firestore.dart';

enum TipoServicio { camara, instalacion, vehiculo }

enum EstadoFactura { pendiente, pagada, cancelada, vencida }

class ItemFactura {
  final String descripcion;
  final int cantidad;
  final double precioUnitario;
  final double descuento; // Porcentaje de descuento (0-100)

  ItemFactura({
    required this.descripcion,
    required this.cantidad,
    required this.precioUnitario,
    this.descuento = 0.0,
  });

  double get subtotal => cantidad * precioUnitario;
  double get montoDescuento => subtotal * (descuento / 100);
  double get total => subtotal - montoDescuento;

  Map<String, dynamic> toMap() {
    return {
      'descripcion': descripcion,
      'cantidad': cantidad,
      'precioUnitario': precioUnitario,
      'descuento': descuento,
    };
  }

  factory ItemFactura.fromMap(Map<String, dynamic> map) {
    return ItemFactura(
      descripcion: map['descripcion'] ?? '',
      cantidad: map['cantidad'] ?? 1,
      precioUnitario: map['precioUnitario']?.toDouble() ?? 0.0,
      descuento: map['descuento']?.toDouble() ?? 0.0,
    );
  }
}

class Factura {
  final String? id;
  final String numeroFactura;
  final DateTime fechaEmision;
  final DateTime fechaVencimiento;
  final String clienteId;
  final String nombreCliente;
  final String direccionCliente;
  final String telefonoCliente;
  final String correoCliente;
  final TipoServicio tipoServicio;
  final String
      servicioId; // ID del servicio relacionado (cámara, instalación o vehículo)
  final List<ItemFactura> items;
  final double impuesto; // Porcentaje de impuesto (ej: 13% IVA)
  final EstadoFactura estado;
  final String? observaciones;
  final DateTime fechaCreacion;
  final String creadoPor;

  Factura({
    this.id,
    required this.numeroFactura,
    required this.fechaEmision,
    required this.fechaVencimiento,
    required this.clienteId,
    required this.nombreCliente,
    required this.direccionCliente,
    required this.telefonoCliente,
    required this.correoCliente,
    required this.tipoServicio,
    required this.servicioId,
    required this.items,
    this.impuesto = 13.0,
    this.estado = EstadoFactura.pendiente,
    this.observaciones,
    required this.fechaCreacion,
    required this.creadoPor,
  });

  // Cálculos
  double get subtotal => items.fold(0.0, (sum, item) => sum + item.subtotal);
  double get totalDescuentos =>
      items.fold(0.0, (sum, item) => sum + item.montoDescuento);
  double get baseImponible => subtotal - totalDescuentos;
  double get montoImpuesto => baseImponible * (impuesto / 100);
  double get total => baseImponible + montoImpuesto;

  Map<String, dynamic> toMap() {
    return {
      'numeroFactura': numeroFactura,
      'fechaEmision': Timestamp.fromDate(fechaEmision),
      'fechaVencimiento': Timestamp.fromDate(fechaVencimiento),
      'clienteId': clienteId,
      'nombreCliente': nombreCliente,
      'direccionCliente': direccionCliente,
      'telefonoCliente': telefonoCliente,
      'correoCliente': correoCliente,
      'tipoServicio': tipoServicio.name,
      'servicioId': servicioId,
      'items': items.map((item) => item.toMap()).toList(),
      'impuesto': impuesto,
      'estado': estado.name,
      'observaciones': observaciones,
      'fechaCreacion': Timestamp.fromDate(fechaCreacion),
      'creadoPor': creadoPor,
      'subtotal': subtotal,
      'totalDescuentos': totalDescuentos,
      'baseImponible': baseImponible,
      'montoImpuesto': montoImpuesto,
      'total': total,
    };
  }

  factory Factura.fromMap(Map<String, dynamic> map, String id) {
    return Factura(
      id: id,
      numeroFactura: map['numeroFactura'] ?? '',
      fechaEmision: map['fechaEmision'] is Timestamp
          ? (map['fechaEmision'] as Timestamp).toDate()
          : DateTime.tryParse(map['fechaEmision'].toString()) ?? DateTime.now(),
      fechaVencimiento: map['fechaVencimiento'] is Timestamp
          ? (map['fechaVencimiento'] as Timestamp).toDate()
          : DateTime.tryParse(map['fechaVencimiento'].toString()) ??
              DateTime.now(),
      clienteId: map['clienteId'] ?? '',
      nombreCliente: map['nombreCliente'] ?? '',
      direccionCliente: map['direccionCliente'] ?? '',
      telefonoCliente: map['telefonoCliente'] ?? '',
      correoCliente: map['correoCliente'] ?? '',
      tipoServicio: TipoServicio.values.firstWhere(
        (e) => e.name == map['tipoServicio'],
        orElse: () => TipoServicio.instalacion,
      ),
      servicioId: map['servicioId'] ?? '',
      items: (map['items'] as List<dynamic>?)
              ?.map((item) => ItemFactura.fromMap(item))
              .toList() ??
          [],
      impuesto: map['impuesto']?.toDouble() ?? 13.0,
      estado: EstadoFactura.values.firstWhere(
        (e) => e.name == map['estado'],
        orElse: () => EstadoFactura.pendiente,
      ),
      observaciones: map['observaciones'],
      fechaCreacion: map['fechaCreacion'] is Timestamp
          ? (map['fechaCreacion'] as Timestamp).toDate()
          : DateTime.tryParse(map['fechaCreacion'].toString()) ??
              DateTime.now(),
      creadoPor: map['creadoPor'] ?? '',
    );
  }

  Factura copyWith({
    String? id,
    String? numeroFactura,
    DateTime? fechaEmision,
    DateTime? fechaVencimiento,
    String? clienteId,
    String? nombreCliente,
    String? direccionCliente,
    String? telefonoCliente,
    String? correoCliente,
    TipoServicio? tipoServicio,
    String? servicioId,
    List<ItemFactura>? items,
    double? impuesto,
    EstadoFactura? estado,
    String? observaciones,
    DateTime? fechaCreacion,
    String? creadoPor,
  }) {
    return Factura(
      id: id ?? this.id,
      numeroFactura: numeroFactura ?? this.numeroFactura,
      fechaEmision: fechaEmision ?? this.fechaEmision,
      fechaVencimiento: fechaVencimiento ?? this.fechaVencimiento,
      clienteId: clienteId ?? this.clienteId,
      nombreCliente: nombreCliente ?? this.nombreCliente,
      direccionCliente: direccionCliente ?? this.direccionCliente,
      telefonoCliente: telefonoCliente ?? this.telefonoCliente,
      correoCliente: correoCliente ?? this.correoCliente,
      tipoServicio: tipoServicio ?? this.tipoServicio,
      servicioId: servicioId ?? this.servicioId,
      items: items ?? this.items,
      impuesto: impuesto ?? this.impuesto,
      estado: estado ?? this.estado,
      observaciones: observaciones ?? this.observaciones,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      creadoPor: creadoPor ?? this.creadoPor,
    );
  }
}
