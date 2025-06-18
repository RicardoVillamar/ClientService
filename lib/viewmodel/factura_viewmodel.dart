import 'package:client_service/models/factura.dart';
import 'package:client_service/utils/excel_export_utility.dart';
import 'package:client_service/repositories/factura_repository.dart';
import 'package:client_service/viewmodel/base_viewmodel.dart';

class FacturaViewModel extends BaseViewModel {
  final FacturaRepository _repository;

  FacturaViewModel(this._repository);

  List<Factura> _facturas = [];
  List<Factura> get facturas => _facturas;

  Map<String, dynamic>? _estadisticas;
  Map<String, dynamic>? get estadisticas => _estadisticas;

  // Obtener todas las facturas
  Future<void> fetchFacturas() async {
    final result = await handleAsyncOperation(() => _repository.getAll());
    if (result != null) {
      _facturas = result;
      notifyListeners();
    }
  }

  // Guardar una nueva factura
  Future<bool> guardarFactura(Factura factura) async {
    final id = await handleAsyncOperation(() => _repository.create(factura));

    if (id != null) {
      // Actualizar lista local
      final newFactura = factura.copyWith(id: id);
      _facturas.insert(0, newFactura); // Insertar al inicio
      notifyListeners();
      return true;
    }
    return false;
  }

