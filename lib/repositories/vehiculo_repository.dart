import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/vehiculo.dart';
import 'base_repository.dart';

class VehiculoRepository implements BaseRepository<Alquiler> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'alquileres';

  @override
  Future<List<Alquiler>> getAll() async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .orderBy('fechaReserva', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => Alquiler.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener alquileres: $e');
    }
  }

  @override
  Future<Alquiler?> getById(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      if (doc.exists && doc.data() != null) {
        return Alquiler.fromMap(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      throw Exception('Error al obtener alquiler: $e');
    }
  }

  @override
  Future<String> create(Alquiler alquiler) async {
    try {
      final docRef =
          await _firestore.collection(_collection).add(alquiler.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Error al crear alquiler: $e');
    }
  }

  @override
  Future<void> update(String id, Alquiler alquiler) async {
    try {
      await _firestore.collection(_collection).doc(id).update(alquiler.toMap());
    } catch (e) {
      throw Exception('Error al actualizar alquiler: $e');
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      throw Exception('Error al eliminar alquiler: $e');
    }
  }

  @override
  Stream<List<Alquiler>> watchAll() {
    return _firestore
        .collection(_collection)
        .orderBy('fechaReserva', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Alquiler.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<List<Map<String, dynamic>>> getAllForExport() async {
    try {
      final snapshot = await _firestore.collection(_collection).get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      throw Exception('Error al obtener datos para exportar: $e');
    }
  }

  /// Obtener alquileres filtrados por rango de fecha de reserva
  Future<List<Alquiler>> getAllByReservaDateRange({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      Query<Map<String, dynamic>> query = _firestore
          .collection(_collection)
          .orderBy('fechaReserva', descending: true);

      if (startDate != null) {
        query = query.where('fechaReserva', isGreaterThanOrEqualTo: startDate);
      }
      if (endDate != null) {
        final endOfDay =
            DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);
        query = query.where('fechaReserva', isLessThanOrEqualTo: endOfDay);
      }

      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) => Alquiler.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception(
          'Error al obtener alquileres filtrados por fecha de reserva: $e');
    }
  }

  /// Obtener alquileres filtrados por rango de fecha de trabajo
  Future<List<Alquiler>> getAllByTrabajoDateRange({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      Query<Map<String, dynamic>> query = _firestore
          .collection(_collection)
          .orderBy('fechaTrabajo', descending: true);

      if (startDate != null) {
        query = query.where('fechaTrabajo', isGreaterThanOrEqualTo: startDate);
      }
      if (endDate != null) {
        final endOfDay =
            DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);
        query = query.where('fechaTrabajo', isLessThanOrEqualTo: endOfDay);
      }

      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) => Alquiler.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception(
          'Error al obtener alquileres filtrados por fecha de trabajo: $e');
    }
  }

  /// Obtener datos de alquileres para exportar con filtro de fecha de reserva
  Future<List<Map<String, dynamic>>> getAllForExportWithReservaDateFilter({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      Query<Map<String, dynamic>> query = _firestore.collection(_collection);

      if (startDate != null) {
        query = query.where('fechaReserva', isGreaterThanOrEqualTo: startDate);
      }
      if (endDate != null) {
        final endOfDay =
            DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);
        query = query.where('fechaReserva', isLessThanOrEqualTo: endOfDay);
      }

      final snapshot = await query.get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      throw Exception('Error al obtener datos para exportar: $e');
    }
  }

  /// Obtener datos de alquileres para exportar con filtro de fecha de trabajo
  Future<List<Map<String, dynamic>>> getAllForExportWithTrabajoDateFilter({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      Query<Map<String, dynamic>> query = _firestore.collection(_collection);

      if (startDate != null) {
        query = query.where('fechaTrabajo', isGreaterThanOrEqualTo: startDate);
      }
      if (endDate != null) {
        final endOfDay =
            DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);
        query = query.where('fechaTrabajo', isLessThanOrEqualTo: endOfDay);
      }

      final snapshot = await query.get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      throw Exception('Error al obtener datos para exportar: $e');
    }
  }
}
