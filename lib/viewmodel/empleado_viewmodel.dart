import 'dart:io';
import 'package:client_service/models/empleado.dart';
import 'package:client_service/utils/excel_export_utility.dart';
import 'package:client_service/repositories/empleado_repository.dart';
import 'package:client_service/viewmodel/base_viewmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EmpleadoViewmodel extends BaseViewModel {
  final EmpleadoRepository _repository;
  EmpleadoViewmodel(this._repository);
  List<Empleado> _empleados = [];
  List<Empleado> get empleados => _empleados;

  // Obtener todos los empleados3
  Future<void> fetchEmpleados() async {
    try {
      setLoading(true);
      clearError();
      _empleados = await _repository.getAll();
      notifyListeners();
    } catch (e) {
      setError(e.toString());
      print("Error al obtener empleados: $errorMessage");
    } finally {
      setLoading(false);
    }
  }

  Future<List<Empleado>> obtenerEmpleados() async {
    final result = await executeOperation(() => _repository.getAll());
    return result ?? [];
  }

  // Exportar empleados en excel
  Future<void> exportEmpleados() async {
    await handleAsyncOperation(() async {
      final empleados = await _repository.getAllForExport?.call() ?? [];
      await ExcelExportUtility.exportMultipleSheets(
        sheets: [
          ExcelSheetData(
            sheetName: 'Empleados',
            headers: [
              'Nombre',
              'Apellido',
              'Cédula',
              'Dirección',
              'Teléfono',
              'Correo',
              'Cargo',
              'Fecha Contratación',
              'Foto URL'
            ],
            rows: empleados.map<List<dynamic>>((data) => [
              data['nombre'] ?? '',
              data['apellido'] ?? '',
              data['cedula'] ?? '',
              data['direccion'] ?? '',
              data['telefono'] ?? '',
              data['correo'] ?? '',
              data['cargo'] ?? '',
              data['fechaContratacion'] != null
                  ? (data['fechaContratacion'] as Timestamp)
                      .toDate()
                      .toIso8601String()
                  : '',
              data['fotoUrl'] ?? ''
            ]).toList(),
          ),
        ],
        fileName: 'reporte_empleados.xlsx',
      );
    });
  }

  // Registrar nuevo empleado
  Future<bool> agregarEmpleado(Empleado empleado, File? imageFile) async {
    final result = await handleAsyncOperation(() async {
      final id = await _repository.createWithImage(empleado, imageFile);

      // El password inicial siempre será la cédula
      final newEmpleado = Empleado(
        id: id,
        nombre: empleado.nombre,
        apellido: empleado.apellido,
        cedula: empleado.cedula,
        direccion: empleado.direccion,
        telefono: empleado.telefono,
        correo: empleado.correo,
        cargo: empleado.cargo,
        fechaContratacion: empleado.fechaContratacion,
        fotoUrl: empleado.fotoUrl,
        password: empleado.cedula,
      );

      _empleados.add(newEmpleado);
      notifyListeners();
      return true;
    });

    return result ?? false;
  }

  // Actualizar empleado
  Future<bool> actualizarEmpleado(Empleado empleado,
      {File? nuevaImagen}) async {
    if (empleado.id == null) {
      setError("Error: El empleado no tiene ID");
      return false;
    }

    final result = await handleAsyncOperation(() async {
      await _repository.updateWithImage(empleado.id!, empleado, nuevaImagen);

      final index = _empleados.indexWhere((e) => e.id == empleado.id);
      if (index != -1) {
        _empleados[index] = empleado;
        notifyListeners();
      }
      return true;
    });

    return result ?? false;
  }

  // Eliminar empleado
  Future<bool> eliminarEmpleado(String id) async {
    final result = await handleAsyncOperation(() async {
      await _repository.delete(id);
      _empleados.removeWhere((e) => e.id == id);
      notifyListeners();
      return true;
    });

    return result ?? false;
  }

  // Escuchar cambios en tiempo real
  void listenToEmpleados() {
    _repository.watchAll().listen(
      (empleados) {
        _empleados = empleados;
        notifyListeners();
      },
      onError: (error) {
        setError("Error al escuchar empleados: $error");
      },
    );
  }
}
