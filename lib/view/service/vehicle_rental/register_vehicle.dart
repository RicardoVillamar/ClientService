import 'package:client_service/models/vehiculo.dart';
import 'package:client_service/models/empleado.dart';
import 'package:client_service/utils/colors.dart';
import 'package:client_service/utils/font.dart';
import 'package:client_service/view/widgets/shared/apptitle.dart';
import 'package:client_service/view/widgets/shared/button.dart';
import 'package:client_service/view/widgets/shared/inputs.dart';
import 'package:client_service/view/widgets/shared/toolbar.dart';
import 'package:client_service/viewmodel/vehiculo_viewmodel.dart';
import 'package:client_service/viewmodel/empleado_viewmodel.dart';
import 'package:client_service/services/service_locator.dart';
import 'package:client_service/view/widgets/flash_messages.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RegistroAlquiler extends StatefulWidget {
  const RegistroAlquiler({super.key});

  @override
  State<RegistroAlquiler> createState() => _RegistroAlquilerState();
}

class _RegistroAlquilerState extends State<RegistroAlquiler> {
  final TextEditingController _nombreC = TextEditingController();
  final TextEditingController _direccion = TextEditingController();
  final TextEditingController _telefono = TextEditingController();
  final TextEditingController _correo = TextEditingController();
  final TextEditingController _monto = TextEditingController();
  final AlquilerViewModel _alquilerVM = sl<AlquilerViewModel>();
  final EmpleadoViewmodel _empleadoViewModel = sl<EmpleadoViewmodel>();

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

  // Date picker
  final TextEditingController _dateControllerTrabajo = TextEditingController();

  Future<void> _selectDateTrabajo(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      final formattedDate = DateFormat('dd/MM/yyyy').format(picked);
      setState(() {
        _dateControllerTrabajo.text = formattedDate;
      });
    }
  }

  String? selectValue;
  List<Empleado> personal = [];

  List<String> tiposVehiculo = ['Tipo 1', 'Tipo 2', 'Tipo 3', 'Tipo 4'];
  String tipoVehiculoSeleccionado = 'Tipo 1';

  @override
  void initState() {
    super.initState();
    _loadEmpleados();
  }

  void _loadEmpleados() async {
    personal = await _empleadoViewModel.obtenerEmpleados();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final heightScreen = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
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
            const Apptitle(title: 'Alquiler de vehiculo'),
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
                        TxtFields(
                          label: 'Nombre comercial*',
                          controller: _nombreC,
                          screenWidth: screenWidth,
                          showCounter: false,
                        ),
                        TxtFields(
                          label: 'Direccion*',
                          controller: _direccion,
                          screenWidth: screenWidth,
                          showCounter: false,
                        ),
                        TxtFields(
                          label: 'Telefono*',
                          controller: _telefono,
                          screenWidth: screenWidth,
                          showCounter: false,
                        ),
                        TxtFields(
                          label: 'Correo electronico*',
                          controller: _correo,
                          screenWidth: screenWidth,
                          showCounter: false,
                        ),
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
                                'Tipo de vehiculo',
                                style: AppFonts.bodyNormal,
                              ),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 20,
                                children: tiposVehiculo.map((tipo) {
                                  return Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Radio<String>(
                                        value: tipo,
                                        groupValue: tipoVehiculoSeleccionado,
                                        onChanged: (value) {
                                          setState(() {
                                            tipoVehiculoSeleccionado = value!;
                                          });
                                        },
                                      ),
                                      Text(tipo),
                                    ],
                                  );
                                }).toList(),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _dateController,
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: 'Fecha de reserva',
                            suffixIcon: Icon(Icons.calendar_today),
                            border: OutlineInputBorder(),
                          ),
                          onTap: () => _selectDate(context),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _dateControllerTrabajo,
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: 'Fecha de trabajo',
                            suffixIcon: Icon(Icons.calendar_today),
                            border: OutlineInputBorder(),
                          ),
                          onTap: () => _selectDateTrabajo(context),
                        ),
                        const SizedBox(height: 20),
                        TxtFields(
                          label: 'Monto alquiler*',
                          controller: _monto,
                          screenWidth: screenWidth,
                          showCounter: false,
                        ),
                        const SizedBox(height: 20),
                        DropdownButton(
                          isExpanded: true,
                          hint: Text(
                            'Personal que asistió*',
                            style: AppFonts.inputtext,
                          ),
                          value: selectValue,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectValue = newValue;
                            });
                          },
                          items: personal.map((Empleado empleado) {
                            return DropdownMenuItem<String>(
                              value: '${empleado.nombre} ${empleado.apellido}',
                              child: Text(
                                  '${empleado.nombre} ${empleado.apellido} - ${empleado.cargo}'),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),
                        BtnElevated(
                          text: 'Registro',
                          onPressed: () async {
                            if (_nombreC.text.isEmpty ||
                                _direccion.text.isEmpty ||
                                _telefono.text.isEmpty ||
                                _correo.text.isEmpty ||
                                _monto.text.isEmpty ||
                                _dateController.text.isEmpty ||
                                _dateControllerTrabajo.text.isEmpty ||
                                selectValue == null) {
                              FlashMessages.showWarning(
                                context: context,
                                message: 'Por favor llena todos los campos',
                              );
                              return;
                            }

                            try {
                              final alquiler = Alquiler(
                                nombreComercial: _nombreC.text.trim(),
                                direccion: _direccion.text.trim(),
                                telefono: _telefono.text.trim(),
                                correo: _correo.text.trim(),
                                tipoVehiculo: tipoVehiculoSeleccionado,
                                fechaReserva: DateFormat('dd/MM/yyyy')
                                    .parse(_dateController.text),
                                fechaTrabajo: DateFormat('dd/MM/yyyy')
                                    .parse(_dateControllerTrabajo.text),
                                montoAlquiler:
                                    double.tryParse(_monto.text.trim()) ?? 0,
                                personalAsistio: selectValue!,
                              );

                              await _alquilerVM.guardarAlquiler(alquiler);

                              FlashMessages.showSuccess(
                                context: context,
                                message: 'Alquiler registrado exitosamente',
                              );

                              Navigator.pop(context); // cerrar la pantalla
                            } catch (e) {
                              FlashMessages.showError(
                                context: context,
                                message: 'Error al guardar: $e',
                              );
                            }
                          },
                        ),
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
