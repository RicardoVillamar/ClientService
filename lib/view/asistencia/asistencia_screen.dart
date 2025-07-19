import 'package:client_service/view/widgets/shared/button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:client_service/models/empleado.dart';

class AsistenciaScreen extends StatefulWidget {
  final Empleado empleado;
  const AsistenciaScreen({super.key, required this.empleado});

  @override
  State<AsistenciaScreen> createState() => _AsistenciaScreenState();
}

class _AsistenciaScreenState extends State<AsistenciaScreen> {
  String? _entrada;
  String? _salida;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchAsistenciaHoy();
  }

  Future<void> _fetchAsistenciaHoy() async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final query = await FirebaseFirestore.instance
        .collection('asistencias')
        .where('cedula', isEqualTo: widget.empleado.cedula)
        .where('fecha', isEqualTo: today)
        .get();
    String? entrada;
    String? salida;
    for (final doc in query.docs) {
      final data = doc.data();
      if (data['horaEntrada'] != null) entrada = data['horaEntrada'];
      if (data['horaSalida'] != null) salida = data['horaSalida'];
    }
    setState(() {
      _entrada = entrada;
      _salida = salida;
      _loading = false;
    });
  }

  Future<void> _marcarEntrada() async {
    final now = DateTime.now();
    final fecha = DateFormat('yyyy-MM-dd').format(now);
    final hora = DateFormat('HH:mm:ss').format(now);
    await FirebaseFirestore.instance.collection('asistencias').add({
      'cedula': widget.empleado.cedula,
      'email': widget.empleado.correo,
      'fecha': fecha,
      'horaEntrada': hora,
      'timestamp': now,
    });
    setState(() {
      _entrada = hora;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Entrada registrada'), backgroundColor: Colors.green),
    );
  }

  Future<void> _marcarSalida() async {
    final now = DateTime.now();
    final fecha = DateFormat('yyyy-MM-dd').format(now);
    final hora = DateFormat('HH:mm:ss').format(now);
    await FirebaseFirestore.instance.collection('asistencias').add({
      'cedula': widget.empleado.cedula,
      'email': widget.empleado.correo,
      'fecha': fecha,
      'horaSalida': hora,
      'timestamp': now,
    });
    setState(() {
      _salida = hora;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Salida registrada'), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fecha = DateFormat('dd/MM/yyyy').format(DateTime.now());
    final hora = DateFormat('hh:mm').format(DateTime.now());
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: _loading
            ? const CircularProgressIndicator()
            : Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_rounded),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Asistencia',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      hora,
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        letterSpacing: 2,
                      ),
                    ),
                    const Text(
                      'AM',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.calendar_today,
                              size: 18, color: Colors.grey),
                          const SizedBox(width: 8),
                          Text(
                            fecha.replaceAll('/', ' de '),
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    if (_entrada == null && _salida == null)
                      BtnElevated(
                        text: 'Marcar Entrada',
                        onPressed: () async {
                          await _marcarEntrada();
                          await _fetchAsistenciaHoy();
                        },
                      )
                    else if (_entrada != null && _salida == null)
                      BtnElevated(
                        text: 'Marcar Salida',
                        onPressed: () async {
                          await _marcarSalida();
                          await _fetchAsistenciaHoy();
                        },
                      )
                    else if (_entrada != null && _salida != null)
                      const Column(
                        children: [
                          Icon(Icons.check_circle,
                              color: Colors.green, size: 48),
                          SizedBox(height: 12),
                          Text(
                            '¡Asistencia completada!\nYa registraste tu entrada y salida de hoy.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.green,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    const SizedBox(height: 24),
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
