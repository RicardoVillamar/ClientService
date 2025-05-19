import 'package:client_service/utils/colors.dart';
import 'package:client_service/utils/font.dart';
import 'package:client_service/view/widgets/shared/button.dart';
import 'package:client_service/view/widgets/shared/inputs.dart';
import 'package:client_service/view/widgets/shared/toolbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RegistroInstalacion extends StatefulWidget {
  const RegistroInstalacion({super.key});

  @override
  State<RegistroInstalacion> createState() => _RegistroInstalacionState();
}

class _RegistroInstalacionState extends State<RegistroInstalacion> {
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
      final now = DateTime.now();
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
      final now = DateTime.now();
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
  final TextEditingController _numeroTarea = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final List<String> datostrabajo = [
    'Cuadrilla',
  ];

  final List<String> observaciones = [
    'Técnico',
    'Conductor',
    'Excavador',
    'Electricista',
    'Ayudante',
  ];

  String? selectValueDatosTrabajo;
  String? selectValueObservaciones;

  @override
  Widget build(BuildContext context) {
    heightScreen = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
              color: Color.fromARGB(255, 170, 174, 208),
              gradient: LinearGradient(colors: [
                Color.fromARGB(255, 170, 174, 208),
                AppColors.backgroundColor
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: ListView(
            children: [
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                        top: 10, left: 20, right: 10, bottom: 10),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppColors.backgroundColor,
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      iconSize: 18,
                    ),
                  ),
                  Text('Nuevo instalacion', style: AppFonts.subtitleBold),
                ],
              ),
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
                            ),
                            const SizedBox(height: 10),
                            TxtFields(
                              label: 'Numero de cedula*',
                              controller: _cedula,
                              screenWidth: screenWidth,
                              showCounter: false,
                            ),
                            TxtFields(
                              label: 'Nombre comercial*',
                              controller: _nombreC,
                              screenWidth: screenWidth,
                              showCounter: false,
                            ),
                            TxtFields(
                              label: 'Direccion de instalacion*',
                              controller: _direccion,
                              screenWidth: screenWidth,
                              showCounter: false,
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
                                    items: observaciones.map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                  TxtFields(
                                    label: 'Telefono*',
                                    controller: _telefono,
                                    screenWidth: screenWidth,
                                    showCounter: false,
                                  ),
                                  TxtFields(
                                    label: 'Numero de tarea',
                                    controller: _numeroTarea,
                                    screenWidth: screenWidth,
                                    showCounter: false,
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: BtnElevated(
                                  text: 'Guardar',
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      // Perform save operation
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text('Instalacion guardada'),
                                        ),
                                      );
                                    }
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
