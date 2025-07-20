import 'package:client_service/models/cliente.dart';
import 'package:client_service/utils/excel_export_utility.dart';
import 'package:client_service/repositories/cliente_repository.dart';
import 'package:client_service/viewmodel/base_viewmodel.dart';

class ClienteViewModel extends BaseViewModel {
  final ClienteRepository _repository;

  ClienteViewModel(this._repository);

  List<Cliente> _clientes = [];
  List<Cliente> get clientes => _clientes;

  Future<void> fetchClientes() async {
    final result = await handleAsyncOperation(() => _repository.getAll());
    if (result != null) {
      _clientes = result;
      notifyListeners();
    }
  }

  // Guardar un cliente
  Future<bool> guardarCliente(Cliente cliente) async {
    final id = await handleAsyncOperation(() => _repository.create(cliente));

    if (id != null) {
      // Actualizar lista local
      final newCliente = Cliente(
        id: id,
        nombreComercial: cliente.nombreComercial,
        ruc: cliente.ruc,
        direccion: cliente.direccion,
        telefono: cliente.telefono,
        correo: cliente.correo,
        personaContacto: cliente.personaContacto,
        cedula: cliente.cedula,
      );

      _clientes.add(newCliente);
      notifyListeners();
      return true;
    }
    return false;
  }

  // Obtener todos los clientes
  Future<List<Cliente>> obtenerClientes() async {
    final result = await executeOperation(() => _repository.getAll());
    return result ?? [];
  }

  // Exportar clientes a Excel
  Future<void> exportarClientes() async {
    final data =
        await handleAsyncOperation(() => _repository.getAllForExport());

    if (data != null) {
      await ExcelExportUtility.exportMultipleSheets(
        sheets: [
          ExcelSheetData(
            sheetName: 'Clientes',
            headers: [
              'ID',
              'Nombre Comercial',
              'Correo',
              'Teléfono',
              'Dirección',
              'Persona de Contacto',
              'Cédula',
            ],
            rows: data
                .map<List<dynamic>>((dataItem) => [
                      dataItem['id'] ?? '',
                      dataItem['nombreComercial'] ?? '',
                      dataItem['correo'] ?? '',
                      dataItem['telefono'] ?? '',
                      dataItem['direccion'] ?? '',
                      dataItem['personaContacto'] ?? '',
                      dataItem['cedula'] ?? '',
                    ])
                .toList(),
          ),
        ],
        fileName: 'reporte_clientes.xlsx',
      );
    }
  }

  // Escuchar cambios en tiempo real
  void listenToClientes() {
    _repository.watchAll().listen(
      (clientes) {
        _clientes = clientes;
        notifyListeners();
      },
      onError: (error) {
        setError("Error al escuchar clientes: $error");
      },
    );
  }

  // Eliminar cliente por ID
  Future<bool> eliminarCliente(String id) async {
    try {
      setLoading(true);
      clearError();
      await _repository.delete(id);
      _clientes.removeWhere((c) => c.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      setError(e.toString());
      return false;
    } finally {
      setLoading(false);
    }
  }

  // Editar cliente
  Future<bool> actualizarCliente(Cliente cliente) async {
    if (cliente.id == null) {
      setError("Error: Cliente no tiene ID");
      return false;
    }

    try {
      setLoading(true);
      clearError();
      await _repository.update(cliente.id!, cliente);

      final index = _clientes.indexWhere((c) => c.id == cliente.id);
      if (index != -1) {
        _clientes[index] = cliente;
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
}
