import 'package:client_service/models/factura.dart';
import 'package:client_service/models/cliente.dart';
import 'package:client_service/models/empleado.dart';
import 'package:client_service/utils/colors.dart';
import 'package:client_service/utils/font.dart';
import 'package:client_service/view/widgets/shared/button.dart';
import 'package:client_service/view/widgets/shared/inputs.dart';
import 'package:client_service/view/widgets/flash_messages.dart';
import 'package:client_service/viewmodel/factura_viewmodel.dart';
import 'package:client_service/viewmodel/cliente_viewmodel.dart';
import 'package:client_service/viewmodel/empleado_viewmodel.dart';
import 'package:client_service/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditFactura extends StatefulWidget {
  final Factura factura;

  const EditFactura({super.key, required this.factura});

  @override
  State<EditFactura> createState() => _EditFacturaState();
}

class _EditFacturaState extends State<EditFactura> {
  final TextEditingController _numeroFacturaController =
      TextEditingController();
  final TextEditingController _fechaEmisionController = TextEditingController();
  final TextEditingController _fechaVencimientoController =
      TextEditingController();
  final TextEditingController _observacionesController =
      TextEditingController();
  final TextEditingController _impuestoController = TextEditingController();

  final FacturaViewModel _facturaViewModel = sl<FacturaViewModel>();
  final ClienteViewModel _clienteViewModel = sl<ClienteViewModel>();
  final EmpleadoViewmodel _empleadoViewModel = sl<EmpleadoViewmodel>();

  List<Cliente> _clientes = [];
  List<Empleado> _empleados = [];
  List<ItemFactura> _items = [];

  Cliente? _clienteSeleccionado;
  TipoServicio _tipoServicioSeleccionado = TipoServicio.instalacion;
  EstadoFactura _estadoSeleccionado = EstadoFactura.pendiente;
  String? _creadoPorSeleccionado;

  @override
  void initState() {
    super.initState();
    _loadFacturaData();
    _loadClientes();
    _loadEmpleados();
  }

  void _loadFacturaData() {
    _numeroFacturaController.text = widget.factura.numeroFactura;
    _fechaEmisionController.text =
        DateFormat('dd/MM/yyyy').format(widget.factura.fechaEmision);
    _fechaVencimientoController.text =
        DateFormat('dd/MM/yyyy').format(widget.factura.fechaVencimiento);
    _observacionesController.text = widget.factura.observaciones ?? '';
    _impuestoController.text = widget.factura.impuesto.toString();

    _tipoServicioSeleccionado = widget.factura.tipoServicio;
    _estadoSeleccionado = widget.factura.estado;
    _creadoPorSeleccionado = widget.factura.creadoPor;

    _items = List.from(widget.factura.items);
  }

  void _loadClientes() async {
    _clientes = await _clienteViewModel.obtenerClientes();
    // Buscar el cliente seleccionado
    _clienteSeleccionado = _clientes.firstWhere(
      (c) => c.id == widget.factura.clienteId,
      orElse: () => Cliente(
        id: widget.factura.clienteId,
        nombreComercial: widget.factura.nombreCliente,
        ruc: '',
        direccion: widget.factura.direccionCliente,
        telefono: widget.factura.telefonoCliente,
        correo: widget.factura.correoCliente,
        personaContacto: '',
        cedula: '',
      ),
    );
    setState(() {});
  }

