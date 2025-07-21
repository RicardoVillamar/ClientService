import 'package:client_service/models/instalacion.dart';
import 'package:client_service/models/empleado.dart';
import 'package:client_service/utils/colors.dart';
import 'package:client_service/utils/font.dart';
import 'package:client_service/utils/helpers/notificacion_helper.dart';
import 'package:client_service/view/widgets/shared/apptitle.dart';
import 'package:client_service/view/widgets/shared/button.dart';
import 'package:client_service/view/widgets/shared/inputs.dart';
import 'package:client_service/view/widgets/shared/toolbar.dart';
import 'package:client_service/viewmodel/instalacion_viewmodel.dart';
import 'package:client_service/viewmodel/empleado_viewmodel.dart';
import 'package:client_service/services/service_locator.dart';
import 'package:client_service/view/widgets/flash_messages.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:client_service/repositories/cliente_repository.dart';
import 'package:client_service/models/cliente.dart';

class RegistroInstalacion extends StatefulWidget {
  const RegistroInstalacion({super.key});

  @override
  State<RegistroInstalacion> createState() => _RegistroInstalacionState();
}

class _RegistroInstalacionState extends State<RegistroInstalacion> {
  String? cedulaClienteStatus; // For showing client found/not found
  double heightScreen = 0;

  // Date picker
  final TextEditingController _dateController = TextEditingController();

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

  // Time picker 1
  final TextEditingController _timeStartController = TextEditingController();

