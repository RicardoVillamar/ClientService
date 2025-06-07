import 'package:client_service/models/vehiculo.dart';
import 'package:client_service/utils/excel_export_utility.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AlquilerViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Alquiler> _alquileres = [];
  List<Alquiler> get alquileres => _alquileres;

  // Obtener alquileres una vez
  Future<void> fetchAlquileres() async {
    try {
      final snapshot = await _firestore.collection('alquileres').get();
      _alquileres = snapshot.docs
          .map((doc) => Alquiler.fromMap(doc.data(), doc.id))
          .toList();
      notifyListeners();
    } catch (e) {
      print('Error al obtener alquileres: $e');
    }
  }

  // Obtener alquileres
  Future<List<Alquiler>> obtenerAlquileres() async {
    try {
      final snapshot = await _firestore.collection('alquileres').get();
      return snapshot.docs
          .map((doc) => Alquiler.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('Error al obtener alquileres: $e');
      return [];
    }
  }

  // Exportar alquileres a Excel
  Future<void> exportAlquileres() async {
    try {
      await ExcelExportUtility.exportToExcel(
        collectionName: 'alquileres',
        headers: [
          'id',
          'Cliente',
          'Fecha Registro Reserva',
          'Fecha Trabajo',
          'Correo Cliente',
          'Teléfono Cliente',
          'Dirección Cliente',
          'Vehículo',
          'Monto Total',
          'Personal Asignado',
        ],
        mapper: (data) => [
          data['id'] ?? '',
          data['nombreComercial'] ?? '',
          data['fechaReserva']?.toDate()?.toString() ?? '',
          data['fechaTrabajo']?.toDate()?.toString() ?? '',
          data['correo'] ?? '',
          data['telefono'] ?? '',
          data['direccion'] ?? '',
          data['tipoVehiculo'] ?? '',
          data['montoAlquiler']?.toString() ?? '',
          data['personalAsistio'] ?? '',
        ],
        sheetName: 'Alquileres',
        fileName: 'reporte_alquileres.xlsx',
      );
    } catch (e) {
      print('Error al exportar alquileres: $e');
    }
  }

  // Guardar un nuevo alquiler
  Future<void> guardarAlquiler(Alquiler alquiler) async {
    await _firestore.collection('alquileres').add(alquiler.toMap());
  }

  // Escuchar cambios en tiempo real
  Stream<List<Alquiler>> escucharAlquileres() {
    return _firestore.collection('alquileres').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Alquiler.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  // Eliminar alquiler
  Future<void> eliminarAlquiler(String id) async {
    await _firestore.collection('alquileres').doc(id).delete();
  }

  // Actualizar alquiler
  Future<void> actualizarAlquiler(Alquiler alquiler) async {
    if (alquiler.id == null) throw Exception("Alquiler sin ID");
    await _firestore
        .collection('alquileres')
        .doc(alquiler.id)
        .update(alquiler.toMap());
  }
}
