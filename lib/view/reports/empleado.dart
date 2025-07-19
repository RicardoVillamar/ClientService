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

  Future<void> _fetchAsistencias() async {
    if (_empleadoSeleccionado == null) {
      setState(() {
        _asistencias = [];
        _loading = false;
      });
      return;
    }
    setState(() => _loading = true);
    final start = DateTime(_selectedMonth.year, _selectedMonth.month, 1);
    final end = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 1);
    // Solo filtra por cedula en Firestore, el resto en memoria para evitar el índice compuesto
    final query = await FirebaseFirestore.instance
        .collection('asistencias')
        .where('cedula', isEqualTo: _empleadoSeleccionado!.cedula)
        .get();
    final docsFiltrados = query.docs.where((doc) {
      final ts = doc['timestamp'];
      if (ts is Timestamp) {
        final dt = ts.toDate();
        return dt.isAfter(start.subtract(const Duration(seconds: 1))) &&
            dt.isBefore(end);
      }
      return false;
    }).toList();
    docsFiltrados.sort((a, b) {
      final ta = a['timestamp'] as Timestamp;
      final tb = b['timestamp'] as Timestamp;
      return tb.compareTo(ta); // descending
    });
    setState(() {
      _asistencias = docsFiltrados;
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
                                      setState(() {
                                        _empleadoSeleccionado = empleado;
                                      });
                                      await _fetchAsistencias();
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.white,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(24)),
                                        ),
                                        builder: (context) {
                                          return SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.6,
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      16.0),
                                                  child: Text(
                                                    'Asistencias de ${empleado.nombreCompleto}',
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.deepPurple,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: _asistencias.isEmpty
                                                      ? const Center(
                                                          child: Text(
                                                              'No hay asistencias registradas para este mes.'),
                                                        )
                                                      : ListView(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 8),
                                                          children: _asistencias
                                                              .map((doc) {
                                                            final data =
                                                                doc.data();
                                                            final fecha =
                                                                data['fecha'] ??
                                                                    '';
                                                            final entrada =
                                                                data['horaEntrada'] ??
                                                                    '-';
                                                            final salida = data[
                                                                    'horaSalida'] ??
                                                                '-';
                                                            return Card(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          12,
                                                                      vertical:
                                                                          4),
                                                              child: ListTile(
                                                                title: Text(
                                                                    'Fecha: $fecha'),
                                                                subtitle: Row(
                                                                  children: [
                                                                    const Icon(
                                                                        Icons
                                                                            .login,
                                                                        size:
                                                                            16,
                                                                        color: Colors
                                                                            .green),
                                                                    Text(
                                                                        ' Entrada: $entrada'),
                                                                    const SizedBox(
                                                                        width:
                                                                            16),
                                                                    const Icon(
                                                                        Icons
                                                                            .logout,
                                                                        size:
                                                                            16,
                                                                        color: Colors
                                                                            .red),
                                                                    Text(
                                                                        ' Salida: $salida'),
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          }).toList(),
                                                        ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    } else if (value == 'editar') {
                                      // TODO: Navegar a pantalla de edición de empleado
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Función editar no implementada')),
                                      );
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
                                        final repo = EmpleadoRepository();
                                        await repo.delete(empleado.id!);
                                        await _fetchEmpleadosYAsistencias();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content:
                                                  Text('Empleado eliminado')),
                                        );
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