  Future<void> _selectTimeStart(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      final formattedTime = TimeOfDay(
        hour: picked.hour,
        minute: picked.minute,
      ).format(context);
      setState(() {
        _timeStartController.text = formattedTime;
      });
    }
  }

  // Time picker 2
  final TextEditingController _timeEndController = TextEditingController();

  Future<void> _selectTimeEnd(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      final formattedTime = TimeOfDay(
        hour: picked.hour,
        minute: picked.minute,
      ).format(context);
      setState(() {
        _timeEndController.text = formattedTime;
      });
    }
  }

  final TextEditingController _cedula = TextEditingController();
  final TextEditingController _nombreC = TextEditingController();
  final TextEditingController _direccion = TextEditingController();
  final TextEditingController _item = TextEditingController();
  final TextEditingController _descripcion = TextEditingController();
  final TextEditingController _telefono = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final List<String> datostrabajo = [
    'Cuadrilla',
  ];

  List<Empleado> observaciones = [];

  String? selectValueDatosTrabajo;
  String? selectValueObservaciones; // This will now store the cedula

  late final InstalacionViewModel _instalacionViewModel;
  final EmpleadoViewmodel _empleadoViewModel = sl<EmpleadoViewmodel>();

  @override
  void initState() {
    super.initState();
    _instalacionViewModel = sl<InstalacionViewModel>();
    _loadEmpleados();
  }

  void _loadEmpleados() async {
    observaciones = await _empleadoViewModel.obtenerEmpleados();
    setState(() {});
  }

  // Real client lookup in Firestore
  Future<void> _buscarClientePorCedula(String cedula) async {
    if (cedula.length == 10) {
      try {
        final repo = ClienteRepository();
        final clientes = await repo.getAll();
        Cliente? cliente;
        try {
          cliente = clientes.firstWhere((c) => c.cedula == cedula);
        } catch (_) {
          cliente = null;
        }
        setState(() {
          if (cliente != null) {
            cedulaClienteStatus =
                'Cliente encontrado: ${cliente.nombreComercial}';
            // Autocompletar si están vacíos
            if (_nombreC.text.isEmpty) _nombreC.text = cliente.nombreComercial;
            if (_direccion.text.isEmpty) _direccion.text = cliente.direccion;
            if (_telefono.text.isEmpty) _telefono.text = cliente.telefono;
          } else {
            cedulaClienteStatus =
                'No se encuentra un cliente con ese número de cédula.';
          }
        });
      } catch (e) {
        setState(() {
          cedulaClienteStatus = 'Error buscando cliente: $e';
        });
      }
    } else {
      setState(() {
        cedulaClienteStatus = null;
      });
    }
  }

  void _guardarInstalacion() async {
    if (_formKey.currentState!.validate()) {
      if (_dateController.text.isEmpty ||
          _cedula.text.isEmpty ||
          _nombreC.text.isEmpty ||
          _direccion.text.isEmpty ||
          _item.text.isEmpty ||
          _descripcion.text.isEmpty ||
          _timeStartController.text.isEmpty ||
          _timeEndController.text.isEmpty ||
          selectValueDatosTrabajo == null ||
          selectValueObservaciones == null ||
          _telefono.text.isEmpty) {
        FlashMessages.showWarning(
          context: context,
          message: 'Por favor complete todos los campos',
        );
        return;
      }

      try {
        // Autogenerate numeroTarea (e.g., timestamp or UUID)
        final autoNumeroTarea =
            DateTime.now().millisecondsSinceEpoch.toString();
        final instalacion = Instalacion(
          id: null,
          fechaInstalacion:
              DateFormat('dd/MM/yyyy').parse(_dateController.text),
          cedula: _cedula.text.trim(),
          nombreComercial: _nombreC.text.trim(),
          direccion: _direccion.text.trim(),
          item: _item.text.trim(),
          descripcion: _descripcion.text.trim(),
          horaInicio: _timeStartController.text.trim(),
          horaFin: _timeEndController.text.trim(),
          tipoTrabajo: selectValueDatosTrabajo!,
          cargoPuesto: selectValueObservaciones!,
          telefono: _telefono.text.trim(),
          numeroTarea: autoNumeroTarea,
        );

        await _instalacionViewModel.guardarInstalacion(instalacion);

        // Crear notificación del sistema
        await NotificacionUtils.notificarServicioCreado(
          'instalación de postes',
          _nombreC.text.trim(),
          DateFormat('dd/MM/yyyy').parse(_dateController.text),
        );

        FlashMessages.showSuccess(
          context: context,
          message: 'Instalación guardada exitosamente',
        );

        Navigator.pop(context);
      } catch (e) {
        FlashMessages.showError(
          context: context,
          message: 'Error al guardar: $e',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    heightScreen = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

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
              const Apptitle(title: 'Nueva Instalación'),
              Container(
                padding: const EdgeInsets.all(10),
                height: heightScreen * 0.81,
                decoration: const BoxDecoration(
                    color: AppColors.backgroundColor,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: SingleChildScrollView(
                  child: Form(
                      key: _formKey,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _dateController,
                              readOnly: true,
                              decoration: const InputDecoration(
                                labelText: 'Fecha de instalación',
                                suffixIcon: Icon(Icons.calendar_today),
                                border: OutlineInputBorder(),
                              ),
                              onTap: () => _selectDate(context),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Seleccione la fecha de instalación';
                                }
                                // Validate format dd/MM/yy
                                final regex = RegExp(r'^\d{2}/\d{2}/\d{4}$');
                                if (!regex.hasMatch(value)) {
                                  return 'Formato de fecha inválido (dd/mm/aa)';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            // Cedula: numérica, máx 10 dígitos, feedback
                            TextFormField(
                              controller: _cedula,
                              keyboardType: TextInputType.number,
                              maxLength: 10,
                              decoration: const InputDecoration(
                                labelText: 'Cédula de cliente*',
                                border: OutlineInputBorder(),
                                counterText: '',
                              ),
                              onChanged: (value) {
                                // Only allow digits
                                final filtered =
                                    value.replaceAll(RegExp(r'[^0-9]'), '');
                                if (filtered != value) {
                                  _cedula.text = filtered;
                                  _cedula.selection =
                                      TextSelection.fromPosition(TextPosition(
                                          offset: filtered.length));
                                }
                                _buscarClientePorCedula(filtered);
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Ingrese la cédula';
                                }
                                if (value.length != 10) {
                                  return 'La cédula debe tener 10 dígitos';
                                }
                                if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                                  return 'Solo se permiten números';
                                }
                                return null;
                              },
                            ),
                            if (cedulaClienteStatus != null)
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 4, bottom: 8),
                                child: Text(
                                  cedulaClienteStatus!,
                                  style: TextStyle(
                                    color: cedulaClienteStatus!
                                            .startsWith('Cliente encontrado')
                                        ? Colors.green
                                        : Colors.red,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            // Nombre comercial: solo letras y espacios, máx 50
                            TextFormField(
                              controller: _nombreC,
                              maxLength: 50,
                              decoration: const InputDecoration(
                                labelText: 'Nombre comercial del cliente*',
                                border: OutlineInputBorder(),
                                counterText: '',
                              ),
                              onChanged: (value) {
                                final filtered = value.replaceAll(
                                    RegExp(r'[^a-zA-ZáéíóúÁÉÍÓÚüÜñÑ\s]'), '');
                                if (filtered != value) {
                                  _nombreC.text = filtered;
                                  _nombreC.selection =
                                      TextSelection.fromPosition(TextPosition(
                                          offset: filtered.length));
                                }
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Ingrese el nombre comercial';
                                }
                                if (value.length > 50) {
                                  return 'Máximo 50 caracteres';
                                }
                                if (!RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚüÜñÑ\s]+$')
                                    .hasMatch(value)) {
                                  return 'Solo letras y espacios';
                                }
                                return null;
                              },
                            ),
                            // Dirección: máx 200, letras, números, caracteres especiales
                            TextFormField(
                              controller: _direccion,
                              maxLength: 200,
                              decoration: const InputDecoration(
                                labelText: 'Dirección de instalación*',
                                border: OutlineInputBorder(),
                                counterText: '',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Ingrese la dirección';
                                }
                                if (value.length > 200) {
                                  return 'Máximo 200 caracteres';
                                }
                                // Allow any character
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.backgroundColor,
                                border: Border.all(
                                  color: AppColors.greyColor,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'Datos del trabajo',
                                    style: AppFonts.bodyNormal,
                                  ),
                                  TxtFields(
                                    label: 'Item*',
                                    controller: _item,
                                    screenWidth: screenWidth,
                                    showCounter: false,
                                    maxLength: 50,
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    controller: _descripcion,
                                    maxLines: null,
                                    keyboardType: TextInputType.multiline,
                                    decoration: const InputDecoration(
                                      labelText: 'Descripcion*',
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppColors.greyColor,
                                        ),
                                      ),
                                      alignLabelWithHint: true,
                                    ),
                                  ),
                                  const SizedBox(height: 25),
                                  TextFormField(
                                    controller: _timeStartController,
                                    readOnly: true,
                                    decoration: const InputDecoration(
                                      labelText: 'Hora de inicio',
                                      suffixIcon: Icon(Icons.access_time),
                                      border: OutlineInputBorder(),
                                    ),
                                    onTap: () => _selectTimeStart(context),
                                  ),
                                  const SizedBox(height: 25),
                                  TextFormField(
                                    controller: _timeEndController,
                                    readOnly: true,
                                    decoration: const InputDecoration(
                                      labelText: 'Hora de finalizacion',
                                      suffixIcon: Icon(Icons.access_time),
                                      border: OutlineInputBorder(),
                                    ),
                                    onTap: () => _selectTimeEnd(context),
                                  ),
                                  const SizedBox(height: 15),
                                  DropdownButton(
                                    isExpanded: true,
                                    hint: Text(
                                      'Tipo',
                                      style: AppFonts.inputtext,
                                    ),
                                    value: selectValueDatosTrabajo,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectValueDatosTrabajo = newValue;
                                      });
                                    },
                                    items: datostrabajo.map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ),
                            const SizedBox(height: 40),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.backgroundColor,
                                border: Border.all(
                                  color: AppColors.greyColor,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'Observaciones',
                                    style: AppFonts.bodyNormal,
                                  ),
                                  const SizedBox(height: 15),
                                  DropdownButton(
                                    isExpanded: true,
                                    hint: Text(
                                      'Cargo o Puesto',
                                      style: AppFonts.inputtext,
                                    ),
                                    value: selectValueObservaciones,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectValueObservaciones = newValue;
                                      });
                                    },
                                    items:
                                        observaciones.map((Empleado empleado) {
                                      return DropdownMenuItem<String>(
                                        value: empleado.cedula,
                                        child: Text(
                                            empleado.nombreCompletoConCargo),
                                      );
                                    }).toList(),
                                  ),
                                  TxtFields(
                                    label: 'Telefono*',
                                    controller: _telefono,
                                    screenWidth: screenWidth,
                                    showCounter: false,
                                  ),
                                  // Numero de tarea is now auto-generated, not user input
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: BtnElevated(
                                  text: 'Guardar',
                                  onPressed: () {
                                    _guardarInstalacion();
                                  }),
                            ),
                          ],
                        ),
                      )),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const Toolbar());
  }
}
