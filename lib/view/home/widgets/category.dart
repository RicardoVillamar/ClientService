import 'package:client_service/utils/colors.dart';
import 'package:client_service/utils/font.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryPage extends StatefulWidget {
  final Function(String) onCategorySelected;

  const CategoryPage({super.key, required this.onCategorySelected});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<String> categories = [
    'Registros',
    'Facturación',
    'Servicios',
    'Reportes'
  ];

  String? selectedCategory;

  final TextStyle styleIconText = GoogleFonts.nunito(
    color: Colors.black,
    fontSize: 12,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(left: 20),
          child: Text('Categorías', style: AppFonts.bodyBold),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: categories.map((categories) {
            return Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(68),
                    color: AppColors.primaryColor,
                  ),
                  child: IconButton(
                    onPressed: () {
                      widget.onCategorySelected(categories);
                    },
                    icon: Icon(getIconForCategory(categories)),
                    iconSize: 34,
                    color: AppColors.whiteColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    categories,
                    style: styleIconText,
                  ),
                )
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  IconData getIconForCategory(String category) {
    switch (category) {
      case 'Registros':
        return Icons.person_add_alt_1_sharp;
      case 'Facturación':
        return Icons.menu_book_rounded;
      case 'Servicios':
        return Icons.home_repair_service_rounded;
      case 'Reportes':
        return Icons.book;
      default:
        return Icons.help;
    }
  }
}
