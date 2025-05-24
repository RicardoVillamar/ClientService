import 'package:client_service/utils/colors.dart';
import 'package:client_service/utils/font.dart';
import 'package:client_service/view/widgets/shared/inputs.dart';
import 'package:flutter/material.dart';

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
                          label: 'Nombre comercial',
                          controller: _nombreC,
                          screenWidth: screenWidth,
                          showCounter: false,
                        ),
                        TxtFields(
                          label: 'Direccion',
                          controller: _direccion,
                          screenWidth: screenWidth,
                          showCounter: false,
                        ),
                        TxtFields(
                          label: 'Telefono',
                          controller: _telefono,
                          screenWidth: screenWidth,
                          showCounter: false,
                        ),
                        TxtFields(
                          label: 'Correo electronico',
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
                                children: [],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
