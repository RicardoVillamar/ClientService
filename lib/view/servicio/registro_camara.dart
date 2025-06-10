import 'package:client_service/models/camara.dart';
import 'package:client_service/utils/colors.dart';
import 'package:client_service/utils/font.dart';
import 'package:client_service/view/widgets/shared/apptitle.dart';
import 'package:client_service/view/widgets/shared/button.dart';
import 'package:client_service/view/widgets/shared/inputs.dart';
import 'package:client_service/view/widgets/shared/toolbar.dart';
import 'package:client_service/viewmodel/camara_viewmodel.dart';
import 'package:client_service/services/service_locator.dart';
import 'package:client_service/view/widgets/flash_messages.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RegistroCamara extends StatefulWidget {
  const RegistroCamara({super.key});

  @override
  State<RegistroCamara> createState() => _RegistroCamaraState();
}

class _RegistroCamaraState extends State<RegistroCamara> {
  final TextEditingController _nombreC = TextEditingController();
  final TextEditingController _direccion = TextEditingController();
  final TextEditingController _observaciones = TextEditingController();
  final TextEditingController _costo = TextEditingController();

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

  String? selectTecnico;
  List<String> tecnico = [
    'Tecnico 1',
    'Tecnico 2',
    'Tecnico 3',
    'Tecnico 4',
  ];

  String? selectTipo;
  List<String> tipo = [
    'Tipo 1',
    'Tipo 2',
    'Tipo 3',
    'Tipo 4',
  ];
  final CamaraViewModel _camaraViewModel = sl<CamaraViewModel>();

  void _registrarMantenimiento() async {
    if (_nombreC.text.isEmpty ||
        _direccion.text.isEmpty ||
        _dateController.text.isEmpty ||
        _observaciones.text.isEmpty ||
        _costo.text.isEmpty ||
        selectTecnico == null ||
        selectTipo == null) {
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
        tipo: selectTipo!,
        fechaMantenimiento:
            DateFormat('dd/MM/yyyy').parse(_dateController.text),
        descripcion: _observaciones.text.trim(),
        costo: double.tryParse(_costo.text.trim()) ?? 0,
      );

      await _camaraViewModel.guardarCamara(mantenimiento);

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
                        TxtFields(
                          label: 'Nombre comercial del cliente*',
                          controller: _nombreC,
                          screenWidth: screenWidth,
                          showCounter: false,
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
                        TxtFields(
                          label: 'Dirección de instalación*',
                          controller: _direccion,
                          screenWidth: screenWidth,
                          showCounter: false,
                        ),
                        const SizedBox(height: 15),
                        DropdownButton(
                          isExpanded: true,
                          hint: Text(
                            'Tecnico',
                            style: AppFonts.inputtext,
                          ),
                          value: selectTecnico,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectTecnico = newValue;
                            });
                          },
                          items: tecnico.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),
                        DropdownButton(
                          isExpanded: true,
                          hint: Text(
                            'Tipo',
                            style: AppFonts.inputtext,
                          ),
                          value: selectTipo,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectTipo = newValue;
                            });
                          },
                          items: tipo.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _observaciones,
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
                        const SizedBox(height: 10),
                        TxtFields(
                          label: 'Costo de mantenimiento*',
                          controller: _costo,
                          screenWidth: screenWidth,
                          showCounter: false,
                        ),
                        const SizedBox(height: 10),
                        BtnElevated(
                            text: 'Registrar',
                            onPressed: _registrarMantenimiento),
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
