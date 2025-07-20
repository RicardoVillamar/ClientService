import 'package:flutter/material.dart';
import 'package:client_service/models/empleado.dart';
import 'package:client_service/repositories/empleado_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:client_service/utils/excel_export_utility.dart';
import 'package:client_service/utils/colors.dart';
import 'package:client_service/view/widgets/shared/apptitle.dart';
import 'package:client_service/view/widgets/shared/button.dart';
import 'package:client_service/view/widgets/shared/toolbar.dart';
import 'package:client_service/view/registers/employet/edit_employet.dart';
import 'package:client_service/view/reports/empleado_asistencia.dart';

class AsistenciasAdminScreen extends StatefulWidget {
  const AsistenciasAdminScreen({super.key});

  @override
  State<AsistenciasAdminScreen> createState() => _AsistenciasAdminScreenState();
}

class _AsistenciasAdminScreenState extends State<AsistenciasAdminScreen> {
  DateTime _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);
  List<QueryDocumentSnapshot<Map<String, dynamic>>> _asistencias = [];
  bool _loading = true;
  List<Empleado> _empleados = [];
  List<Empleado> _empleadosNoAdmin = [];
  Empleado? _empleadoSeleccionado;

  @override
  void initState() {
    super.initState();
    _fetchEmpleadosYAsistencias();
  }

  Future<void> _fetchEmpleadosYAsistencias() async {
    setState(() => _loading = true);
    final repo = EmpleadoRepository();
    final empleados = await repo.getAll();
    final empleadosNoAdmin = empleados
        .where((e) => e.cargoDisplayName.toLowerCase() != 'administrador')
        .toList();
    setState(() {
      _empleados = empleados;
      _empleadosNoAdmin = empleadosNoAdmin;
      _empleadoSeleccionado =
          empleadosNoAdmin.isNotEmpty ? empleadosNoAdmin.first : null;
    });
    await _fetchAsistencias();
  }

  Future<void> _fetchAsistencias([Empleado? empleado]) async {
    final empleadoActual = empleado ?? _empleadoSeleccionado;
    // Validación robusta de empleado y cédula
    if (empleadoActual == null || empleadoActual.cedula.trim().isEmpty) {
      setState(() {
        _asistencias = [];
        _loading = false;
      });
      return;
    }
    final cedula = empleadoActual.cedula.trim();
    setState(() => _loading = true);
    final start = DateTime(_selectedMonth.year, _selectedMonth.month, 1);
    final end = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 1);
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
          const SnackBar(
            content: Text(
                'No se pueden mostrar asistencias: el empleado no tiene cédula registrada.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: AppColors.backgroundColor,
        ),
        child: Column(
          children: [
            const Apptitle(title: 'Reporte de Empleados'),
            // Botón de filtro de mes y descarga
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    monthLabel,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.calendar_month),
                        tooltip: 'Cambiar mes',
                        onPressed: () => _selectMonth(context),
                        color: AppColors.primaryColor,
                      ),
                      IconButton(
                        icon: const Icon(Icons.download),
                        tooltip: 'Exportar a Excel',
                        onPressed: _exportarAsistencias,
                        color: AppColors.primaryColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _empleadosNoAdmin.isEmpty
                      ? const Center(child: Text('No hay empleados'))
                      : ListView.builder(
                          itemCount: _empleadosNoAdmin.length,
                          itemBuilder: (context, index) {
                            final empleado = _empleadosNoAdmin[index];
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: const BoxDecoration(
                                color: AppColors.whiteColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: AppColors.primaryColor,
                                  child: Text(
                                    empleado.nombreCompleto.isNotEmpty
                                        ? empleado.nombreCompleto[0]
                                            .toUpperCase()
                                        : '?',
                                    style: const TextStyle(
                                      color: AppColors.whiteColor,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                title: Text(empleado.nombreCompleto),
                                subtitle: Text(empleado.cargoDisplayName),
                                trailing: PopupMenuButton<String>(
                                  color: AppColors.whiteColor,
                                  icon: const Icon(Icons.more_vert),
                                  onSelected: (value) async {
                                    if (value == 'asistencias') {
                                      if (empleado.cedula.trim().isEmpty) {
                                        if (mounted) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'No se pueden mostrar asistencias: el empleado no tiene cédula registrada.'),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                        return;
                                      }
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EmpleadoAsistenciasPage(
                                            empleado: empleado,
                                            selectedMonth: _selectedMonth,
                                          ),
                                        ),
                                      );
                                    } else if (value == 'editar') {
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EditEmpleadoPage(
                                                  empleado: empleado),
                                        ),
                                      );
                                      if (result == true) {
                                        await _fetchEmpleadosYAsistencias();
                                      }
                                    } else if (value == 'eliminar') {
                                      final confirm = await showDialog<bool>(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title:
                                              const Text('Eliminar empleado'),
                                          content: Text(
                                              '¿Seguro que deseas eliminar a ${empleado.nombreCompleto}?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, false),
                                              child: const Text('Cancelar'),
                                            ),
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, true),
                                              child: const Text('Eliminar',
                                                  style: TextStyle(
                                                      color: Colors.red)),
                                            ),
                                          ],
                                        ),
                                      );
                                      if (confirm == true) {
                                        if (empleado.id == null) {
                                          if (mounted) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'No se puede eliminar: el empleado no tiene un ID válido.'),
                                              ),
                                            );
                                          }
                                          return;
                                        }
                                        final repo = EmpleadoRepository();
                                        await repo.delete(empleado.id!);
                                        await _fetchEmpleadosYAsistencias();
                                        if (mounted) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content:
                                                    Text('Empleado eliminado')),
                                          );
                                        }
                                      }
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    const PopupMenuItem(
                                      value: 'asistencias',
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Ver asistencias'),
                                          Icon(Icons.calendar_month, size: 18),
                                        ],
                                      ),
                                    ),
                                    const PopupMenuItem(
                                      value: 'editar',
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Editar'),
                                          Icon(Icons.edit, size: 18),
                                        ],
                                      ),
                                    ),
                                    const PopupMenuItem(
                                      value: 'eliminar',
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Eliminar'),
                                          Icon(Icons.delete, size: 18),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
      floatingActionButton: BtnFloating(
        onPressed: () {
          _exportarAsistencias();
        },
        icon: Icons.download_rounded,
        text: 'Descargar',
      ),
      bottomNavigationBar: const Toolbar(),
    );
  }
}
