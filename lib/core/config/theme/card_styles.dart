import 'package:flutter/material.dart';
import 'package:formfrontend/core/config/theme/app_colors.dart';
import 'package:formfrontend/core/config/theme/app_radius.dart';
import 'package:formfrontend/core/config/theme/app_shadows.dart';

class AppCardStyles {
  AppCardStyles._();

  static CardThemeData get elevatedCardTheme {
    return CardThemeData(
      color: AppColors.pureWhite,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.borderXl,
        side: const BorderSide(color: AppColors.borderLight, width: 1.0),
      ),
    );
  }

  static CardThemeData get flatCardTheme {
    return CardThemeData(
      color: AppColors.pureWhite,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.borderXl,
        side: const BorderSide(color: AppColors.borderLight, width: 1.0),
      ),
    );
  }

  // BoxDecorations for manual containers
  static Decoration get elevatedDecoration {
    return BoxDecoration(
      color: AppColors.pureWhite,
      borderRadius: AppRadius.borderXl,
      border: const Border.fromBorderSide(
        BorderSide(color: AppColors.borderLight, width: 1.0),
      ),
      boxShadow: AppShadows.cardElevated,
    );
  }

  static Decoration get flatDecoration {
    return BoxDecoration(
      color: AppColors.pureWhite,
      borderRadius: AppRadius.borderXl,
      border: const Border.fromBorderSide(
        BorderSide(color: AppColors.borderLight, width: 1.0),
      ),
      boxShadow: AppShadows.cardFlat,
    );
  }
}
