import 'package:client_service/models/camara.dart';
import 'package:client_service/utils/excel_export_utility.dart';
import 'package:client_service/repositories/camara_repository.dart';
import 'package:client_service/viewmodel/base_viewmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CamaraViewModel extends BaseViewModel {
  final CamaraRepository _repository;

  CamaraViewModel(this._repository);

  List<Camara> _camaras = [];
  List<Camara> get camaras => _camaras;

  // Obtener todas las cámaras y actualizar lista local
  Future<void> fetchCamaras() async {
    final result = await handleAsyncOperation(() => _repository.getAll());
    if (result != null) {
      _camaras = result;
      notifyListeners();
    }
  }

  // Guardar nueva cámara
  Future<bool> guardarCamara(Camara camara) async {
    final id = await handleAsyncOperation(() => _repository.create(camara));

    if (id != null) {
      // Actualizar la lista local
      final newCamara = Camara(
        id: id,
        nombreComercial: camara.nombreComercial,
        fechaMantenimiento: camara.fechaMantenimiento,
        direccion: camara.direccion,
        tecnico: camara.tecnico,
        tipo: camara.tipo,
        descripcion: camara.descripcion,
        costo: camara.costo,
      );

      _camaras.add(newCamara);
      notifyListeners();
      return true;
    }
    return false;
  }

  // Obtener lista de registros (sin actualizar lista local)
  Future<List<Camara>> obtenerCamaras() async {
    final result = await executeOperation(() => _repository.getAll());
    return result ?? [];
  }

  // Exportar cámaras a Excel
  Future<void> exportarCamaras() async {
    final data =
        await handleAsyncOperation(() => _repository.getAllForExport());

    if (data != null) {
      await ExcelExportUtility.exportMultipleSheets(
        sheets: [
          ExcelSheetData(
            sheetName: 'Cámaras',
            headers: [
              'ID',
              'Nombre Comercial',
              'Fecha Mantenimiento',
              'Dirección',
              'Técnico',
              'Tipo',
              'Descripción',
              'Costo',
            ],
            rows: data
                .map<List<dynamic>>((dataItem) => [
                      dataItem['id'] ?? '',
                      dataItem['nombreComercial'] ?? '',
                      dataItem['fechaMantenimiento'] is Timestamp
                          ? (dataItem['fechaMantenimiento'] as Timestamp)
                              .toDate()
                              .toIso8601String()
                          : dataItem['fechaMantenimiento']?.toString() ?? '',
                      dataItem['direccion'] ?? '',
                      dataItem['tecnico'] ?? '',
                      dataItem['tipo'] ?? '',
                      dataItem['descripcion'] ?? '',
                      (dataItem['costo'] is int
                              ? (dataItem['costo'] as int).toDouble()
                              : (dataItem['costo'] is double
                                  ? dataItem['costo']
                                  : double.tryParse(
                                          dataItem['costo'].toString()) ??
                                      0.0))
                          .toString(),
                    ])
                .toList(),
          ),
        ],
        fileName: 'reporte_camaras.xlsx',
      );
    }
  }

  /// Obtener cámaras filtradas por rango de fechas
  Future<List<Camara>> obtenerCamarasFiltradas({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final result = await executeOperation(() => _repository.getAllByDateRange(
          startDate: startDate,
          endDate: endDate,
        ));
    return result ?? [];
  }

  /// Exportar cámaras con filtro de fecha
  Future<void> exportarCamarasFiltradas({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final data = await handleAsyncOperation(
        () => _repository.getAllForExportWithDateFilter(
              startDate: startDate,
              endDate: endDate,
            ));

    if (data != null) {
      await ExcelExportUtility.exportMultipleSheets(
        sheets: [
          ExcelSheetData(
            sheetName: 'Cámaras',
            headers: [
              'ID',
              'Nombre Comercial',
              'Fecha Mantenimiento',
              'Dirección',
              'Técnico',
              'Tipo',
              'Descripción',
              'Costo',
            ],
            rows: data
                .map<List<dynamic>>((dataItem) => [
                      dataItem['id'] ?? '',
                      dataItem['nombreComercial'] ?? '',
                      dataItem['fechaMantenimiento'] ?? '',
                      dataItem['direccion'] ?? '',
                      dataItem['tecnico'] ?? '',
                      dataItem['tipo'] ?? '',
                      dataItem['descripcion'] ?? '',
                      dataItem['costo']?.toString() ?? '0',
                    ])
                .toList(),
          ),
        ],
        fileName: 'reporte_camaras_filtrado.xlsx',
      );
    }
  }

  // Escuchar cambios en tiempo real
  Stream<List<Camara>> escucharCamaras() {
    return _repository.watchAll();
  }

  // Actualizar registro
  Future<bool> actualizarCamara(Camara camara) async {
    if (camara.id == null) {
      setError('ID requerido para actualizar');
      return false;
    }

    try {
      setLoading(true);
      clearError();
      await _repository.update(camara.id!, camara);

      // Actualizar en la lista local
      final index = _camaras.indexWhere((c) => c.id == camara.id);
      if (index != -1) {
        _camaras[index] = camara;
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

  // Eliminar registro
  Future<bool> eliminarCamara(String id) async {
    try {
      setLoading(true);
      clearError();
      await _repository.delete(id);

      // Remover de la lista local
      _camaras.removeWhere((c) => c.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      setError(e.toString());
      return false;
    } finally {
      setLoading(false);
    }
  }

  // Cancelar mantenimiento de cámara
  Future<bool> cancelarMantenimiento(String id, String motivo) async {
    try {
      setLoading(true);
      clearError();
      await _repository.cancelar(id, motivo);

      // Actualizar en la lista local
      final index = _camaras.indexWhere((c) => c.id == id);
      if (index != -1) {
        final camaraActual = _camaras[index];
        _camaras[index] = camaraActual.cancelar(motivo);
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

  // Retomar mantenimiento de cámara
  Future<bool> retomarMantenimiento(String id) async {
    try {
      setLoading(true);
      clearError();
      await _repository.retomar(id);

      // Actualizar en la lista local
      final index = _camaras.indexWhere((c) => c.id == id);
      if (index != -1) {
        final camaraActual = _camaras[index];
        _camaras[index] = camaraActual.retomar();
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

  // Cambiar estado del mantenimiento
  Future<bool> cambiarEstado(String id, String nuevoEstado) async {
    try {
      setLoading(true);
      clearError();
      await _repository.cambiarEstado(id, nuevoEstado);

      // Actualizar en la lista local si es necesario
      await fetchCamaras();
      return true;
    } catch (e) {
      setError(e.toString());
      return false;
    } finally {
      setLoading(false);
    }
  }

  // Obtener cámaras por estado
  Future<List<Camara>> obtenerCamarasPorEstado(EstadoCamara estado) async {
    final result = await executeOperation(
        () => _repository.getByEstado(estado.displayName));
    return result ?? [];
  }
}
