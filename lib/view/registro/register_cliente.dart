import 'package:client_service/utils/colors.dart';
import 'package:client_service/view/widgets/shared/apptitle.dart';
import 'package:client_service/view/widgets/shared/button.dart';
import 'package:client_service/view/widgets/shared/inputs.dart';
import 'package:client_service/view/widgets/shared/toolbar.dart';
import 'package:client_service/models/cliente.dart';
import 'package:client_service/viewmodel/cliente_viewmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegistroClientePage extends StatefulWidget {
  const RegistroClientePage({super.key});

  @override
  State<RegistroClientePage> createState() => _RegistroClientePageState();
}

class _RegistroClientePageState extends State<RegistroClientePage> {
  double heightScreen = 0;
  double screenWidth = 0;
  String? selectValue;
  final _nombreC = TextEditingController();
  final _ruc = TextEditingController();
  final _direccion = TextEditingController();
  final _telefono = TextEditingController();
  final _correo = TextEditingController();
  final _personaContacto = TextEditingController();
  final _cedula = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final _clienteVM = ClienteViewModel();

  void _guardarCliente() {
    if (_formKey.currentState!.validate()) {
      final cliente = Cliente(
        nombreComercial: _nombreC.text.trim(),
        ruc: _ruc.text.trim(),
        direccion: _direccion.text.trim(),
        telefono: _telefono.text.trim(),
        correo: _correo.text.trim(),
        personaContacto: _personaContacto.text.trim(),
        cedula: _cedula.text.trim(),
      );

      _clienteVM.guardarCliente(cliente).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cliente guardado exitosamente')));
        _formKey.currentState!.reset();
      }).catchError((e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al guardar el cliente: $e')));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    heightScreen = MediaQuery.of(context).size.height;
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
            const Apptitle(title: 'Nuevo Cliente'),
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(
                  top: 20, left: 20, right: 20, bottom: 10),
              height: heightScreen * 0.70,
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
                            label: 'Nombre comercial*',
                            controller: _nombreC,
                            screenWidth: screenWidth,
                            showCounter: false,
                            maxLength: 20,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Campo requerido';
                              }
                              return null;
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^[a-zA-Z0-9 ]*$')),
                            ],
                          ),
                          TxtFields(
                            label: 'RUC*',
                            controller: _ruc,
                            screenWidth: screenWidth,
                            showCounter: false,
                            maxLength: 13,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Campo requerido';
                              }
                              if (value.length != 13) {
                                return 'El RUC debe tener 13 dígitos';
                              }
                              return null;
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^[0-9]*$')),
                            ],
                          ),
                          TxtFields(
                            label: 'Dirección*',
                            controller: _direccion,
                            screenWidth: screenWidth,
                            showCounter: false,
                            maxLength: 50,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Campo requerido';
                              }
                              return null;
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^[a-zA-Z0-9 ]*$')),
                            ],
                          ),
                          TxtFields(
                            label: 'Teléfono*',
                            controller: _telefono,
                            screenWidth: screenWidth,
                            showCounter: false,
                            maxLength: 10,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Campo requerido';
                              }
                              if (value.length != 10) {
                                return 'El teléfono debe tener 10 dígitos';
                              }
                              return null;
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^[0-9]*$')),
                            ],
                          ),
                          TxtFields(
                            label: 'Correo electronico*',
                            controller: _correo,
                            screenWidth: screenWidth,
                            showCounter: false,
                            maxLength: 50,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Campo requerido';
                              }
                              if (!RegExp(
                                      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                                  .hasMatch(value)) {
                                return 'Ingrese un correo electrónico válido';
                              }
                              return null;
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^[a-zA-Z0-9@._-]*$')),
                            ],
                          ),
                          TxtFields(
                            label: 'Persona de contacto*',
                            controller: _personaContacto,
                            screenWidth: screenWidth,
                            showCounter: false,
                            maxLength: 20,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Campo requerido';
                              }
                              return null;
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^[a-zA-Z ]*$')),
                            ],
                          ),
                          TxtFields(
                            label: 'Cédula de persona de contacto*',
                            controller: _cedula,
                            screenWidth: screenWidth,
                            showCounter: false,
                            maxLength: 10,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Campo requerido';
                              }
                              if (value.length != 10) {
                                return 'La cédula debe tener 10 dígitos';
                              }
                              return null;
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^[0-9]*$')),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          BtnElevated(
                            text: "Guardar",
                            onPressed: _guardarCliente,
                          ),
                        ],
                      ),
                    )),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: const Toolbar(),
    );
  }

  String? _required(String? value) {
    if (value == null || value.isEmpty) return 'Campo requerido';
    return null;
  }
}
