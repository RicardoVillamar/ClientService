import 'package:client_service/models/instalacion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class InstalacionViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Instalacion> _instalaciones = [];
  List<Instalacion> get instalaciones => _instalaciones;

  // Obtener instalaciones desde Firestore y actualizar lista local
  Future<void> fetchInstalaciones() async {
    try {
      final snapshot = await _firestore.collection('instalaciones').get();
      _instalaciones = snapshot.docs
          .map((doc) => Instalacion.fromMap(doc.data(), doc.id))
          .toList();
      notifyListeners();
    } catch (e) {
      print('Error al obtener instalaciones: $e');
    }
  }

  // Guardar una nueva instalacion
  Future<void> guardarInstalacion(Instalacion instalacion) async {
    try {
      final docRef =
          await _firestore.collection('instalaciones').add(instalacion.toMap());
      // Opcional: actualizar la lista local
      _instalaciones.add(Instalacion(
        id: docRef.id,
        fechaInstalacion: instalacion.fechaInstalacion,
        cedula: instalacion.cedula,
        nombreComercial: instalacion.nombreComercial,
        direccion: instalacion.direccion,
        item: instalacion.item,
        descripcion: instalacion.descripcion,
        horaInicio: instalacion.horaInicio,
        horaFin: instalacion.horaFin,
        tipoTrabajo: instalacion.tipoTrabajo,
        cargoPuesto: instalacion.cargoPuesto,
        telefono: instalacion.telefono,
        numeroTarea: instalacion.numeroTarea,
      ));
      notifyListeners();
    } catch (e) {
      print('Error al guardar instalación: $e');
    }
  }

  // Obtener todas las instalaciones (sin actualizar la lista local)
  Future<List<Instalacion>> obtenerInstalaciones() async {
    final snapshot = await _firestore.collection('instalaciones').get();
    return snapshot.docs
        .map((doc) => Instalacion.fromMap(doc.data(), doc.id))
        .toList();
  }

  // Escuchar instalaciones en tiempo real
  Stream<List<Instalacion>> escucharInstalaciones() {
    return _firestore.collection('instalaciones').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Instalacion.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  // Eliminar instalación por ID
  Future<void> eliminarInstalacion(String id) async {
    try {
      await _firestore.collection('instalaciones').doc(id).delete();
      // Quitar de la lista local si existe
      _instalaciones.removeWhere((inst) => inst.id == id);
      notifyListeners();
    } catch (e) {
      print('Error al eliminar instalación: $e');
    }
  }

  // Actualizar instalación
  Future<void> actualizarInstalacion(Instalacion instalacion) async {
    if (instalacion.id == null) {
      throw Exception('La instalación no tiene ID');
    }
    try {
      await _firestore
          .collection('instalaciones')
          .doc(instalacion.id)
          .update(instalacion.toMap());

      // Actualizar en la lista local
      final index =
          _instalaciones.indexWhere((inst) => inst.id == instalacion.id);
      if (index != -1) {
        _instalaciones[index] = instalacion;
        notifyListeners();
      }
    } catch (e) {
      print('Error al actualizar instalación: $e');
    }
  }
}
