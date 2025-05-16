import 'package:client_service/widgets/category.dart';
import 'package:client_service/widgets/search.dart';
import 'package:client_service/widgets/header.dart';
import 'package:client_service/widgets/section.dart';
import 'package:client_service/widgets/toolbar.dart';
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
        backgroundColor: const Color(0xFFF3F5F8),
      ),
      body: Container(
        color: const Color(0xFFF3F5F8),
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
