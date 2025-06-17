import 'package:client_service/models/instalacion.dart';
import 'package:client_service/utils/excel_export_utility.dart';
import 'package:client_service/repositories/instalacion_repository.dart';
import 'package:client_service/viewmodel/base_viewmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InstalacionViewModel extends BaseViewModel {
  final InstalacionRepository _repository;

  InstalacionViewModel(this._repository);

  List<Instalacion> _instalaciones = [];
  List<Instalacion> get instalaciones => _instalaciones;

  // Obtener instalaciones desde el repositorio y actualizar lista local
  Future<void> fetchInstalaciones() async {
    final result = await handleAsyncOperation(() async {
      _instalaciones = await _repository.getAll();
      notifyListeners();
    });

    if (result == null && errorMessage != null) {
      print("Error al obtener instalaciones: $errorMessage");
    }
  }

  // Guardar una nueva instalacion
  Future<bool> guardarInstalacion(Instalacion instalacion) async {
    final result = await handleAsyncOperation(() async {
      final id = await _repository.create(instalacion);

      // Actualizar la lista local
      final newInstalacion = Instalacion(
        id: id,
        fechaInstalacion: instalacion.fechaInstalacion,
        cedula: instalacion.cedula,
        nombreComercial: instalacion.nombreComercial,
        direccion: instalacion.direccion,
        item: instalacion.item,
        descripcion: instalacion.descripcion,
        horaInicio: instalacion.horaInicio,
        horaFin: instalacion.horaFin,
        tipoTrabajo: instalacion.tipoTrabajo,
        cargoPuesto: instalacion.cargoPuesto,
        telefono: instalacion.telefono,
        numeroTarea: instalacion.numeroTarea,
      );

      _instalaciones.add(newInstalacion);
      notifyListeners();
      return true;
    });

    return result ?? false;
  }

  // Obtener todas las instalaciones (sin actualizar la lista local)
  Future<List<Instalacion>> obtenerInstalaciones() async {
    final result = await executeOperation(() => _repository.getAll());
    return result ?? [];
  }

  // Exportar instalaciones a Excel
  Future<void> exportarInstalaciones() async {
    await handleAsyncOperation(() async {
      final data = await _repository.getAllForExport();

      await ExcelExportUtility.exportToExcel(
        collectionName: 'instalaciones',
        headers: [
          'ID',
          'Fecha Instalación',
          'Cédula',
          'Nombre Comercial',
          'Dirección',
          'Item',
          'Descripción',
          'Hora Inicio',
          'Hora Fin',
          'Tipo Trabajo',
          'Cargo Puesto',
          'Teléfono',
          'Número Tarea'
        ],
        mapper: (data) => [
          data['id'] ?? '',
          data['fechaInstalacion'] is Timestamp
              ? (data['fechaInstalacion'] as Timestamp)
                  .toDate()
                  .toIso8601String()
              : data['fechaInstalacion']?.toString() ?? '',
          data['cedula'] ?? '',
          data['nombreComercial'] ?? '',
          data['direccion'] ?? '',
          data['item'] ?? '',
          data['descripcion'] ?? '',
          data['horaInicio'] ?? '',
          data['horaFin'] ?? '',
          data['tipoTrabajo'] ?? '',
          data['cargoPuesto'] ?? '',
          data['telefono'] ?? '',
          data['numeroTarea'] ?? ''
        ],
        sheetName: 'Instalaciones',
        fileName: 'reporte_instalaciones.xlsx',
      );
    });
  }

  /// Obtener instalaciones filtradas por rango de fechas
  Future<List<Instalacion>> obtenerInstalacionesFiltradas({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final result = await executeOperation(() => _repository.getAllByDateRange(
          startDate: startDate,
          endDate: endDate,
        ));
    return result ?? [];
  }

  /// Exportar instalaciones con filtro de fecha
  Future<void> exportarInstalacionesFiltradas({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final data = await handleAsyncOperation(
        () => _repository.getAllForExportWithDateFilter(
              startDate: startDate,
              endDate: endDate,
            ));

    if (data != null) {
      await ExcelExportUtility.exportToExcel(
        collectionName: 'instalaciones',
        headers: [
          'ID',
          'Fecha Instalación',
          'Cédula',
          'Nombre Comercial',
          'Dirección',
          'Item',
          'Descripción',
          'Hora Inicio',
          'Hora Fin',
          'Tipo Trabajo',
          'Cargo/Puesto',
          'Teléfono',
          'Número Tarea',
        ],
        mapper: (dataItem) => [
          dataItem['id'] ?? '',
          dataItem['fechaInstalacion'] ?? '',
          dataItem['cedula'] ?? '',
          dataItem['nombreComercial'] ?? '',
          dataItem['direccion'] ?? '',
          dataItem['item'] ?? '',
          dataItem['descripcion'] ?? '',
          dataItem['horaInicio'] ?? '',
          dataItem['horaFin'] ?? '',
          dataItem['tipoTrabajo'] ?? '',
          dataItem['cargoPuesto'] ?? '',
          dataItem['telefono'] ?? '',
          dataItem['numeroTarea'] ?? '',
        ],
        sheetName: 'Instalaciones',
        fileName: 'reporte_instalaciones_filtrado.xlsx',
      );
    }
  }

  // Escuchar instalaciones en tiempo real
  void listenToInstalaciones() {
    _repository.watchAll().listen(
      (instalaciones) {
        _instalaciones = instalaciones;
        notifyListeners();
      },
      onError: (error) {
        setError("Error al escuchar instalaciones: $error");
      },
    );
  }

  // Eliminar instalación por ID
  Future<bool> eliminarInstalacion(String id) async {
    final result = await handleAsyncOperation(() async {
      await _repository.delete(id);
      _instalaciones.removeWhere((inst) => inst.id == id);
      notifyListeners();
      return true;
    });

    return result ?? false;
  }

  // Actualizar instalación
  Future<bool> actualizarInstalacion(Instalacion instalacion) async {
    if (instalacion.id == null) {
      setError("Error: La instalación no tiene ID");
      return false;
    }

    final result = await handleAsyncOperation(() async {
      await _repository.update(instalacion.id!, instalacion);

      final index =
          _instalaciones.indexWhere((inst) => inst.id == instalacion.id);
      if (index != -1) {
        _instalaciones[index] = instalacion;
        notifyListeners();
      }
      return true;
    });

    return result ?? false;
  }

  // Cancelar instalación
  Future<bool> cancelarInstalacion(String id, String motivo) async {
    try {
      setLoading(true);
      clearError();
      await _repository.cancelar(id, motivo);

      // Actualizar en la lista local
      final index = _instalaciones.indexWhere((inst) => inst.id == id);
      if (index != -1) {
        final instalacionActual = _instalaciones[index];
        _instalaciones[index] = instalacionActual.cancelar(motivo);
        notifyListeners();
      }
      return true;
    } catch (e) {
      setError(e.toString());
      return false;
    } finally {
      setLoading(false);
    }
  }

  // Retomar instalación
  Future<bool> retomarInstalacion(String id) async {
    try {
      setLoading(true);
      clearError();
      await _repository.retomar(id);

      // Actualizar en la lista local
      final index = _instalaciones.indexWhere((inst) => inst.id == id);
      if (index != -1) {
        final instalacionActual = _instalaciones[index];
        _instalaciones[index] = instalacionActual.retomar();
        notifyListeners();
      }
      return true;
    } catch (e) {
      setError(e.toString());
      return false;
    } finally {
      setLoading(false);
    }
  }

  // Cambiar estado de la instalación
  Future<bool> cambiarEstado(String id, String nuevoEstado) async {
    try {
      setLoading(true);
      clearError();
      await _repository.cambiarEstado(id, nuevoEstado);

      // Actualizar en la lista local si es necesario
      await fetchInstalaciones();
      return true;
    } catch (e) {
      setError(e.toString());
      return false;
    } finally {
      setLoading(false);
    }
  }

  // Obtener instalaciones por estado
  Future<List<Instalacion>> obtenerInstalacionesPorEstado(
      EstadoInstalacion estado) async {
    final result = await executeOperation(
        () => _repository.getByEstado(estado.displayName));
    return result ?? [];
  }
}
