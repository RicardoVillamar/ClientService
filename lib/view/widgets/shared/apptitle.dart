import 'package:client_service/utils/colors.dart';
import 'package:client_service/utils/font.dart';
import 'package:client_service/view/widgets/shared/button.dart';
import 'package:flutter/material.dart';

class Apptitle extends StatelessWidget {
  final bool isVisible;
  final String title;

  const Apptitle({super.key, required this.title, this.isVisible = false});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BtnIcon(
              onPressed: () => Navigator.pop(context),
              icon: Icons.arrow_back_ios_new_rounded,
              bg: AppColors.backgroundColor,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: AppFonts.subtitleBold,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isVisible)
              Container(
                margin: const EdgeInsets.only(left: 8),
                child: BtnIcon(
                  onPressed: () {},
                  icon: Icons.delete_rounded,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
