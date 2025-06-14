import 'package:client_service/utils/colors.dart';
import 'package:client_service/view/widgets/shared/apptitle.dart';
import 'package:client_service/view/widgets/shared/button.dart';
import 'package:client_service/view/widgets/shared/inputs.dart';
import 'package:client_service/view/widgets/shared/toolbar.dart';
import 'package:client_service/models/cliente.dart';
import 'package:client_service/viewmodel/cliente_viewmodel.dart';
import 'package:client_service/services/service_locator.dart';
import 'package:client_service/view/widgets/flash_messages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditClientePage extends StatefulWidget {
  final Cliente cliente;

  const EditClientePage({super.key, required this.cliente});

  @override
  State<EditClientePage> createState() => _EditClientePageState();
}

class _EditClientePageState extends State<EditClientePage> {
  double heightScreen = 0;
  double screenWidth = 0;
  final _nombreC = TextEditingController();
  final _ruc = TextEditingController();
  final _direccion = TextEditingController();
  final _telefono = TextEditingController();
  final _correo = TextEditingController();
  final _personaContacto = TextEditingController();
  final _cedula = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late final ClienteViewModel _clienteVM;

  @override
  void initState() {
    super.initState();
    _clienteVM = sl<ClienteViewModel>();
    _initializeFields();
  }

  void _initializeFields() {
    _nombreC.text = widget.cliente.nombreComercial;
    _ruc.text = widget.cliente.ruc;
    _direccion.text = widget.cliente.direccion;
    _telefono.text = widget.cliente.telefono;
    _correo.text = widget.cliente.correo;
    _personaContacto.text = widget.cliente.personaContacto;
    _cedula.text = widget.cliente.cedula;
  }

  void _actualizarCliente() {
    if (_formKey.currentState!.validate()) {
      final clienteActualizado = Cliente(
        id: widget.cliente.id,
        nombreComercial: _nombreC.text.trim(),
        ruc: _ruc.text.trim(),
        direccion: _direccion.text.trim(),
        telefono: _telefono.text.trim(),
        correo: _correo.text.trim(),
        personaContacto: _personaContacto.text.trim(),
        cedula: _cedula.text.trim(),
      );

      _clienteVM.actualizarCliente(clienteActualizado).then((success) {
        if (success && context.mounted) {
          FlashMessages.showSuccess(
            context: context,
            message: 'Cliente actualizado exitosamente',
          );
          Navigator.pop(context, true); // Return true to indicate success
        }
      }).catchError((e) {
        if (context.mounted) {
          FlashMessages.showError(
            context: context,
            message: 'Error al actualizar el cliente: $e',
          );
        }
      });
    } else {
      if (context.mounted) {
        FlashMessages.showWarning(
          context: context,
          message: 'Completa todos los campos obligatorios',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    heightScreen = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

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
            const Apptitle(title: 'Editar Cliente'),
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
                            text: "Actualizar",
                            onPressed: _actualizarCliente,
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
}
