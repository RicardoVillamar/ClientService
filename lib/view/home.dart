import 'package:client_service/utils/colors.dart';
import 'package:client_service/widgets/home/category.dart';
import 'package:client_service/widgets/shared/search.dart';
import 'package:client_service/widgets/header.dart';
import 'package:client_service/widgets/home/section.dart';
import 'package:client_service/widgets/shared/toolbar.dart';
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
