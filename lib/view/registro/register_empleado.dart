import 'dart:io';

import 'package:client_service/utils/colors.dart';
import 'package:client_service/utils/font.dart';
import 'package:client_service/view/widgets/shared/button.dart';
import 'package:client_service/view/widgets/shared/inputs.dart';
import 'package:client_service/view/widgets/shared/toolbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class RegistroEmpleadoPage extends StatefulWidget {
  const RegistroEmpleadoPage({super.key});

  @override
  State<RegistroEmpleadoPage> createState() => _RegistroEmpleadoPageState();
}

class _RegistroEmpleadoPageState extends State<RegistroEmpleadoPage> {
  double heightScreen = 0;
  final List<String> items = [
    'Técnico',
    'Conductor',
    'Excavador',
    'Electricista',
    'Ayudante',
  ];

  String? selectValue;
  final TextEditingController _nombre = TextEditingController();
  final TextEditingController _apellido = TextEditingController();
  final TextEditingController _cedula = TextEditingController();
  final TextEditingController _direccion = TextEditingController();
  final TextEditingController _telefono = TextEditingController();
  final TextEditingController _correo = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();

  //Date picker
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

  //Image picker
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
    Navigator.pop(context);
  }

  void _showPickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galería'),
              onTap: () => _pickImage(ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Cámara'),
              onTap: () => _pickImage(ImageSource.camera),
            ),
          ],
        ),
      ),
    );
  }

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
                Text('Nuevo Empleado', style: AppFonts.subtitleBold),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(
                  top: 20, left: 20, right: 20, bottom: 10),
              height: heightScreen * 0.75,
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
                        TxtFields(
                          label: 'Nombres*',
                          controller: _nombre,
                          screenWidth: screenWidth,
                          showCounter: false,
                          maxLength: 20,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingrese su nombre';
                            }
                            if (value.length > 20) {
                              return 'El nombre no puede tener más de 20 caracteres';
                            }
                            return null;
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^[a-zA-Z\s]+$')),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TxtFields(
                          label: 'Apellidos*',
                          controller: _apellido,
                          screenWidth: screenWidth,
                          showCounter: false,
                          maxLength: 20,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingrese su apellido';
                            }
                            if (value.length > 20) {
                              return 'El apellido no puede tener más de 20 caracteres';
                            }
                            return null;
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^[a-zA-Z\s]+$')),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TxtFields(
                          label: 'Numero de Cedula*',
                          controller: _cedula,
                          screenWidth: screenWidth,
                          showCounter: false,
                          maxLength: 10,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingrese su número de cédula';
                            }
                            if (value.length != 10) {
                              return 'La cédula debe tener 10 dígitos';
                            }
                            return null;
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                        TxtFields(
                          label: 'Direccion*',
                          controller: _direccion,
                          screenWidth: screenWidth,
                          showCounter: false,
                          maxLength: 50,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingrese su dirección';
                            }
                            return null;
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^[a-zA-Z0-9\s]+$')),
                          ],
                        ),
                        TxtFields(
                          label: 'Telefono*',
                          controller: _telefono,
                          screenWidth: screenWidth,
                          showCounter: false,
                          maxLength: 10,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingrese su número de teléfono';
                            }
                            if (value.length != 10) {
                              return 'El teléfono debe tener 10 dígitos';
                            }
                            return null;
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                        TxtFields(
                          label: 'Correo Electronico*',
                          controller: _correo,
                          screenWidth: screenWidth,
                          showCounter: false,
                          maxLength: 50,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingrese su correo electrónico';
                            }
                            if (!RegExp(
                                    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                                .hasMatch(value)) {
                              return 'Por favor ingrese un correo electrónico válido';
                            }
                            return null;
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^[a-zA-Z0-9@._-]+$')),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        DropdownButton(
                          isExpanded: true,
                          hint: Text(
                            'Cargo o Puesto',
                            style: AppFonts.inputtext,
                          ),
                          value: selectValue,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectValue = newValue;
                            });
                          },
                          items: items.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _dateController,
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: 'Fecha de contratación*',
                            labelStyle: TextStyle(
                              color: AppColors.greyColor,
                            ),
                            suffixIcon: Icon(Icons.calendar_today),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              borderSide: BorderSide(
                                color: AppColors.greyColor,
                              ),
                            ),
                          ),
                          onTap: () => _selectDate(context),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: _showPickerOptions,
                          child: Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.greyColor),
                              borderRadius: BorderRadius.circular(10),
                              color: AppColors.backgroundColor,
                            ),
                            child: _imageFile != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.file(
                                      _imageFile!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                                  )
                                : const Center(
                                    child: Icon(
                                      Icons.add_a_photo,
                                      size: 40,
                                      color: AppColors.greyColor,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        BtnElevated(text: "Registrar", onPressed: () {}),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const Toolbar(),
    );
  }
}
