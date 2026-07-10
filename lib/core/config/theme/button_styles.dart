import 'package:flutter/material.dart';
import 'package:formfrontend/core/config/theme/app_colors.dart';
import 'package:formfrontend/core/config/theme/app_text_styles.dart';

class AppButtonStyles {
  AppButtonStyles._();

  static ButtonStyle get primary {
    return ElevatedButton.styleFrom(
      backgroundColor: AppColors.charcoal,
      foregroundColor: AppColors.pureWhite,
      elevation: 0,
      shape: const StadiumBorder(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      textStyle: AppTextStyles.labelMedium,
    );
  }

  static ButtonStyle get outlined {
    return OutlinedButton.styleFrom(
      backgroundColor: AppColors.pureWhite,
      foregroundColor: AppColors.charcoal,
      side: const BorderSide(color: AppColors.borderLight),
      shape: const StadiumBorder(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      textStyle: AppTextStyles.labelMedium,
    );
  }

  static ButtonStyle get ghost {
    return TextButton.styleFrom(
      backgroundColor: AppColors.surfaceSubtle,
      foregroundColor: AppColors.charcoal,
      shape: const StadiumBorder(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      textStyle: AppTextStyles.labelMedium,
    );
  }
}
