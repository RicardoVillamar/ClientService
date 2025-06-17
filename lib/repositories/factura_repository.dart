import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:client_service/models/factura.dart';
import 'package:client_service/repositories/base_repository.dart';

class FacturaRepository implements BaseRepository<Factura> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'facturas';

  @override
  Future<List<Factura>> getAll() async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .orderBy('fechaCreacion', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => Factura.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener facturas: $e');
    }
  }

  @override
  Future<Factura?> getById(String id) async {
    try {
      final docSnapshot =
          await _firestore.collection(_collection).doc(id).get();

      if (docSnapshot.exists) {
        return Factura.fromMap(docSnapshot.data()!, docSnapshot.id);
      }
      return null;
    } catch (e) {
      throw Exception('Error al obtener factura por ID: $e');
    }
  }

  @override
  Future<String> create(Factura factura) async {
    try {
      final docRef =
          await _firestore.collection(_collection).add(factura.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Error al crear factura: $e');
    }
  }

  @override
  Future<void> update(String id, Factura factura) async {
    try {
      await _firestore.collection(_collection).doc(id).update(factura.toMap());
    } catch (e) {
      throw Exception('Error al actualizar factura: $e');
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      throw Exception('Error al eliminar factura: $e');
    }
  }

  @override
  Stream<List<Factura>> watchAll() {
    return _firestore
        .collection(_collection)
        .orderBy('fechaCreacion', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Factura.fromMap(doc.data(), doc.id))
            .toList());
  }

  // Métodos específicos para facturación

  /// Obtener facturas por cliente
  Future<List<Factura>> getByClienteId(String clienteId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('clienteId', isEqualTo: clienteId)
          .orderBy('fechaCreacion', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => Factura.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener facturas por cliente: $e');
    }
  }

  /// Obtener facturas por tipo de servicio
  Future<List<Factura>> getByTipoServicio(TipoServicio tipoServicio) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('tipoServicio', isEqualTo: tipoServicio.name)
          .orderBy('fechaCreacion', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => Factura.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener facturas por tipo de servicio: $e');
    }
  }

  /// Obtener facturas por estado
  Future<List<Factura>> getByEstado(EstadoFactura estado) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('estado', isEqualTo: estado.name)
          .orderBy('fechaCreacion', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => Factura.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener facturas por estado: $e');
    }
  }

  /// Obtener facturas por rango de fechas
  Future<List<Factura>> getByFechaRange({
    DateTime? fechaInicio,
    DateTime? fechaFin,
  }) async {
    try {
      Query query = _firestore.collection(_collection);

      if (fechaInicio != null) {
        query = query.where('fechaEmision',
            isGreaterThanOrEqualTo: Timestamp.fromDate(fechaInicio));
      }

      if (fechaFin != null) {
        query = query.where('fechaEmision',
            isLessThanOrEqualTo: Timestamp.fromDate(fechaFin));
      }

      query = query.orderBy('fechaEmision', descending: true);

      final querySnapshot = await query.get();

      return querySnapshot.docs
          .map((doc) =>
              Factura.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener facturas por rango de fechas: $e');
    }
  }

  /// Obtener facturas vencidas
  Future<List<Factura>> getFacturasVencidas() async {
    try {
      final ahora = DateTime.now();
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('fechaVencimiento', isLessThan: Timestamp.fromDate(ahora))
          .where('estado', isEqualTo: EstadoFactura.pendiente.name)
          .orderBy('fechaVencimiento', descending: false)
          .get();

      return querySnapshot.docs
          .map((doc) => Factura.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener facturas vencidas: $e');
    }
  }

  /// Generar número de factura único
  Future<String> generateNumeroFactura() async {
    try {
      final year = DateTime.now().year;
      final prefix = 'FAC-$year-';

      // Buscar el último número de factura del año
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('numeroFactura', isGreaterThanOrEqualTo: prefix)
          .where('numeroFactura', isLessThan: '${prefix}Z')
          .orderBy('numeroFactura', descending: true)
          .limit(1)
          .get();

      int nextNumber = 1;
      if (querySnapshot.docs.isNotEmpty) {
        final lastFactura = querySnapshot.docs.first.data();
        final lastNumero = lastFactura['numeroFactura'] as String;
        final lastNumberPart = lastNumero.split('-').last;
        nextNumber = int.parse(lastNumberPart) + 1;
      }

      return '$prefix${nextNumber.toString().padLeft(6, '0')}';
    } catch (e) {
      throw Exception('Error al generar número de factura: $e');
    }
  }

  /// Actualizar estado de factura
  Future<void> updateEstado(String id, EstadoFactura nuevoEstado) async {
    try {
      await _firestore.collection(_collection).doc(id).update({
        'estado': nuevoEstado.name,
      });
    } catch (e) {
      throw Exception('Error al actualizar estado de factura: $e');
    }
  }

  /// Obtener estadísticas de facturación
  Future<Map<String, dynamic>> getEstadisticas({
    DateTime? fechaInicio,
    DateTime? fechaFin,
  }) async {
    try {
      Query query = _firestore.collection(_collection);

      if (fechaInicio != null) {
        query = query.where('fechaEmision',
            isGreaterThanOrEqualTo: Timestamp.fromDate(fechaInicio));
      }

      if (fechaFin != null) {
        query = query.where('fechaEmision',
            isLessThanOrEqualTo: Timestamp.fromDate(fechaFin));
      }

      final querySnapshot = await query.get();
      final facturas = querySnapshot.docs
          .map((doc) =>
              Factura.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();

      double totalFacturado = 0;
      double totalPendiente = 0;
      double totalPagado = 0;
      int totalFacturas = facturas.length;
      int facturasPendientes = 0;
      int facturasPagadas = 0;
      int facturasVencidas = 0;

      final ahora = DateTime.now();

      for (final factura in facturas) {
        totalFacturado += factura.total;

        switch (factura.estado) {
          case EstadoFactura.pendiente:
            totalPendiente += factura.total;
            facturasPendientes++;
            if (factura.fechaVencimiento.isBefore(ahora)) {
              facturasVencidas++;
            }
            break;
          case EstadoFactura.pagada:
            totalPagado += factura.total;
            facturasPagadas++;
            break;
          case EstadoFactura.vencida:
            totalPendiente += factura.total;
            facturasVencidas++;
            break;
          case EstadoFactura.cancelada:
            break;
        }
      }

      return {
        'totalFacturado': totalFacturado,
        'totalPendiente': totalPendiente,
        'totalPagado': totalPagado,
        'totalFacturas': totalFacturas,
        'facturasPendientes': facturasPendientes,
        'facturasPagadas': facturasPagadas,
        'facturasVencidas': facturasVencidas,
        'porcentajePago':
            totalFacturas > 0 ? (facturasPagadas / totalFacturas) * 100 : 0,
      };
    } catch (e) {
      throw Exception('Error al obtener estadísticas: $e');
    }
  }

  /// Obtener datos para exportar
  Future<List<Map<String, dynamic>>> getAllForExport({
    DateTime? fechaInicio,
    DateTime? fechaFin,
    EstadoFactura? estado,
    TipoServicio? tipoServicio,
  }) async {
    try {
      Query query = _firestore.collection(_collection);

      if (fechaInicio != null) {
        query = query.where('fechaEmision',
            isGreaterThanOrEqualTo: Timestamp.fromDate(fechaInicio));
      }

      if (fechaFin != null) {
        query = query.where('fechaEmision',
            isLessThanOrEqualTo: Timestamp.fromDate(fechaFin));
      }

      if (estado != null) {
        query = query.where('estado', isEqualTo: estado.name);
      }

      if (tipoServicio != null) {
        query = query.where('tipoServicio', isEqualTo: tipoServicio.name);
      }

      query = query.orderBy('fechaEmision', descending: true);

      final querySnapshot = await query.get();
      return querySnapshot.docs
          .map((doc) => {
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>,
              })
          .toList();
    } catch (e) {
      throw Exception('Error al obtener datos para exportar: $e');
    }
  }
}
