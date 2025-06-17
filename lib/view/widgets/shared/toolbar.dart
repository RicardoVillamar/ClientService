import 'package:client_service/utils/colors.dart';
import 'package:flutter/material.dart';

class Toolbar extends StatefulWidget {
  const Toolbar({super.key});

  @override
  State<Toolbar> createState() => _ToolbarState();
}

class _ToolbarState extends State<Toolbar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        color: AppColors.primaryColor,
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.home, size: 30),
            color: AppColors.whiteColor,
          ),
          IconButton(
            onPressed: () => Navigator.pushNamed(context, 'calendario'),
            icon: const Icon(Icons.calendar_month, size: 30),
            color: AppColors.secondaryColor,
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search, size: 30),
            color: AppColors.secondaryColor,
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.person, size: 30),
            color: AppColors.secondaryColor,
          ),
          IconButton(
            onPressed: () => Navigator.pushNamed(context, 'configuracion'),
            icon: const Icon(Icons.settings, size: 30),
            color: AppColors.secondaryColor,
          ),
        ],
      ),
    );
  }
}
