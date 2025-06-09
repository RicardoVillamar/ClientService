import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/cliente.dart';
import 'base_repository.dart';

class ClienteRepository implements BaseRepository<Cliente> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'clientes';

  @override
  Future<List<Cliente>> getAll() async {
    try {
      final snapshot = await _firestore.collection(_collection).get();
      return snapshot.docs
          .map((doc) => Cliente.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener clientes: $e');
    }
  }

  @override
  Future<Cliente?> getById(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      if (doc.exists && doc.data() != null) {
        return Cliente.fromMap(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      throw Exception('Error al obtener cliente: $e');
    }
  }

  @override
  Future<String> create(Cliente cliente) async {
    try {
      final docRef =
          await _firestore.collection(_collection).add(cliente.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Error al crear cliente: $e');
    }
  }

  @override
  Future<void> update(String id, Cliente cliente) async {
    try {
      await _firestore.collection(_collection).doc(id).update(cliente.toMap());
    } catch (e) {
      throw Exception('Error al actualizar cliente: $e');
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      throw Exception('Error al eliminar cliente: $e');
    }
  }

  @override
  Stream<List<Cliente>> watchAll() {
    return _firestore.collection(_collection).snapshots().map((snapshot) =>
        snapshot.docs
            .map((doc) => Cliente.fromMap(doc.data(), doc.id))
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
