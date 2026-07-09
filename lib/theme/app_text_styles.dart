import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:formfrontend/theme/app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // Calibration function to scale reference design typography sizes based on screen size vs breakpoint reference
  static double scale(double referenceValue) {
    final width = Device.width;
    double referenceWidth = 1200.0; // Desktop default

    if (width <= 809.98) {
      referenceWidth = 375.0; // Mobile reference
    } else if (width <= 1199.98) {
      referenceWidth = 810.0; // Tablet reference
    }

    return referenceValue * (width / referenceWidth);
  }

  static TextStyle get displayHeading => GoogleFonts.lora(
    fontSize: scale(56.0),
    fontWeight: FontWeight.w600,
    height: 64.0 / 56.0,
    letterSpacing: -1.12,
    color: AppColors.inkBlack,
  );

  static TextStyle get sectionHeading => GoogleFonts.lora(
    fontSize: scale(36.0),
    fontWeight: FontWeight.w600,
    height: 48.0 / 36.0,
    letterSpacing: -0.72,
    color: AppColors.inkBlack,
  );

  static TextStyle get cardHeading => GoogleFonts.lora(
    fontSize: scale(32.0),
    fontWeight: FontWeight.w600,
    height: 48.0 / 32.0,
    color: AppColors.inkBlack,
  );

  static TextStyle get bodyLarge => GoogleFonts.instrumentSans(
    fontSize: scale(16.0),
    fontWeight: FontWeight.w400,
    height: 24.0 / 16.0,
    letterSpacing: -0.32,
    color: AppColors.greyBody,
  );

  static TextStyle get bodyMedium => GoogleFonts.instrumentSans(
    fontSize: scale(14.0),
    fontWeight: FontWeight.w400,
    height: 20.0 / 14.0,
    letterSpacing: -0.14,
    color: AppColors.greyBody,
  );

  static TextStyle get labelMedium => GoogleFonts.instrumentSans(
    fontSize: scale(14.0),
    fontWeight: FontWeight.w500,
    height: 20.0 / 14.0,
    letterSpacing: -0.14,
    color: AppColors.inkBlack,
  );

  static TextStyle get labelLarge => GoogleFonts.instrumentSans(
    fontSize: scale(20.0),
    fontWeight: FontWeight.w500,
    height: 30.0 / 20.0,
    letterSpacing: -0.8,
    color: AppColors.inkBlack,
  );

  static TextStyle get labelSmall => GoogleFonts.instrumentSans(
    fontSize: scale(18.0),
    fontWeight: FontWeight.w500,
    height: 28.0 / 18.0,
    letterSpacing: -0.36,
    color: AppColors.inkBlack,
  );

  static TextStyle get uiMicro => GoogleFonts.inter(
    fontSize: scale(13.0),
    fontWeight: FontWeight.w500,
    height: 15.6 / 13.0,
    color: AppColors.greyMuted,
  );
}
