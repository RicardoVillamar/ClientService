import 'package:client_service/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppFonts {
  static TextStyle get titleBold => GoogleFonts.nunito(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.textColor,
      );
  static TextStyle get titleNormal => GoogleFonts.nunito(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.textColor,
      );

  static TextStyle get subtitleBold => GoogleFonts.nunito(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.textColor,
      );
  static TextStyle get subtitleNormal => GoogleFonts.nunito(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: AppColors.textColor,
      );

  static TextStyle get bodyBold => GoogleFonts.nunito(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.textColor,
      );
  static TextStyle get bodyNormal => GoogleFonts.nunito(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.textColor,
      );

  static TextStyle get text => GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textColor,
      );
  static TextStyle get inputtext => GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: AppColors.greyColor,
      );

  static TextStyle get buttonBold => GoogleFonts.nunito(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.whiteColor,
      );
  static TextStyle get buttonNormal => GoogleFonts.nunito(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.whiteColor,
      );
}
