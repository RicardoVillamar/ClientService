import 'package:client_service/utils/colors.dart';
import 'package:client_service/utils/font.dart';
import 'package:client_service/view/widgets/shared/button.dart';
import 'package:client_service/view/widgets/shared/inputs.dart';
import 'package:client_service/view/widgets/shared/toolbar.dart';
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
        _dateController.text = formattedDate;
      });
    }
  }

  String? selectValue;
  List<String> personal = [
    'Tipo 1',
    'Tipo 2',
    'Tipo 3',
    'Tipo 4',
  ];

  @override
  Widget build(BuildContext context) {
    final heightScreen = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
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
                Text(
                  'Alquiler de vehículos',
                  style: AppFonts.subtitleBold,
                ),
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
                              const Row(
                                children: [
                                  // radio buttons

                                  Radio(
                                    value: 1,
                                    groupValue: 0,
                                    onChanged: null,
                                  ),
                                  Text('Tipo 1'),

                                  SizedBox(width: 20),
                                  Radio(
                                    value: 2,
                                    groupValue: 0,
                                    onChanged: null,
                                  ),

                                  Text('Tipo 2'),

                                  SizedBox(width: 20),

                                  Radio(
                                    value: 3,
                                    groupValue: 0,
                                    onChanged: null,
                                  ),

                                  Text('Tipo 3'),
                                ],
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
                          controller: _nombreC,
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
                          items: personal.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),
                        BtnElevated(text: 'Registro', onPressed: () {})
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
