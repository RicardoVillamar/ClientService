import 'dart:io';
import 'package:client_service/models/empleado.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:client_service/utils/excel_export_utility.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class EmpleadoViewmodel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  List<Empleado> _empleados = [];
  List<Empleado> get empleados => _empleados;

  // Obtener todos los empleados
  Future<void> fetchEmpleados() async {
    try {
      // obtener los datos de la colección 'empleados'
      final snapshot = await _firestore
          .collection('empleados')
          .orderBy('date', descending: true)
          .get();
      _empleados = snapshot.docs.map((doc) {
        return Empleado.fromMap(doc.data(), doc.id);
      }).toList();
      notifyListeners();
    } catch (e) {
      debugPrint("Error al obtener empleados: $e");
    }
  }

  Future<List<Empleado>> obtenerEmpleados() async {
    final snapshot = await _firestore.collection('empleados').get();
    return snapshot.docs
        .map((doc) => Empleado.fromMap(doc.data(), doc.id))
        .toList();
  }

  // Exportar empleados en excel
  Future<void> exportEmpleados() async {
    await ExcelExportUtility.exportToExcel(
        sheetName: 'Empleados',
        collectionName: 'empleados',
        fileName: 'reporte_empleados.xlsx',
        headers: [
          'Nombre',
          'Apellido',
          'Cédula',
          'Dirección',
          'Teléfono',
          'Correo',
          'Cargo',
          'Fecha Contratación',
          'Foto URL'
        ],
        mapper: (data) => [
              data['nombre'] ?? '',
              data['apellido'] ?? '',
              data['cedula'] ?? '',
              data['direccion'] ?? '',
              data['telefono'] ?? '',
              data['correo'] ?? '',
              data['cargo'] ?? '',
              data['fechaContratacion'] != null
                  ? (data['fechaContratacion'] as Timestamp)
                      .toDate()
                      .toIso8601String()
                  : '',
              data['fotoUrl'] ?? ''
            ]);
  }

  // Registrar nuevo empleado
  Future<void> agregarEmpleado(Empleado empleado, File? imageFile) async {
    try {
      String? imageUrl;
      if (imageFile != null) {
        final ref = _storage
            .ref()
            .child('empleados/${DateTime.now().millisecondsSinceEpoch}.jpg');
        await ref.putFile(imageFile);
        imageUrl = await ref.getDownloadURL();
      }

      final docRef = await _firestore.collection('empleados').add({
        ...empleado.toMap(),
        'fotoUrl': imageUrl ?? '',
      });

      final newEmpleado = Empleado(
        id: docRef.id,
        nombre: empleado.nombre,
        apellido: empleado.apellido,
        cedula: empleado.cedula,
        direccion: empleado.direccion,
        telefono: empleado.telefono,
        correo: empleado.correo,
        cargo: empleado.cargo,
        fechaContratacion: empleado.fechaContratacion,
        fotoUrl: imageUrl ?? '',
      );

      _empleados.add(newEmpleado);
      notifyListeners();
    } catch (e) {
      debugPrint("Error al agregar empleado: $e");
    }
  }

  // Actualizar empleado
  Future<void> actualizarEmpleado(Empleado empleado,
      {File? nuevaImagen}) async {
    try {
      String? nuevaUrl = empleado.fotoUrl;

      if (nuevaImagen != null) {
        final ref = _storage.ref().child('empleados/${empleado.id}.jpg');
        await ref.putFile(nuevaImagen);
        nuevaUrl = await ref.getDownloadURL();
      }

      final updatedEmpleado = Empleado(
        id: empleado.id,
        nombre: empleado.nombre,
        apellido: empleado.apellido,
        cedula: empleado.cedula,
        direccion: empleado.direccion,
        telefono: empleado.telefono,
        correo: empleado.correo,
        cargo: empleado.cargo,
        fechaContratacion: empleado.fechaContratacion,
        fotoUrl: nuevaUrl ?? '',
      );

      await _firestore
          .collection('empleados')
          .doc(empleado.id)
          .set(updatedEmpleado.toMap());

      final index = _empleados.indexWhere((e) => e.id == empleado.id);
      if (index != -1) {
        _empleados[index] = updatedEmpleado;
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error al actualizar empleado: $e");
    }
  }

  // Eliminar empleado
  Future<void> eliminarEmpleado(String id) async {
    try {
      await _firestore.collection('empleados').doc(id).delete();
      _empleados.removeWhere((e) => e.id == id);
      notifyListeners();
    } catch (e) {
      debugPrint("Error al eliminar empleado: $e");
    }
  }
}
