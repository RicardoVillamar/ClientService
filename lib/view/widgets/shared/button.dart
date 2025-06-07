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
      onPressed: onPressed,
      child: Text(
        text,
        style: AppFonts.buttonBold,
      ),
    );
  }
}

class BtnFloating extends StatelessWidget {
  final Function()? onPressed;
  final IconData icon;
  final String text;
  final bool? isVisible;
  const BtnFloating({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.text,
    this.isVisible = true,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor:
          isVisible == true ? AppColors.btnColor : AppColors.primaryColor,
      onPressed: isVisible == true ? onPressed : null,
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

class BtnIcon extends StatelessWidget {
  final Function() onPressed;
  final IconData? icon;
  final Color? bg;
  final Color? color;
  const BtnIcon({
    super.key,
    required this.onPressed,
    required this.icon,
    this.bg,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: 18,
        color: color ?? AppColors.blackColor,
      ),
      color: bg ?? AppColors.whiteColor,
    );
  }
}
