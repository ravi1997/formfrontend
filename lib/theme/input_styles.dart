import 'package:flutter/material.dart';
import 'package:formfrontend/theme/app_colors.dart';
import 'package:formfrontend/theme/app_radius.dart';
import 'package:formfrontend/theme/app_spacing.dart';
import 'package:formfrontend/theme/app_text_styles.dart';

class AppInputStyles {
  AppInputStyles._();

  static InputDecorationTheme get inputDecorationTheme {
    return InputDecorationTheme(
      filled: true,
      fillColor: AppColors.pureWhite,
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppSpacing.space16,
        vertical: AppSpacing.space16,
      ),
      labelStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.slateMid),
      hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.greyMuted),
      errorStyle: AppTextStyles.bodyMedium.copyWith(color: Colors.red[700]),
      border: OutlineInputBorder(
        borderRadius: AppRadius.borderMd,
        borderSide: const BorderSide(color: AppColors.borderLight, width: 1.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppRadius.borderMd,
        borderSide: const BorderSide(color: AppColors.borderLight, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppRadius.borderMd,
        borderSide: const BorderSide(color: AppColors.inkBlack, width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppRadius.borderMd,
        borderSide: BorderSide(color: Colors.red[700]!, width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: AppRadius.borderMd,
        borderSide: BorderSide(color: Colors.red[700]!, width: 2.0),
      ),
    );
  }
}
