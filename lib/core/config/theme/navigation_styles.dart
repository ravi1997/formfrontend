import 'package:flutter/material.dart';
import 'package:formfrontend/core/config/theme/app_colors.dart';
import 'package:formfrontend/core/config/theme/app_radius.dart';
import 'package:formfrontend/core/config/theme/app_text_styles.dart';

class AppNavigationStyles {
  AppNavigationStyles._();

  static AppBarTheme get appBarTheme {
    return AppBarTheme(
      backgroundColor: AppColors.surfaceWhite,
      foregroundColor: AppColors.inkBlack,
      elevation: 0,
      centerTitle: false,
      iconTheme: const IconThemeData(color: AppColors.inkBlack),
      titleTextStyle: AppTextStyles.labelSmall,
    );
  }

  static NavigationBarThemeData get navigationBarTheme {
    return NavigationBarThemeData(
      backgroundColor: AppColors.pureWhite,
      indicatorColor: AppColors.surfaceSubtle,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppTextStyles.uiMicro.copyWith(
            color: AppColors.inkBlack,
            fontWeight: FontWeight.w600,
          );
        }
        return AppTextStyles.uiMicro.copyWith(color: AppColors.greyBody);
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: AppColors.inkBlack);
        }
        return const IconThemeData(color: AppColors.greyBody);
      }),
    );
  }

  static NavigationRailThemeData get navigationRailTheme {
    return NavigationRailThemeData(
      backgroundColor: AppColors.pureWhite,
      indicatorColor: AppColors.surfaceSubtle,
      selectedLabelTextStyle: AppTextStyles.uiMicro.copyWith(
        color: AppColors.inkBlack,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelTextStyle: AppTextStyles.uiMicro.copyWith(
        color: AppColors.greyBody,
      ),
      selectedIconTheme: const IconThemeData(color: AppColors.inkBlack),
      unselectedIconTheme: const IconThemeData(color: AppColors.greyBody),
    );
  }

  static DrawerThemeData get drawerTheme {
    return DrawerThemeData(
      backgroundColor: AppColors.pureWhite,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(
          right: Radius.circular(AppRadius.x2l),
        ),
      ),
    );
  }
}
