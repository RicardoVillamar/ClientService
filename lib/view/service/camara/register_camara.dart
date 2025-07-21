import 'package:flutter/material.dart';
import 'package:client_service/models/camara.dart';
import 'package:client_service/models/empleado.dart';
import 'package:client_service/utils/colors.dart';
import 'package:client_service/utils/font.dart';
import 'package:client_service/utils/helpers/notificacion_helper.dart';
import 'package:client_service/view/widgets/shared/apptitle.dart';
import 'package:client_service/view/widgets/shared/button.dart';
import 'package:client_service/view/widgets/shared/toolbar.dart';
import 'package:client_service/viewmodel/camara_viewmodel.dart';
import 'package:client_service/viewmodel/empleado_viewmodel.dart';
import 'package:client_service/services/service_locator.dart';
import 'package:client_service/view/widgets/flash_messages.dart';
import 'package:intl/intl.dart';
import 'package:client_service/repositories/cliente_repository.dart';
import 'package:client_service/models/cliente.dart';

class RegistroCamara extends StatefulWidget {
  const RegistroCamara({super.key});

  @override
  State<RegistroCamara> createState() => _RegistroCamaraState();
}

class _RegistroCamaraState extends State<RegistroCamara> {
  String? selectTecnico;
  List<Empleado> tecnicos = [];
  // Eliminado campo tipo
  final CamaraViewModel _camaraViewModel = sl<CamaraViewModel>();
  final EmpleadoViewmodel _empleadoViewModel = sl<EmpleadoViewmodel>();

  @override
  void initState() {
    super.initState();
    _loadEmpleados();
  }

  void _loadEmpleados() async {
    tecnicos = await _empleadoViewModel.obtenerEmpleados();
    // Si el técnico seleccionado ya no está en la lista, resetear selectTecnico
    if (selectTecnico != null &&
        !tecnicos.any((e) => e.cedula == selectTecnico)) {
      selectTecnico = null;
    }
    setState(() {});
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      final formattedDate = DateFormat('dd/MM/yyyy').format(picked);
      setState(() {
        _dateController.text = formattedDate;
      });
    }
  }

  void _registrarMantenimiento() async {
    if (_nombreC.text.isEmpty ||
        _direccion.text.isEmpty ||
        _dateController.text.isEmpty ||
        _observaciones.text.isEmpty ||
        _costo.text.isEmpty ||
        selectTecnico == null) {
      FlashMessages.showWarning(
        context: context,
        message: 'Por favor complete todos los campos',
      );
      return;
    }

    try {
      final mantenimiento = Camara(
        id: null,
        nombreComercial: _nombreC.text.trim(),
        direccion: _direccion.text.trim(),
        tecnico: selectTecnico!,
        fechaMantenimiento:
            DateFormat('dd/MM/yyyy').parse(_dateController.text),
        descripcion: _observaciones.text.trim(),
        costo: double.tryParse(_costo.text.trim()) ?? 0,
      );

      await _camaraViewModel.guardarCamara(mantenimiento);

      // Crear notificación del sistema
      await NotificacionUtils.notificarServicioCreado(
        'mantenimiento de cámaras',
        _nombreC.text.trim(),
        DateFormat('dd/MM/yyyy').parse(_dateController.text),
      );

      FlashMessages.showSuccess(
        context: context,
        message: 'Mantenimiento registrado exitosamente',
      );

      // Cerrar la pantalla actual
      Navigator.pop(context);
    } catch (e) {
      FlashMessages.showError(
        context: context,
        message: 'Error al guardar: $e',
      );
    }
  }

  String? clienteStatus;
  // Buscar cliente por nombre comercial y autocompletar dirección
  Future<void> _buscarClientePorNombreComercial(String nombre) async {
    if (nombre.trim().isEmpty) {
      setState(() {
        clienteStatus = null;
      });
      return;
    }
    try {
      final repo = ClienteRepository();
      final clientes = await repo.getAll();
      Cliente? cliente;
      try {
        cliente = clientes.firstWhere((c) =>
            c.nombreComercial.toLowerCase() == nombre.trim().toLowerCase());
      } catch (_) {
        cliente = null;
      }
      setState(() {
        if (cliente != null) {
          clienteStatus = 'Cliente encontrado: ${cliente.nombreComercial}';
          if (_direccion.text.isEmpty) _direccion.text = cliente.direccion;
        } else {
          clienteStatus =
              'No se encuentra un cliente con ese nombre comercial.';
        }
      });
    } catch (e) {
      setState(() {
        clienteStatus = 'Error buscando cliente: $e';
      });
    }
  }

  final TextEditingController _nombreC = TextEditingController();
  final TextEditingController _direccion = TextEditingController();
  final TextEditingController _observaciones = TextEditingController();
  final TextEditingController _costo = TextEditingController();

  // Date picker
  final TextEditingController _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final heightScreen = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            color: AppColors.accentColor,
            gradient: LinearGradient(
                colors: [AppColors.accentColor, AppColors.backgroundColor],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
        child: ListView(
          children: [
            const Apptitle(title: 'Mantenimiento de Camara'),
            Container(
              padding: const EdgeInsets.all(10),
              height: heightScreen * 0.81,
              decoration: const BoxDecoration(
                  color: AppColors.backgroundColor,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: SingleChildScrollView(
                child: Form(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nombreC,
                          decoration: const InputDecoration(
                            labelText: 'Nombre comercial del cliente*',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            _buscarClientePorNombreComercial(value);
                          },
                        ),
                        if (clienteStatus != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4, bottom: 8),
                            child: Text(
                              clienteStatus!,
                              style: TextStyle(
                                color: clienteStatus!
                                        .startsWith('Cliente encontrado')
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _dateController,
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: 'Fecha de mantenimiento',
                            suffixIcon: Icon(Icons.calendar_today),
                            border: OutlineInputBorder(),
                          ),
                          onTap: () => _selectDate(context),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _direccion,
                          decoration: const InputDecoration(
                            labelText: 'Dirección de instalación*',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 15),
                        DropdownButton(
                          isExpanded: true,
                          hint: Text(
                            'Técnico',
                            style: AppFonts.inputtext,
                          ),
                          value: selectTecnico,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectTecnico = newValue;
                            });
                          },
                          items: tecnicos.map((Empleado empleado) {
                            return DropdownMenuItem<String>(
                              value: empleado.cedula,
                              child: Text(empleado.nombreCompletoConCargo),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),
                        // Eliminado DropdownButton de tipo
                        TextFormField(
                          controller: _observaciones,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          decoration: const InputDecoration(
                            labelText: 'Observaciones',
                            alignLabelWithHint: true,
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _costo,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Costo*',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        BtnElevated(
                            onPressed: _registrarMantenimiento,
                            text: 'Registrar'),
                        const SizedBox(height: 5),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: const Toolbar(),
    );
  }
}
