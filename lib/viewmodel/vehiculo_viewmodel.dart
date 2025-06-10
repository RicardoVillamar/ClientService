import 'package:client_service/models/vehiculo.dart';
import 'package:client_service/utils/excel_export_utility.dart';
import 'package:client_service/repositories/vehiculo_repository.dart';
import 'package:client_service/viewmodel/base_viewmodel.dart';

class AlquilerViewModel extends BaseViewModel {
  final VehiculoRepository _repository;

  AlquilerViewModel(this._repository);

  List<Alquiler> _alquileres = [];
  List<Alquiler> get alquileres => _alquileres;

  // Obtener alquileres y actualizar lista local
  Future<void> fetchAlquileres() async {
    final result = await handleAsyncOperation(() => _repository.getAll());
    if (result != null) {
      _alquileres = result;
      notifyListeners();
    }
  }

  // Obtener alquileres (sin actualizar lista local)
  Future<List<Alquiler>> obtenerAlquileres() async {
    final result = await executeOperation(() => _repository.getAll());
    return result ?? [];
  }

  // Exportar alquileres a Excel
  Future<void> exportAlquileres() async {
    final data =
        await handleAsyncOperation(() => _repository.getAllForExport());

    if (data != null) {
      await ExcelExportUtility.exportToExcel(
        collectionName: 'alquileres',
        headers: [
          'ID',
          'Cliente',
          'Fecha Registro Reserva',
          'Fecha Trabajo',
          'Correo Cliente',
          'Teléfono Cliente',
          'Dirección Cliente',
          'Vehículo',
          'Monto Total',
          'Personal Asignado',
        ],
        mapper: (dataItem) => [
          dataItem['id'] ?? '',
          dataItem['nombreComercial'] ?? '',
          dataItem['fechaReserva']?.toDate()?.toString() ?? '',
          dataItem['fechaTrabajo']?.toDate()?.toString() ?? '',
          dataItem['correo'] ?? '',
          dataItem['telefono'] ?? '',
          dataItem['direccion'] ?? '',
          dataItem['tipoVehiculo'] ?? '',
          dataItem['montoAlquiler']?.toString() ?? '',
          dataItem['personalAsistio'] ?? '',
        ],
        sheetName: 'Alquileres',
        fileName: 'reporte_alquileres.xlsx',
      );
    }
  }

  // Guardar un nuevo alquiler
  Future<bool> guardarAlquiler(Alquiler alquiler) async {
    final id = await handleAsyncOperation(() => _repository.create(alquiler));

    if (id != null) {
      // Actualizar la lista local
      final newAlquiler = Alquiler(
        id: id,
        nombreComercial: alquiler.nombreComercial,
        fechaReserva: alquiler.fechaReserva,
        fechaTrabajo: alquiler.fechaTrabajo,
        correo: alquiler.correo,
        telefono: alquiler.telefono,
        direccion: alquiler.direccion,
        tipoVehiculo: alquiler.tipoVehiculo,
        montoAlquiler: alquiler.montoAlquiler,
        personalAsistio: alquiler.personalAsistio,
      );

      _alquileres.add(newAlquiler);
      notifyListeners();
      return true;
    }
    return false;
  }

  // Escuchar cambios en tiempo real
  Stream<List<Alquiler>> escucharAlquileres() {
    return _repository.watchAll();
  }

  // Eliminar alquiler
  Future<bool> eliminarAlquiler(String id) async {
    try {
      setLoading(true);
      clearError();
      await _repository.delete(id);

      // Remover de la lista local
      _alquileres.removeWhere((a) => a.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      setError(e.toString());
      return false;
    } finally {
      setLoading(false);
    }
  }

  // Actualizar alquiler
  Future<bool> actualizarAlquiler(Alquiler alquiler) async {
    if (alquiler.id == null) {
      setError('Alquiler sin ID');
      return false;
    }

    try {
      setLoading(true);
      clearError();
      await _repository.update(alquiler.id!, alquiler);

      // Actualizar en la lista local
      final index = _alquileres.indexWhere((a) => a.id == alquiler.id);
      if (index != -1) {
        _alquileres[index] = alquiler;
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

  /// Obtener alquileres filtrados por rango de fechas de reserva
  Future<List<Alquiler>> obtenerAlquileresFiltradosPorReserva({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final result =
        await executeOperation(() => _repository.getAllByReservaDateRange(
              startDate: startDate,
              endDate: endDate,
            ));
    return result ?? [];
  }

  /// Obtener alquileres filtrados por rango de fechas de trabajo
  Future<List<Alquiler>> obtenerAlquileresFiltradosPorTrabajo({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final result =
        await executeOperation(() => _repository.getAllByTrabajoDateRange(
              startDate: startDate,
              endDate: endDate,
            ));
    return result ?? [];
  }

  /// Exportar alquileres con filtro de fecha de reserva
  Future<void> exportarAlquileresFiltradosPorReserva({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final data = await handleAsyncOperation(
        () => _repository.getAllForExportWithReservaDateFilter(
              startDate: startDate,
              endDate: endDate,
            ));

    if (data != null) {
      await ExcelExportUtility.exportToExcel(
        collectionName: 'alquileres_reserva',
        headers: [
          'ID',
          'Nombre Comercial',
          'Dirección',
          'Teléfono',
          'Correo',
          'Tipo Vehículo',
          'Fecha Reserva',
          'Fecha Trabajo',
          'Monto Alquiler',
          'Personal Asistió',
        ],
        mapper: (dataItem) => [
          dataItem['id'] ?? '',
          dataItem['nombreComercial'] ?? '',
          dataItem['direccion'] ?? '',
          dataItem['telefono'] ?? '',
          dataItem['correo'] ?? '',
          dataItem['tipoVehiculo'] ?? '',
          dataItem['fechaReserva'] ?? '',
          dataItem['fechaTrabajo'] ?? '',
          dataItem['montoAlquiler']?.toString() ?? '0',
          dataItem['personalAsistio'] ?? '',
        ],
        sheetName: 'Alquileres por Reserva',
        fileName: 'reporte_alquileres_reserva_filtrado.xlsx',
      );
    }
  }

  /// Exportar alquileres con filtro de fecha de trabajo
  Future<void> exportarAlquileresFiltradosPorTrabajo({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final data = await handleAsyncOperation(
        () => _repository.getAllForExportWithTrabajoDateFilter(
              startDate: startDate,
              endDate: endDate,
            ));

    if (data != null) {
      await ExcelExportUtility.exportToExcel(
        collectionName: 'alquileres_trabajo',
        headers: [
          'ID',
          'Nombre Comercial',
          'Dirección',
          'Teléfono',
          'Correo',
          'Tipo Vehículo',
          'Fecha Reserva',
          'Fecha Trabajo',
          'Monto Alquiler',
          'Personal Asistió',
        ],
        mapper: (dataItem) => [
          dataItem['id'] ?? '',
          dataItem['nombreComercial'] ?? '',
          dataItem['direccion'] ?? '',
          dataItem['telefono'] ?? '',
          dataItem['correo'] ?? '',
          dataItem['tipoVehiculo'] ?? '',
          dataItem['fechaReserva'] ?? '',
          dataItem['fechaTrabajo'] ?? '',
          dataItem['montoAlquiler']?.toString() ?? '0',
          dataItem['personalAsistio'] ?? '',
        ],
        sheetName: 'Alquileres por Trabajo',
        fileName: 'reporte_alquileres_trabajo_filtrado.xlsx',
      );
    }
  }
}
