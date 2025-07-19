import 'package:flutter/material.dart';
import 'package:client_service/models/empleado.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:client_service/utils/colors.dart';

class EmpleadoAsistenciasPage extends StatefulWidget {
  final Empleado empleado;
  final DateTime selectedMonth;
  const EmpleadoAsistenciasPage(
      {Key? key, required this.empleado, required this.selectedMonth})
      : super(key: key);

  @override
  State<EmpleadoAsistenciasPage> createState() =>
      _EmpleadoAsistenciasPageState();
}

class _EmpleadoAsistenciasPageState extends State<EmpleadoAsistenciasPage> {
  List<QueryDocumentSnapshot<Map<String, dynamic>>> _asistencias = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchAsistencias();
  }

  Future<void> _fetchAsistencias() async {
    setState(() => _loading = true);
    final cedula = widget.empleado.cedula.trim();
    final start =
        DateTime(widget.selectedMonth.year, widget.selectedMonth.month, 1);
    final end =
        DateTime(widget.selectedMonth.year, widget.selectedMonth.month + 1, 1);
    try {
      final query = await FirebaseFirestore.instance
          .collection('asistencias')
          .where('cedula', isEqualTo: cedula)
          .get();
      final docsFiltrados = query.docs.where((doc) {
        final data = doc.data();
        final ts = data['timestamp'];
        if (ts is Timestamp) {
          final dt = ts.toDate();
          return dt.isAfter(start.subtract(const Duration(seconds: 1))) &&
              dt.isBefore(end);
        }
        return false;
      }).toList();
      docsFiltrados.sort((a, b) {
        final ta = a.data()['timestamp'] as Timestamp?;
        final tb = b.data()['timestamp'] as Timestamp?;
        if (ta == null || tb == null) return 0;
        return tb.compareTo(ta); // descending
      });
      setState(() {
        _asistencias = docsFiltrados;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _asistencias = [];
        _loading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error al cargar asistencias: $e'),
              backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final monthLabel =
        DateFormat('MMMM yyyy', 'es_ES').format(widget.selectedMonth);
    return Scaffold(
      appBar: AppBar(
        title: Text('Asistencias de ${widget.empleado.nombreCompleto}'),
        backgroundColor: AppColors.primaryColor,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _asistencias.isEmpty
              ? const Center(
                  child: Text('No hay asistencias registradas para este mes.'))
              : ListView(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  children: _asistencias.map((doc) {
                    final data = doc.data();
                    final fecha = (data['fecha'] ?? '').toString();
                    final entrada = (data['horaEntrada'] ?? '-').toString();
                    final salida = (data['horaSalida'] ?? '-').toString();
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      child: ListTile(
                        title: Text(
                            'Fecha: ${fecha.isNotEmpty ? fecha : 'Desconocida'}'),
                        subtitle: Row(
                          children: [
                            const Icon(Icons.login,
                                size: 16, color: Colors.green),
                            Text(
                                ' Entrada: ${entrada.isNotEmpty ? entrada : '-'}'),
                            const SizedBox(width: 16),
                            const Icon(Icons.logout,
                                size: 16, color: Colors.red),
                            Text(
                                ' Salida: ${salida.isNotEmpty ? salida : '-'}'),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
    );
  }
}
