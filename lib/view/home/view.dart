import 'package:client_service/utils/colors.dart';
import 'package:client_service/view/home/widgets/category.dart';
import 'package:client_service/view/home/widgets/header.dart';
import 'package:client_service/view/home/widgets/section.dart';
import 'package:client_service/view/widgets/shared/toolbar.dart';
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
      extendBody: true,
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        toolbarHeight: 80,
        title: const Header(),
        backgroundColor: AppColors.backgroundColor,
        surfaceTintColor: AppColors.backgroundColor,
      ),
      body: Container(
        color: AppColors.backgroundColor,
        child: const ContentPage(),
      ),
      bottomNavigationBar: const Toolbar(),
    );
  }
}

class ContentPage extends StatefulWidget {
  const ContentPage({super.key});

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  String selectedCategory = 'Servicios';

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
          // SearchBarPage eliminado
          CategoryPage(onCategorySelected: updateCategory),
          SectionPage(selectedCategory: selectedCategory),
        ],
      ),
    );
  }
}
