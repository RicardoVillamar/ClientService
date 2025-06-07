import 'package:client_service/models/cliente.dart';
import 'package:client_service/utils/excel_export_utility.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ClienteViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Cliente> _clientes = [];
  List<Cliente> get clientes => _clientes;

  Future<void> fetchClientes() async {
    try {
      final snapshot = await _firestore.collection('clientes').get();
      _clientes = snapshot.docs.map((doc) {
        return Cliente.fromMap(doc.data(), doc.id);
      }).toList();
      notifyListeners();
    } catch (e) {
      print('Error al obtener clientes: $e');
    }
  }

  // Guardar un cliente
  Future<void> guardarCliente(Cliente cliente) async {
    await _firestore.collection('clientes').add(cliente.toMap());
  }

  // Obtener todos los clientes
  Future<List<Cliente>> obtenerClientes() async {
    final snapshot = await _firestore.collection('clientes').get();
    return snapshot.docs
        .map((doc) => Cliente.fromMap(doc.data(), doc.id))
        .toList();
  }

  // Exportar clientes a Excel
  Future<void> exportarClientes() async {
    await ExcelExportUtility.exportToExcel(
      collectionName: 'clientes',
      headers: [
        'ID',
        'Nombre Comercial',
        'Correo',
        'Teléfono',
        'Dirección',
        'Persona de Contacto',
        'Cedula',
      ],
      mapper: (data) => [
        data['id'] ?? '',
        data['nombreComercial'] ?? '',
        data['correo'] ?? '',
        data['telefono'] ?? '',
        data['direccion'] ?? '',
        data['personaContacto'] ?? '',
        data['cedula'] ?? '',
      ],
      sheetName: 'Clientes',
      fileName: 'reporte_clientes.xlsx',
    );
  }

  // Escuchar cambios en tiempo real
  Stream<List<Cliente>> escucharClientes() {
    return _firestore.collection('clientes').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Cliente.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  // Eliminar cliente por ID
  Future<void> eliminarCliente(String id) async {
    await _firestore.collection('clientes').doc(id).delete();
  }

  // Editar cliente
  Future<void> actualizarCliente(Cliente cliente) async {
    if (cliente.id == null) throw Exception("Cliente no tiene ID");
    await _firestore
        .collection('clientes')
        .doc(cliente.id)
        .update(cliente.toMap());
  }
}
