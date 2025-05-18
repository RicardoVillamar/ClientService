import 'package:client_service/utils/colors.dart';
import 'package:client_service/utils/font.dart';
import 'package:flutter/material.dart';

class Header extends StatefulWidget {
  const Header({super.key});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  double screenHeight = 0.0;
  final String nombre = 'Usuario';

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;

    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [Text('Hola! $nombre', style: AppFonts.titleBold)],
          ),
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(50),
                  border:
                      Border.all(color: AppColors.blackColor.withOpacity(0.1)),
                ),
                child: IconButton(
                  icon: const Icon(Icons.notifications),
                  color: AppColors.blackColor,
                  iconSize: 25,
                  onPressed: () => {},
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(50),
                  border:
                      Border.all(color: AppColors.blackColor.withOpacity(0.1)),
                ),
                child: IconButton(
                  icon: const Icon(Icons.settings),
                  color: AppColors.blackColor,
                  iconSize: 25,
                  onPressed: () => {},
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
