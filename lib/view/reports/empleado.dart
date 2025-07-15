import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:client_service/utils/excel_export_utility.dart';

class AsistenciasAdminScreen extends StatefulWidget {
  const AsistenciasAdminScreen({super.key});

  @override
  State<AsistenciasAdminScreen> createState() => _AsistenciasAdminScreenState();
}

class _AsistenciasAdminScreenState extends State<AsistenciasAdminScreen> {
  DateTime _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);
  List<QueryDocumentSnapshot<Map<String, dynamic>>> _asistencias = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchAsistencias();
  }

  Future<void> _fetchAsistencias() async {
    setState(() => _loading = true);
    final start = DateTime(_selectedMonth.year, _selectedMonth.month, 1);
    final end = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 1);
    final query = await FirebaseFirestore.instance
        .collection('asistencias')
        .where('timestamp', isGreaterThanOrEqualTo: start)
        .where('timestamp', isLessThan: end)
        .orderBy('timestamp', descending: true)
        .get();
    setState(() {
      _asistencias = query.docs;
      _loading = false;
    });
  }

  void _selectMonth(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedMonth,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDatePickerMode: DatePickerMode.year,
      helpText: 'Selecciona el mes',
      fieldLabelText: 'Mes',
      fieldHintText: 'Mes/Año',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.deepPurple,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedMonth = DateTime(picked.year, picked.month);
      });
      _fetchAsistencias();
    }
  }

  Future<void> _exportarAsistencias() async {
    try {
      final start = DateTime(_selectedMonth.year, _selectedMonth.month, 1);
      final end = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 1);
      final query = await FirebaseFirestore.instance
          .collection('asistencias')
          .where('timestamp', isGreaterThanOrEqualTo: start)
          .where('timestamp', isLessThan: end)
          .orderBy('timestamp', descending: false)
          .get();
      final docs = query.docs;
      if (docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('No hay asistencias para exportar'),
              backgroundColor: Colors.orange),
        );
        return;
      }
      // Agrupar por empleado
      final Map<String, List<Map<String, dynamic>>> asistenciasPorEmpleado = {};
      for (final doc in docs) {
        final data = doc.data();
        final cedula = data['cedula'] ?? 'Desconocido';
        asistenciasPorEmpleado.putIfAbsent(cedula, () => []).add(data);
      }
      // Crear Excel con una hoja por empleado
      await ExcelExportUtility.exportMultipleSheets(
        sheets: asistenciasPorEmpleado.entries.map((entry) {
          final cedula = entry.key;
          final asistencias = entry.value;
          return ExcelSheetData(
            sheetName: 'Empleado_$cedula',
            headers: ['Fecha', 'Hora Entrada', 'Hora Salida', 'Email'],
            rows: asistencias
                .map((a) => [
                      a['fecha'] ?? '',
                      a['horaEntrada'] ?? '',
                      a['horaSalida'] ?? '',
                      a['email'] ?? '',
                    ])
                .toList(),
          );
        }).toList(),
        fileName:
            'Asistencias_${_selectedMonth.month}_${_selectedMonth.year}.xlsx',
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Exportación exitosa'),
            backgroundColor: Colors.green),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error al exportar: $e'),
            backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final monthLabel = DateFormat('MMMM yyyy', 'es_ES').format(_selectedMonth);
    final grouped = <String, List<Map<String, dynamic>>>{};
    for (final doc in _asistencias) {
      final data = doc.data();
      final cedula = data['cedula'] ?? '';
      final fecha = data['fecha'] ?? '';
      final key = '$cedula|$fecha';
      grouped.putIfAbsent(key, () => []).add(data);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asistencias de Empleados'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () => _selectMonth(context),
            tooltip: 'Filtrar por mes',
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _exportarAsistencias,
            tooltip: 'Exportar a Excel',
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : grouped.isEmpty
              ? const Center(
                  child: Text('No hay asistencias registradas para este mes.'))
              : ListView(
                  children: grouped.entries.map((entry) {
                    final parts = entry.key.split('|');
                    final cedula = parts[0];
                    final fecha = parts[1];
                    final asistencias = entry.value;
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: ListTile(
                        title: Text('Empleado: $cedula'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Fecha: $fecha'),
                            ...asistencias.map((a) {
                              final entrada = a['horaEntrada'] ?? '-';
                              final salida = a['horaSalida'] ?? '-';
                              return Row(
                                children: [
                                  const Icon(Icons.login,
                                      size: 16, color: Colors.green),
                                  Text(' Entrada: $entrada'),
                                  const SizedBox(width: 16),
                                  const Icon(Icons.logout,
                                      size: 16, color: Colors.red),
                                  Text(' Salida: $salida'),
                                ],
                              );
                            }),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
    );
  }
}
