import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AsistenciaScreen extends StatefulWidget {
  const AsistenciaScreen({super.key});

  @override
  State<AsistenciaScreen> createState() => _AsistenciaScreenState();
}

class _AsistenciaScreenState extends State<AsistenciaScreen> {
  String? _entrada;
  String? _salida;

  void _marcarEntrada() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final cedula = user.email?.split('@').first ?? '';
    final now = DateTime.now();
    final fecha = DateFormat('yyyy-MM-dd').format(now);
    final hora = DateFormat('HH:mm:ss').format(now);
    setState(() {
      _entrada = hora;
    });
    await FirebaseFirestore.instance.collection('asistencias').add({
      'cedula': cedula,
      'email': user.email,
      'fecha': fecha,
      'horaEntrada': hora,
      'timestamp': now,
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Entrada registrada'), backgroundColor: Colors.green),
    );
  }

  void _marcarSalida() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final cedula = user.email?.split('@').first ?? '';
    final now = DateTime.now();
    final fecha = DateFormat('yyyy-MM-dd').format(now);
    final hora = DateFormat('HH:mm:ss').format(now);
    setState(() {
      _salida = hora;
    });
    await FirebaseFirestore.instance.collection('asistencias').add({
      'cedula': cedula,
      'email': user.email,
      'fecha': fecha,
      'horaSalida': hora,
      'timestamp': now,
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Salida registrada'), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fecha = DateFormat('dd/MM/yyyy').format(DateTime.now());
    final hora = DateFormat('HH:mm:ss').format(DateTime.now());
    return Scaffold(
      appBar: AppBar(title: const Text('Asistencia')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Fecha: $fecha', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              Text('Hora actual: $hora', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _marcarEntrada,
                child: const Text('Marcar Entrada'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _marcarSalida,
                child: const Text('Marcar Salida'),
              ),
              const SizedBox(height: 32),
              if (_entrada != null)
                Text('Entrada marcada a las: $_entrada',
                    style: const TextStyle(color: Colors.green)),
              if (_salida != null)
                Text('Salida marcada a las: $_salida',
                    style: const TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ),
    );
  }
}
