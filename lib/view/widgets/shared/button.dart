import 'package:client_service/utils/colors.dart';
import 'package:client_service/utils/font.dart';
import 'package:flutter/material.dart';

class BtnElevated extends StatelessWidget {
  final String text;
  final Function()? onPressed;

  const BtnElevated({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(190, 50),
        backgroundColor: AppColors.btnColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: Text(
        text,
        style: AppFonts.buttonBold,
      ),
      onPressed: () {},
    );
  }
}

class BtnFloating extends StatelessWidget {
  final Function()? onPressed;
  final IconData icon;
  final String text;
  const BtnFloating(
      {super.key,
      required this.onPressed,
      required this.icon,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: AppColors.btnColor,
      onPressed: () {},
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: AppFonts.buttonBold,
          ),
          const SizedBox(width: 8),
          Icon(
            icon,
            color: AppColors.whiteColor,
          ),
        ],
      ),
    );
  }
}
