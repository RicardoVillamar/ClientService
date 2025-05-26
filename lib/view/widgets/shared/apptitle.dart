import 'package:client_service/utils/colors.dart';
import 'package:client_service/utils/font.dart';
import 'package:client_service/view/widgets/shared/button.dart';
import 'package:flutter/material.dart';

class Apptitle extends StatelessWidget {
  final String title;

  const Apptitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          margin:
              const EdgeInsets.only(top: 10, left: 20, right: 10, bottom: 10),
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppColors.backgroundColor,
          ),
          child: BtnIcon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icons.arrow_back_ios_new_rounded),
        ),
        Text(title, style: AppFonts.subtitleBold),
      ],
    );
  }
}
