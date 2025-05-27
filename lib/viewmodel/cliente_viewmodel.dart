import 'package:client_service/models/cliente.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ClienteViewModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> guardarCliente(Cliente cliente) async {
    await _firestore.collection('clientes').add(cliente.toMap());
  }
}
