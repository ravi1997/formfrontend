import 'package:flutter/material.dart';
import 'package:formfrontend/theme/app_colors.dart';
import 'package:formfrontend/theme/app_radius.dart';
import 'package:formfrontend/theme/app_spacing.dart';
import 'package:formfrontend/theme/app_text_styles.dart';
import 'package:formfrontend/theme/button_styles.dart';
import 'package:formfrontend/theme/card_styles.dart';
import 'package:formfrontend/theme/input_styles.dart';
import 'package:formfrontend/theme/navigation_styles.dart';
import 'package:formfrontend/theme/theme_extensions.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      scaffoldBackgroundColor: AppColors.surfaceBackground,

      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.charcoal,
        onPrimary: AppColors.pureWhite,
        secondary: AppColors.slateMid,
        onSecondary: AppColors.pureWhite,
        error: Colors.red,
        onError: AppColors.pureWhite,
        surface: AppColors.surfaceBackground,
        onSurface: AppColors.inkBlack,
        outline: AppColors.borderLight,
      ),

      // Typography
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayHeading,
        displayMedium: AppTextStyles.sectionHeading,
        displaySmall: AppTextStyles.cardHeading,
        titleLarge: AppTextStyles.labelLarge,
        titleMedium: AppTextStyles.labelSmall,
        titleSmall: AppTextStyles.labelMedium,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        labelLarge: AppTextStyles.labelLarge,
        labelMedium: AppTextStyles.labelMedium,
        labelSmall: AppTextStyles.uiMicro,
      ),

      // Components
      cardTheme: AppCardStyles.elevatedCardTheme,
      inputDecorationTheme: AppInputStyles.inputDecorationTheme,
      appBarTheme: AppNavigationStyles.appBarTheme,
      navigationBarTheme: AppNavigationStyles.navigationBarTheme,
      navigationRailTheme: AppNavigationStyles.navigationRailTheme,
      drawerTheme: AppNavigationStyles.drawerTheme,

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: AppButtonStyles.primary,
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: AppButtonStyles.outlined,
      ),
      textButtonTheme: TextButtonThemeData(style: AppButtonStyles.ghost),

      // Other Theme elements based on tokens
      dividerTheme: DividerThemeData(
        color: AppColors.borderLight,
        thickness: 1.0,
        space: AppSpacing.space16,
      ),

      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceSubtle,
        disabledColor: AppColors.surfaceSubtle.withValues(alpha: 0.5),
        selectedColor: AppColors.charcoal,
        secondarySelectedColor: AppColors.slateMid,
        labelStyle: AppTextStyles.uiMicro.copyWith(color: AppColors.inkBlack),
        secondaryLabelStyle: AppTextStyles.uiMicro.copyWith(
          color: AppColors.pureWhite,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.space8,
          vertical: AppSpacing.space4,
        ),
        shape: const StadiumBorder(
          side: BorderSide(color: AppColors.borderLight, width: 1.0),
        ),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.pureWhite,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.borderXl),
        titleTextStyle: AppTextStyles.cardHeading,
        contentTextStyle: AppTextStyles.bodyLarge,
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.pureWhite,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(
              AppRadius.xl,
            ), // Modified to match exactly radius-xl or xl token dynamically
          ),
        ),
      ),

      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.charcoal;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(AppColors.pureWhite),
        side: const BorderSide(color: AppColors.borderLight, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.borderSm),
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.pureWhite;
          }
          return AppColors.greyMuted;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.charcoal;
          }
          return AppColors.surfaceSubtle;
        }),
      ),

      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.charcoal;
          }
          return AppColors.greyBody;
        }),
      ),

      sliderTheme: const SliderThemeData(
        activeTrackColor: AppColors.charcoal,
        inactiveTrackColor: AppColors.surfaceSubtle,
        thumbColor: AppColors.charcoal,
        overlayColor: Colors.black12,
      ),

      iconTheme: const IconThemeData(color: AppColors.inkBlack, size: 24.0),

      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.charcoal,
          borderRadius: AppRadius.borderSm,
        ),
        textStyle: const TextStyle(color: AppColors.pureWhite, fontSize: 12.0),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.inkBlack,
        contentTextStyle: const TextStyle(color: AppColors.pureWhite),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.borderMd),
      ),

      listTileTheme: ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.space16,
          vertical: AppSpacing.space8,
        ),
        iconColor: AppColors.slateMid,
        textColor: AppColors.inkBlack,
      ),

      extensions: const [AppDesignTokens.light],
    );
  }
}
