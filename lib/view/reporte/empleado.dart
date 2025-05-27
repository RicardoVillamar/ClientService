import 'package:client_service/utils/colors.dart';
import 'package:client_service/view/widgets/shared/apptitle.dart';
import 'package:client_service/view/widgets/shared/button.dart';
import 'package:client_service/view/reporte/widgets/cardcustoms.dart';
import 'package:client_service/view/widgets/shared/search.dart';
import 'package:client_service/view/widgets/shared/toolbar.dart';
import 'package:flutter/material.dart';

class ReportEmpleado extends StatefulWidget {
  const ReportEmpleado({super.key});

  @override
  State<ReportEmpleado> createState() => _ReportEmpleadoState();
}

class _ReportEmpleadoState extends State<ReportEmpleado> {
  double heightScreen = 0;

  @override
  Widget build(BuildContext context) {
    heightScreen = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: AppColors.backgroundColor,
        ),
        child: ListView(
          children: [
            const Apptitle(title: 'Reporte de Empleado', isVisible: true),
            const SearchBarPage(),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: AppColors.backgroundColor,
              ),
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  CardIMG(
                    icon: const Icon(Icons.arrow_forward_ios_rounded,
                        color: AppColors.primaryColor),
                    onPressed: () {},
                  ),
                  CardTXT(
                    icon: const Icon(Icons.arrow_forward_ios_rounded,
                        color: AppColors.primaryColor),
                    onPressed: () {},
                  ),
                  CardIMG(
                    showIcon: false,
                    icon: const Icon(Icons.arrow_forward_ios_rounded,
                        color: AppColors.primaryColor),
                    onPressed: () {},
                  ),
                ],
              )),
            ),
          ],
        ),
      ),
      floatingActionButton: BtnFloating(
          onPressed: () {}, icon: Icons.download_rounded, text: 'Descargar'),
      bottomNavigationBar: const Toolbar(),
    );
  }
}