  void _loadEmpleados() async {
    _empleados = await _empleadoViewModel.obtenerEmpleados();
    setState(() {});
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      final formattedDate = DateFormat('dd/MM/yyyy').format(picked);
      setState(() {
        controller.text = formattedDate;
      });
    }
  }

  void _agregarItem() {
    setState(() {
      _items.add(ItemFactura(
        descripcion: '',
        cantidad: 1,
        precioUnitario: 0.0,
        descuento: 0.0,
      ));
    });
  }

  void _eliminarItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  void _actualizarItem(int index, ItemFactura nuevoItem) {
    setState(() {
      _items[index] = nuevoItem;
    });
  }

  double get _subtotal => _items.fold(0.0, (sum, item) => sum + item.subtotal);
  double get _totalDescuentos =>
      _items.fold(0.0, (sum, item) => sum + item.montoDescuento);
  double get _baseImponible => _subtotal - _totalDescuentos;
  double get _montoImpuesto =>
      _baseImponible * (double.tryParse(_impuestoController.text) ?? 0.0) / 100;
  double get _total => _baseImponible + _montoImpuesto;

  void _actualizarFactura() async {
    if (_clienteSeleccionado == null) {
      FlashMessages.showWarning(
        context: context,
        message: 'Por favor seleccione un cliente',
      );
      return;
    }

    if (_creadoPorSeleccionado == null) {
      FlashMessages.showWarning(
        context: context,
        message: 'Por favor seleccione quién crea la factura',
      );
      return;
    }

    if (_items.isEmpty || _items.any((item) => item.descripcion.isEmpty)) {
      FlashMessages.showWarning(
        context: context,
        message: 'Por favor complete todos los items',
      );
      return;
    }

    try {
      final facturaActualizada = widget.factura.copyWith(
        numeroFactura: _numeroFacturaController.text,
        fechaEmision:
            DateFormat('dd/MM/yyyy').parse(_fechaEmisionController.text),
        fechaVencimiento:
            DateFormat('dd/MM/yyyy').parse(_fechaVencimientoController.text),
        clienteId: _clienteSeleccionado!.id!,
        nombreCliente: _clienteSeleccionado!.nombreComercial,
        direccionCliente: _clienteSeleccionado!.direccion,
        telefonoCliente: _clienteSeleccionado!.telefono,
        correoCliente: _clienteSeleccionado!.correo,
        tipoServicio: _tipoServicioSeleccionado,
        items: _items,
        impuesto: double.tryParse(_impuestoController.text) ?? 13.0,
        estado: _estadoSeleccionado,
        observaciones: _observacionesController.text.isEmpty
            ? null
            : _observacionesController.text,
        creadoPor: _creadoPorSeleccionado!,
      );

      final success =
          await _facturaViewModel.actualizarFactura(facturaActualizada);

      if (success) {
        FlashMessages.showSuccess(
          context: context,
          message: 'Factura actualizada exitosamente',
        );
        Navigator.pop(context);
      } else {
        FlashMessages.showError(
          context: context,
          message: 'Error al actualizar la factura',
        );
      }
    } catch (e) {
      FlashMessages.showError(
        context: context,
        message: 'Error al actualizar la factura: $e',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Editar Factura'),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.whiteColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Información básica
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Información de la Factura',
                    style: AppFonts.bodyNormal.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TxtFields(
                    label: 'Número de Factura',
                    controller: _numeroFacturaController,
                    screenWidth: double.infinity,
                    showCounter: false,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _fechaEmisionController,
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: 'Fecha de Emisión',
                            suffixIcon: Icon(Icons.calendar_today),
                            border: OutlineInputBorder(),
                          ),
                          onTap: () =>
                              _selectDate(context, _fechaEmisionController),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _fechaVencimientoController,
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: 'Fecha de Vencimiento',
                            suffixIcon: Icon(Icons.calendar_today),
                            border: OutlineInputBorder(),
                          ),
                          onTap: () =>
                              _selectDate(context, _fechaVencimientoController),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<Cliente>(
                    value: _clienteSeleccionado,
                    decoration: const InputDecoration(
                      labelText: 'Cliente',
                      border: OutlineInputBorder(),
                    ),
                    items: _clientes.map((cliente) {
                      return DropdownMenuItem<Cliente>(
                        value: cliente,
                        child: Text(cliente.nombreComercial),
                      );
                    }).toList(),
                    onChanged: (cliente) {
                      setState(() {
                        _clienteSeleccionado = cliente;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<TipoServicio>(
                          value: _tipoServicioSeleccionado,
                          decoration: const InputDecoration(
                            labelText: 'Tipo de Servicio',
                            border: OutlineInputBorder(),
                          ),
                          items: TipoServicio.values.map((tipo) {
                            return DropdownMenuItem<TipoServicio>(
                              value: tipo,
                              child: Text(_getTipoServicioText(tipo)),
                            );
                          }).toList(),
                          onChanged: (tipo) {
                            setState(() {
                              _tipoServicioSeleccionado = tipo!;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<EstadoFactura>(
                          value: _estadoSeleccionado,
                          decoration: const InputDecoration(
                            labelText: 'Estado',
                            border: OutlineInputBorder(),
                          ),
                          items: EstadoFactura.values.map((estado) {
                            return DropdownMenuItem<EstadoFactura>(
                              value: estado,
                              child: Text(_getEstadoText(estado)),
                            );
                          }).toList(),
                          onChanged: (estado) {
                            setState(() {
                              _estadoSeleccionado = estado!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _creadoPorSeleccionado,
                    decoration: const InputDecoration(
                      labelText: 'Creado por',
                      border: OutlineInputBorder(),
                    ),
                    items: _empleados.map((empleado) {
                      return DropdownMenuItem<String>(
                        value: empleado.nombreCompleto,
                        child: Text(empleado.nombreCompletoConCargo),
                      );
                    }).toList(),
                    onChanged: (empleado) {
                      setState(() {
                        _creadoPorSeleccionado = empleado;
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Items de la factura
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Items de la Factura',
                        style: AppFonts.bodyNormal.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      IconButton(
                        onPressed: _agregarItem,
                        icon: const Icon(Icons.add_circle,
                            color: AppColors.primaryColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ..._items.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;

                    return _ItemFacturaWidget(
                      item: item,
                      onChanged: (nuevoItem) =>
                          _actualizarItem(index, nuevoItem),
                      onDelete: () => _eliminarItem(index),
                    );
                  }),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Totales y observaciones
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Totales y Observaciones',
                    style: AppFonts.bodyNormal.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 20),

                  TextFormField(
                    controller: _impuestoController,
                    decoration: const InputDecoration(
                      labelText: 'Impuesto (%)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => setState(() {}),
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _observacionesController,
                    decoration: const InputDecoration(
                      labelText: 'Observaciones',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 20),

                  // Resumen de totales
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        _buildTotalRow('Subtotal:', _subtotal),
                        _buildTotalRow('Descuentos:', -_totalDescuentos),
                        _buildTotalRow('Base Imponible:', _baseImponible),
                        _buildTotalRow('Impuesto:', _montoImpuesto),
                        const Divider(),
                        _buildTotalRow(
                          'TOTAL:',
                          _total,
                          isTotal: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Botón actualizar
            BtnElevated(
              text: 'Actualizar Factura',
              onPressed: _actualizarFactura,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalRow(String label, double valor, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppFonts.bodyNormal.copyWith(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
          Text(
            '\$${valor.toStringAsFixed(2)}',
            style: AppFonts.bodyNormal.copyWith(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
              color: isTotal ? AppColors.primaryColor : null,
            ),
          ),
        ],
      ),
    );
  }

  String _getTipoServicioText(TipoServicio tipo) {
    switch (tipo) {
      case TipoServicio.camara:
        return 'Cámara';
      case TipoServicio.instalacion:
        return 'Instalación';
      case TipoServicio.vehiculo:
        return 'Vehículo';
    }
  }

  String _getEstadoText(EstadoFactura estado) {
    switch (estado) {
      case EstadoFactura.pendiente:
        return 'Pendiente';
      case EstadoFactura.pagada:
        return 'Pagada';
      case EstadoFactura.vencida:
        return 'Vencida';
      case EstadoFactura.cancelada:
        return 'Cancelada';
    }
  }
}

class _ItemFacturaWidget extends StatefulWidget {
  final ItemFactura item;
  final Function(ItemFactura) onChanged;
  final VoidCallback onDelete;

  const _ItemFacturaWidget({
    required this.item,
    required this.onChanged,
    required this.onDelete,
  });

  @override
  State<_ItemFacturaWidget> createState() => _ItemFacturaWidgetState();
}

class _ItemFacturaWidgetState extends State<_ItemFacturaWidget> {
  late TextEditingController _descripcionController;
  late TextEditingController _cantidadController;
  late TextEditingController _precioController;
  late TextEditingController _descuentoController;

  @override
  void initState() {
    super.initState();
    _descripcionController =
        TextEditingController(text: widget.item.descripcion);
    _cantidadController =
        TextEditingController(text: widget.item.cantidad.toString());
    _precioController =
        TextEditingController(text: widget.item.precioUnitario.toString());
    _descuentoController =
        TextEditingController(text: widget.item.descuento.toString());
  }

  @override
  void dispose() {
    _descripcionController.dispose();
    _cantidadController.dispose();
    _precioController.dispose();
    _descuentoController.dispose();
    super.dispose();
  }

  void _updateItem() {
    final nuevoItem = ItemFactura(
      descripcion: _descripcionController.text,
      cantidad: int.tryParse(_cantidadController.text) ?? 1,
      precioUnitario: double.tryParse(_precioController.text) ?? 0.0,
      descuento: double.tryParse(_descuentoController.text) ?? 0.0,
    );
    widget.onChanged(nuevoItem);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _descripcionController,
                  decoration: const InputDecoration(
                    labelText: 'Descripción',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) => _updateItem(),
                ),
              ),
              IconButton(
                onPressed: widget.onDelete,
                icon: const Icon(Icons.delete, color: Colors.red),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _cantidadController,
                  decoration: const InputDecoration(
                    labelText: 'Cantidad',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (_) => _updateItem(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _precioController,
                  decoration: const InputDecoration(
                    labelText: 'Precio Unit.',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (_) => _updateItem(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _descuentoController,
                  decoration: const InputDecoration(
                    labelText: 'Desc. (%)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (_) => _updateItem(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Total: \$${widget.item.total.toStringAsFixed(2)}',
                style: AppFonts.bodyNormal.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
