import 'package:client_service/utils/colors.dart';
import 'package:client_service/view/widgets/shared/button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegistroClientePage extends StatefulWidget {
  const RegistroClientePage({super.key});

  @override
  State<RegistroClientePage> createState() => _RegistroClientePageState();
}

class _RegistroClientePageState extends State<RegistroClientePage> {
  double heightScreen = 0;
  @override
  Widget build(BuildContext context) {
    heightScreen = MediaQuery.of(context).size.height;
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
                Text('Nuevo cliente',
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
                    child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Nombre comercial*',
                          labelStyle: GoogleFonts.nunito(
                            color: Colors.black54,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'RUC*',
                          labelStyle: GoogleFonts.nunito(
                            color: Colors.black54,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Dirección*',
                          labelStyle: GoogleFonts.nunito(
                            color: Colors.black54,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Telefono*',
                          labelStyle: GoogleFonts.nunito(
                            color: Colors.black54,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Correo Electronico*',
                          labelStyle: GoogleFonts.nunito(
                            color: Colors.black54,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Persona de contacto*',
                          labelStyle: GoogleFonts.nunito(
                            color: Colors.black54,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Cedula de persona de contacto*',
                          labelStyle: GoogleFonts.nunito(
                            color: Colors.black54,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      BtnElevated(text: "Guardar", onPressed: () {}),
                    ],
                  ),
                )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
