import 'package:client_service/utils/colors.dart';
import 'package:client_service/view/home/widgets/category.dart';
import 'package:client_service/view/widgets/shared/search.dart';
import 'package:client_service/view/home/widgets/header.dart';
import 'package:client_service/view/home/widgets/section.dart';
import 'package:client_service/view/widgets/shared/toolbar.dart';
import 'package:client_service/utils/helpers/notificacion_helper.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: const Header(),
        backgroundColor: AppColors.backgroundColor,
        surfaceTintColor: AppColors.backgroundColor,
      ),
      body: Container(
        color: AppColors.backgroundColor,
        child: const Column(
          children: <Widget>[
            ContentPage(),
            Toolbar(),
          ],
        ),
      ),
      // Botón flotante temporal para probar notificaciones
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          print('DEBUG: Botón de prueba presionado');
          await NotificacionUtils.notificarServicioCreado(
            'prueba manual',
            'Cliente de prueba',
            DateTime.now(),
          );
          print('DEBUG: Notificación de prueba creada');
        },
        icon: const Icon(Icons.notification_add),
        label: const Text('Probar'),
        backgroundColor: AppColors.primaryColor,
      ),
    );
  }
}

class ContentPage extends StatefulWidget {
  const ContentPage({super.key});

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  String selectedCategory = 'Registros';

  void updateCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          const SearchBarPage(),
          CategoryPage(onCategorySelected: updateCategory),
          SectionPage(selectedCategory: selectedCategory),
        ],
      ),
    );
  }
}
