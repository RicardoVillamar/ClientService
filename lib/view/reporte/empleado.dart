import 'package:client_service/utils/colors.dart';
import 'package:client_service/view/widgets/shared/apptitle.dart';
import 'package:client_service/view/widgets/shared/cardcustoms.dart';
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

  final _formKey = GlobalKey<FormState>();

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
            const Apptitle(title: 'Reporte de Empleado'),
            const SearchBarPage(),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: AppColors.backgroundColor,
              ),
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  Cardcustom(
                    icon:
                        const Icon(Icons.person, color: AppColors.primaryColor),
                    onPressed: () {}, // Add your onPressed function here
                  ),
                  Cardcustom(
                    showIcon: false,
                    icon:
                        const Icon(Icons.person, color: AppColors.primaryColor),
                    onPressed: () {}, // Add your onPressed function here
                  ),
                ],
              )),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const Toolbar(),
    );
  }
}
