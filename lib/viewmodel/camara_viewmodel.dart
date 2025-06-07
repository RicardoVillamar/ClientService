import 'package:client_service/models/camara.dart';
import 'package:client_service/utils/excel_export_utility.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CamaraViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'camaras';

  // Guardar nuevo registro
  Future<void> guardarCamara(Camara camara) async {
    await _firestore.collection(_collection).add(camara.toMap());
  }

  // Obtener lista de registros
  Future<List<Camara>> obtenerCamaras() async {
    final snapshot = await _firestore.collection(_collection).get();
    return snapshot.docs
        .map((doc) => Camara.fromMap(doc.data(), doc.id))
        .toList();
  }

  // exportar a Excel
  Future<void> exportarCamaras() async {
    await ExcelExportUtility.exportToExcel(
      collectionName: _collection,
      headers: [
        'id',
        'Nombre Comercial',
        'Fecha Mantenimiento',
        'Dirección',
        'Técnico',
        'Tipo',
        'Descripción',
        'Costo',
      ],
      mapper: (data) => [
        data['id'] ?? '',
        data['nombreComercial'] ?? '',
        data['fechaMantenimiento'] is Timestamp
            ? (data['fechaMantenimiento'] as Timestamp)
                .toDate()
                .toIso8601String()
            : data['fechaMantenimiento']?.toString() ?? '',
        data['direccion'] ?? '',
        data['tecnico'] ?? '',
        data['tipo'] ?? '',
        data['descripcion'] ?? '',
        (data['costo'] is int
                ? (data['costo'] as int).toDouble()
                : (data['costo'] is double
                    ? data['costo']
                    : double.tryParse(data['costo'].toString()) ?? 0.0))
            .toString(),
      ],
      sheetName: 'Camaras',
      fileName: 'reporte_camaras.xlsx',
    );
  }

  // Escuchar en tiempo real
  Stream<List<Camara>> escucharCamaras() {
    return _firestore.collection(_collection).snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Camara.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  // Actualizar registro
  Future<void> actualizarCamara(Camara camara) async {
    if (camara.id == null) throw Exception('ID requerido');
    await _firestore
        .collection(_collection)
        .doc(camara.id)
        .update(camara.toMap());
  }

  // Eliminar registro
  Future<void> eliminarCamara(String id) async {
    await _firestore.collection(_collection).doc(id).delete();
  }
}
