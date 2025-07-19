// ...existing code...

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/empleado.dart';
import '../services/cloudinary_service.dart';
import 'base_repository.dart';

class EmpleadoRepository implements BaseRepository<Empleado> {
  Future<List<Empleado>> getAllEmpleadosNoAdmin() async {
    final empleados = await getAll();
    return empleados
        .where((e) => e.cargo != CargoEmpleado.administrador)
        .toList();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CloudinaryService _cloudinaryService = CloudinaryService();
  final String _collection = 'empleados';

  @override
  Future<List<Empleado>> getAll() async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .orderBy('fechaContratacion', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => Empleado.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener empleados: $e');
    }
  }

  @override
  Future<Empleado?> getById(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      if (doc.exists && doc.data() != null) {
        return Empleado.fromMap(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      throw Exception('Error al obtener empleado: $e');
    }
  }

  @override
  Future<String> create(Empleado empleado) async {
    try {
      final docRef =
          await _firestore.collection(_collection).add(empleado.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Error al crear empleado: $e');
    }
  }

  Future<String> createWithImage(Empleado empleado, File? imageFile) async {
    try {
      String? imageUrl;
      if (imageFile != null) {
        imageUrl = await _cloudinaryService.uploadImage(imageFile);
      }

      final empleadoData = empleado.toMap();
      empleadoData['fotoUrl'] = imageUrl ?? '';

      final docRef = await _firestore.collection(_collection).add(empleadoData);
      return docRef.id;
    } catch (e) {
      throw Exception('Error al crear empleado con imagen: $e');
    }
  }

  @override
  Future<void> update(String id, Empleado empleado) async {
    try {
      await _firestore.collection(_collection).doc(id).update(empleado.toMap());
    } catch (e) {
      throw Exception('Error al actualizar empleado: $e');
    }
  }

  Future<void> updateWithImage(
      String id, Empleado empleado, File? newImage) async {
    try {
      String? newUrl = empleado.fotoUrl;

      if (newImage != null) {
        // Si existe una imagen previa y vamos a subir una nueva, eliminar la anterior
        if (empleado.fotoUrl.isNotEmpty) {
          try {
            // Extraer public_id de la URL de Cloudinary
            final publicId = _extractPublicIdFromUrl(empleado.fotoUrl);
            if (publicId.isNotEmpty) {
              await _cloudinaryService.removeImage(publicId);
            }
          } catch (e) {
            // Ignorar error si la imagen no existe en Cloudinary
          }
        }
        newUrl = await _cloudinaryService.uploadImage(newImage);
      }

      final empleadoData = empleado.toMap();
      empleadoData['fotoUrl'] = newUrl;

      await _firestore.collection(_collection).doc(id).update(empleadoData);
    } catch (e) {
      throw Exception('Error al actualizar empleado con imagen: $e');
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      // Eliminar imagen de Cloudinary si existe
      final empleado = await getById(id);
      if (empleado != null && empleado.fotoUrl.isNotEmpty) {
        try {
          final publicId = _extractPublicIdFromUrl(empleado.fotoUrl);
          if (publicId.isNotEmpty) {
            await _cloudinaryService.removeImage(publicId);
          }
        } catch (e) {
          // Ignorar error si la imagen no existe
        }
      }

      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      throw Exception('Error al eliminar empleado: $e');
    }
  }

  @override
  Stream<List<Empleado>> watchAll() {
    return _firestore
        .collection(_collection)
        .orderBy('fechaContratacion', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Empleado.fromMap(doc.data(), doc.id))
            .toList());
  }

  /// Extrae el public_id de una URL de Cloudinary
  String _extractPublicIdFromUrl(String url) {
    try {
      // Ejemplo de URL: https://res.cloudinary.com/cloud_name/image/upload/v1234567890/empleados/filename.jpg
      final uri = Uri.parse(url);
      final pathSegments = uri.pathSegments;

      // Buscar el índice de 'upload' y obtener los segmentos después de la versión
      final uploadIndex = pathSegments.indexOf('upload');
      if (uploadIndex != -1 && uploadIndex + 2 < pathSegments.length) {
        // Omitir 'upload' y la versión (v1234567890), tomar el resto
        final publicIdParts = pathSegments.sublist(uploadIndex + 2);
        final publicIdWithExtension = publicIdParts.join('/');

        // Remover la extensión del archivo
        final lastDotIndex = publicIdWithExtension.lastIndexOf('.');
        if (lastDotIndex != -1) {
          return publicIdWithExtension.substring(0, lastDotIndex);
        }
        return publicIdWithExtension;
      }
      return '';
    } catch (e) {
      return '';
    }
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

  /// Obtener empleados filtrados por rango de fecha de contratación
  Future<List<Empleado>> getAllByDateRange({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      Query<Map<String, dynamic>> query = _firestore
          .collection(_collection)
          .orderBy('fechaContratacion', descending: true);

      if (startDate != null) {
        query =
            query.where('fechaContratacion', isGreaterThanOrEqualTo: startDate);
      }
      if (endDate != null) {
        // Agregar un día para incluir todo el día final
        final endOfDay =
            DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);
        query = query.where('fechaContratacion', isLessThanOrEqualTo: endOfDay);
      }

      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) => Empleado.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener empleados filtrados: $e');
    }
  }

  /// Obtener datos de empleados para exportar con filtro de fecha
  Future<List<Map<String, dynamic>>> getAllForExportWithDateFilter({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      Query<Map<String, dynamic>> query = _firestore.collection(_collection);

      if (startDate != null) {
        query =
            query.where('fechaContratacion', isGreaterThanOrEqualTo: startDate);
      }
      if (endDate != null) {
        final endOfDay =
            DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);
        query = query.where('fechaContratacion', isLessThanOrEqualTo: endOfDay);
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
