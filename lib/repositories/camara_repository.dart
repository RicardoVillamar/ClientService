import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/camara.dart';
import 'base_repository.dart';

class CamaraRepository implements BaseRepository<Camara> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'camaras';

  @override
  Future<List<Camara>> getAll() async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .orderBy('fechaMantenimiento', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => Camara.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener cámaras: $e');
    }
  }

  @override
  Future<Camara?> getById(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      if (doc.exists && doc.data() != null) {
        return Camara.fromMap(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      throw Exception('Error al obtener cámara: $e');
    }
  }

  @override
  Future<String> create(Camara camara) async {
    try {
      final docRef =
          await _firestore.collection(_collection).add(camara.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Error al crear cámara: $e');
    }
  }

  @override
  Future<void> update(String id, Camara camara) async {
    try {
      await _firestore.collection(_collection).doc(id).update(camara.toMap());
    } catch (e) {
      throw Exception('Error al actualizar cámara: $e');
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      throw Exception('Error al eliminar cámara: $e');
    }
  }

  @override
  Stream<List<Camara>> watchAll() {
    return _firestore
        .collection(_collection)
        .orderBy('fechaMantenimiento', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Camara.fromMap(doc.data(), doc.id))
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
