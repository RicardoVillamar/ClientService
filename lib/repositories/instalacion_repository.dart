import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/instalacion.dart';
import 'base_repository.dart';

class InstalacionRepository implements BaseRepository<Instalacion> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'instalaciones';

  @override
  Future<List<Instalacion>> getAll() async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .orderBy('fechaInstalacion', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => Instalacion.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener instalaciones: $e');
    }
  }

  @override
  Future<Instalacion?> getById(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      if (doc.exists && doc.data() != null) {
        return Instalacion.fromMap(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      throw Exception('Error al obtener instalación: $e');
    }
  }

  @override
  Future<String> create(Instalacion instalacion) async {
    try {
      final docRef =
          await _firestore.collection(_collection).add(instalacion.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Error al crear instalación: $e');
    }
  }

  @override
  Future<void> update(String id, Instalacion instalacion) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(id)
          .update(instalacion.toMap());
    } catch (e) {
      throw Exception('Error al actualizar instalación: $e');
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      throw Exception('Error al eliminar instalación: $e');
    }
  }

  @override
  Stream<List<Instalacion>> watchAll() {
    return _firestore
        .collection(_collection)
        .orderBy('fechaInstalacion', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Instalacion.fromMap(doc.data(), doc.id))
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
}
