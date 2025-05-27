import 'package:client_service/utils/colors.dart';
import 'package:client_service/view/widgets/shared/apptitle.dart';
import 'package:client_service/view/widgets/shared/button.dart';
import 'package:client_service/view/widgets/shared/search.dart';
import 'package:client_service/view/widgets/shared/toolbar.dart';
import 'package:flutter/material.dart';

class ReportCamara extends StatefulWidget {
  const ReportCamara({super.key});

  @override
  State<ReportCamara> createState() => _ReportCamaraState();
}

class _ReportCamaraState extends State<ReportCamara> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: AppColors.backgroundColor,
        ),
        child: ListView(
          children: [
            const Apptitle(title: 'Reporte de Camaras', isVisible: true),
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
