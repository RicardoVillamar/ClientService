import 'package:client_service/utils/colors.dart';
import 'package:client_service/utils/font.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TxtFields extends StatelessWidget {
  final String label;
  final double screenWidth;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final bool showCounter;
  final int maxLength;
  final Function(String)? onChanged;

  const TxtFields({
    super.key,
    required this.label,
    required this.controller,
    required this.screenWidth,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.inputFormatters = const [],
    this.showCounter = true,
    this.maxLength = 10,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: maxLength,
      controller: controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      decoration: InputDecoration(
        counterText: showCounter ? null : '',
        labelText: label,
        labelStyle: AppFonts.inputtext,
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.colorError),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: AppColors.colorError,
          ),
        ),
      ),
      onChanged: onChanged,
    );
  }
}
