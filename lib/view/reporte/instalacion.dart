import 'package:client_service/utils/colors.dart';
import 'package:client_service/view/widgets/shared/apptitle.dart';
import 'package:client_service/view/widgets/shared/button.dart';
import 'package:client_service/view/widgets/shared/search.dart';
import 'package:client_service/view/widgets/shared/toolbar.dart';
import 'package:flutter/material.dart';

class ReportInstalacion extends StatefulWidget {
  const ReportInstalacion({super.key});

  @override
  State<ReportInstalacion> createState() => _ReportInstalacionState();
}

class _ReportInstalacionState extends State<ReportInstalacion> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: AppColors.backgroundColor,
        ),
        child: ListView(
          children: [
            const Apptitle(title: 'Reporte de Instalaciones', isVisible: true),
            const SearchBarPage(),
          ],
        ),
      ),
      floatingActionButton: BtnFloating(
          onPressed: () {}, icon: Icons.download_rounded, text: 'Descargar'),
      bottomNavigationBar: const Toolbar(),
    );
  }
}
