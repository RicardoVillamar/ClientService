import 'package:client_service/utils/colors.dart';
import 'package:client_service/utils/font.dart';
import 'package:client_service/view/widgets/shared/button.dart';
import 'package:client_service/view/widgets/shared/inputs.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

  @override
  Widget build(BuildContext context) {
    heightScreen = MediaQuery.of(context).size.height;

    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            color: Color.fromARGB(255, 170, 174, 208),
            gradient: LinearGradient(
                colors: [Color.fromARGB(255, 170, 174, 208), Color(0xFFF3F5F8)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
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
                    color: const Color(0xFFF3F5F8),
                  ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    iconSize: 18,
                  ),
                ),
                Text('Nuevo Empleado',
                    style: GoogleFonts.nunito(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                    )),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(
                  top: 20, left: 20, right: 20, bottom: 10),
              height: heightScreen * 0.70,
              decoration: const BoxDecoration(
                  color: Color(0xFFF3F5F8),
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
                          ),
                          TxtFields(
                            label: 'Apellidos*',
                            controller: _apellido,
                            screenWidth: screenWidth,
                            showCounter: false,
                          ),
                          TxtFields(
                            label: 'Numero de Cedula*',
                            controller: _cedula,
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
                            label: 'Correo Electronico*',
                            controller: _correo,
                            screenWidth: screenWidth,
                            showCounter: false,
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
                          BtnElevated(text: "Registrar", onPressed: () {}),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