  // Actualizar factura existente
  Future<bool> actualizarFactura(Factura factura) async {
    if (factura.id == null) {
      setError('Factura sin ID');
      return false;
    }

    try {
      setLoading(true);
      clearError();
      await _repository.update(factura.id!, factura);

      // Actualizar en la lista local
      final index = _facturas.indexWhere((f) => f.id == factura.id);
      if (index != -1) {
        _facturas[index] = factura;
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

  // Eliminar factura
  Future<bool> eliminarFactura(String id) async {
    try {
      setLoading(true);
      clearError();
      await _repository.delete(id);

      // Remover de la lista local
      _facturas.removeWhere((f) => f.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      setError(e.toString());
      return false;
    } finally {
      setLoading(false);
    }
  }

  // Obtener factura por ID
  Future<Factura?> obtenerFacturaPorId(String id) async {
    final result = await executeOperation(() => _repository.getById(id));
    return result;
  }

  // Obtener facturas por cliente
  Future<List<Factura>> obtenerFacturasPorCliente(String clienteId) async {
    final result =
        await executeOperation(() => _repository.getByClienteId(clienteId));
    return result ?? [];
  }

  // Obtener facturas por tipo de servicio
  Future<List<Factura>> obtenerFacturasPorTipoServicio(
      TipoServicio tipoServicio) async {
    final result = await executeOperation(
        () => _repository.getByTipoServicio(tipoServicio));
    return result ?? [];
  }

  // Obtener facturas por estado
  Future<List<Factura>> obtenerFacturasPorEstado(EstadoFactura estado) async {
    final result =
        await executeOperation(() => _repository.getByEstado(estado));
    return result ?? [];
  }

  // Obtener facturas por rango de fechas
  Future<List<Factura>> obtenerFacturasPorFechas({
    DateTime? fechaInicio,
    DateTime? fechaFin,
  }) async {
    final result = await executeOperation(() => _repository.getByFechaRange(
          fechaInicio: fechaInicio,
          fechaFin: fechaFin,
        ));
    return result ?? [];
  }

  // Obtener facturas vencidas
  Future<List<Factura>> obtenerFacturasVencidas() async {
    final result =
        await executeOperation(() => _repository.getFacturasVencidas());
    return result ?? [];
  }

  // Generar número de factura único
  Future<String> generarNumeroFactura() async {
    final result =
        await executeOperation(() => _repository.generateNumeroFactura());
    return result ?? 'FAC-${DateTime.now().year}-000001';
  }

  // Actualizar estado de factura
  Future<bool> actualizarEstadoFactura(
      String id, EstadoFactura nuevoEstado) async {
    try {
      setLoading(true);
      clearError();
      await _repository.updateEstado(id, nuevoEstado);

      // Actualizar en la lista local
      final index = _facturas.indexWhere((f) => f.id == id);
      if (index != -1) {
        _facturas[index] = _facturas[index].copyWith(estado: nuevoEstado);
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

  // Obtener estadísticas de facturación
  Future<void> cargarEstadisticas({
    DateTime? fechaInicio,
    DateTime? fechaFin,
  }) async {
    final result = await handleAsyncOperation(() => _repository.getEstadisticas(
          fechaInicio: fechaInicio,
          fechaFin: fechaFin,
        ));

    if (result != null) {
      _estadisticas = result;
      notifyListeners();
    }
  }

  // Exportar facturas a Excel
  Future<void> exportarFacturas({
    DateTime? fechaInicio,
    DateTime? fechaFin,
    EstadoFactura? estado,
    TipoServicio? tipoServicio,
  }) async {
    final data = await handleAsyncOperation(() => _repository.getAllForExport(
          fechaInicio: fechaInicio,
          fechaFin: fechaFin,
          estado: estado,
          tipoServicio: tipoServicio,
        ));

    if (data != null) {
      await ExcelExportUtility.exportToExcel(
        collectionName: 'facturas',
        headers: [
          'Número Factura',
          'Fecha Emisión',
          'Fecha Vencimiento',
          'Cliente',
          'Dirección',
          'Teléfono',
          'Correo',
          'Tipo Servicio',
          'Estado',
          'Subtotal',
          'Descuentos',
          'Impuesto',
          'Total',
          'Observaciones',
          'Creado Por',
        ],
        mapper: (dataItem) => [
          dataItem['numeroFactura'] ?? '',
          _formatDateTime(dataItem['fechaEmision']),
          _formatDateTime(dataItem['fechaVencimiento']),
          dataItem['nombreCliente'] ?? '',
          dataItem['direccionCliente'] ?? '',
          dataItem['telefonoCliente'] ?? '',
          dataItem['correoCliente'] ?? '',
          _formatTipoServicio(dataItem['tipoServicio']),
          _formatEstado(dataItem['estado']),
          dataItem['subtotal']?.toString() ?? '0',
          dataItem['totalDescuentos']?.toString() ?? '0',
          dataItem['montoImpuesto']?.toString() ?? '0',
          dataItem['total']?.toString() ?? '0',
          dataItem['observaciones'] ?? '',
          dataItem['creadoPor'] ?? '',
        ],
        sheetName: 'Facturas',
        fileName: 'reporte_facturas.xlsx',
      );
    }
  }

  // Escuchar cambios en tiempo real
  void listenToFacturas() {
    _repository.watchAll().listen(
      (facturas) {
        _facturas = facturas;
        notifyListeners();
      },
      onError: (error) {
        setError("Error al escuchar facturas: $error");
      },
    );
  }

  // Métodos auxiliares para formateo
  String _formatDateTime(dynamic dateTime) {
    if (dateTime == null) return '';
    try {
      if (dateTime is DateTime) {
        return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}';
      }
      return dateTime.toString();
    } catch (e) {
      return '';
    }
  }

  String _formatTipoServicio(String? tipo) {
    switch (tipo) {
      case 'camara':
        return 'Cámara';
      case 'instalacion':
        return 'Instalación';
      case 'vehiculo':
        return 'Vehículo';
      default:
        return tipo ?? '';
    }
  }

  String _formatEstado(String? estado) {
    switch (estado) {
      case 'pendiente':
        return 'Pendiente';
      case 'pagada':
        return 'Pagada';
      case 'cancelada':
        return 'Cancelada';
      case 'vencida':
        return 'Vencida';
      default:
        return estado ?? '';
    }
  }

  // Crear factura desde servicio
  Factura crearFacturaDesdeServicio({
    required String clienteId,
    required String nombreCliente,
    required String direccionCliente,
    required String telefonoCliente,
    required String correoCliente,
    required TipoServicio tipoServicio,
    required String servicioId,
    required List<ItemFactura> items,
    required String creadoPor,
    String? observaciones,
    double impuesto = 13.0,
    int diasVencimiento = 30,
  }) {
    final ahora = DateTime.now();
    final fechaVencimiento = ahora.add(Duration(days: diasVencimiento));

    return Factura(
      numeroFactura: '', // Se generará automáticamente
      fechaEmision: ahora,
      fechaVencimiento: fechaVencimiento,
      clienteId: clienteId,
      nombreCliente: nombreCliente,
      direccionCliente: direccionCliente,
      telefonoCliente: telefonoCliente,
      correoCliente: correoCliente,
      tipoServicio: tipoServicio,
      servicioId: servicioId,
      items: items,
      impuesto: impuesto,
      observaciones: observaciones,
      fechaCreacion: ahora,
      creadoPor: creadoPor,
    );
  }

  // Limpiar datos locales
  void clearData() {
    _facturas.clear();
    _estadisticas = null;
    notifyListeners();
  }
}
