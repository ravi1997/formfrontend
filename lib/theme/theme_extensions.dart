import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:formfrontend/theme/app_colors.dart';
import 'package:formfrontend/theme/app_shadows.dart';

@immutable
class AppDesignTokens extends ThemeExtension<AppDesignTokens> {
  const AppDesignTokens({
    required this.pureWhite,
    required this.surfaceSubtle,
    required this.surfaceWhite,
    required this.charcoal,
    required this.greyBody,
    required this.greyMuted,
    required this.inkBlack,
    required this.slateMid,
    required this.borderLight,
    required this.cardElevated,
    required this.cardFlat,
    required this.buttonDark,
    required this.buttonDarkHover,
  });

  final Color pureWhite;
  final Color surfaceSubtle;
  final Color surfaceWhite;
  final Color charcoal;
  final Color greyBody;
  final Color greyMuted;
  final Color inkBlack;
  final Color slateMid;
  final Color borderLight;

  final List<BoxShadow> cardElevated;
  final List<BoxShadow> cardFlat;
  final List<BoxShadow> buttonDark;
  final List<BoxShadow> buttonDarkHover;

  static const AppDesignTokens light = AppDesignTokens(
    pureWhite: AppColors.pureWhite,
    surfaceSubtle: AppColors.surfaceSubtle,
    surfaceWhite: AppColors.surfaceWhite,
    charcoal: AppColors.charcoal,
    greyBody: AppColors.greyBody,
    greyMuted: AppColors.greyMuted,
    inkBlack: AppColors.inkBlack,
    slateMid: AppColors.slateMid,
    borderLight: AppColors.borderLight,
    cardElevated: AppShadows.cardElevated,
    cardFlat: AppShadows.cardFlat,
    buttonDark: AppShadows.buttonDark,
    buttonDarkHover: AppShadows.buttonDarkHover,
  );

  @override
  AppDesignTokens copyWith({
    Color? pureWhite,
    Color? surfaceSubtle,
    Color? surfaceWhite,
    Color? charcoal,
    Color? greyBody,
    Color? greyMuted,
    Color? inkBlack,
    Color? slateMid,
    Color? borderLight,
    List<BoxShadow>? cardElevated,
    List<BoxShadow>? cardFlat,
    List<BoxShadow>? buttonDark,
    List<BoxShadow>? buttonDarkHover,
  }) {
    return AppDesignTokens(
      pureWhite: pureWhite ?? this.pureWhite,
      surfaceSubtle: surfaceSubtle ?? this.surfaceSubtle,
      surfaceWhite: surfaceWhite ?? this.surfaceWhite,
      charcoal: charcoal ?? this.charcoal,
      greyBody: greyBody ?? this.greyBody,
      greyMuted: greyMuted ?? this.greyMuted,
      inkBlack: inkBlack ?? this.inkBlack,
      slateMid: slateMid ?? this.slateMid,
      borderLight: borderLight ?? this.borderLight,
      cardElevated: cardElevated ?? this.cardElevated,
      cardFlat: cardFlat ?? this.cardFlat,
      buttonDark: buttonDark ?? this.buttonDark,
      buttonDarkHover: buttonDarkHover ?? this.buttonDarkHover,
    );
  }

  @override
  AppDesignTokens lerp(ThemeExtension<AppDesignTokens>? other, double t) {
    if (other is! AppDesignTokens) {
      return this;
    }
    return AppDesignTokens(
      pureWhite: Color.lerp(pureWhite, other.pureWhite, t)!,
      surfaceSubtle: Color.lerp(surfaceSubtle, other.surfaceSubtle, t)!,
      surfaceWhite: Color.lerp(surfaceWhite, other.surfaceWhite, t)!,
      charcoal: Color.lerp(charcoal, other.charcoal, t)!,
      greyBody: Color.lerp(greyBody, other.greyBody, t)!,
      greyMuted: Color.lerp(greyMuted, other.greyMuted, t)!,
      inkBlack: Color.lerp(inkBlack, other.inkBlack, t)!,
      slateMid: Color.lerp(slateMid, other.slateMid, t)!,
      borderLight: Color.lerp(borderLight, other.borderLight, t)!,
      cardElevated: BoxShadow.lerpList(cardElevated, other.cardElevated, t)!,
      cardFlat: BoxShadow.lerpList(cardFlat, other.cardFlat, t)!,
      buttonDark: BoxShadow.lerpList(buttonDark, other.buttonDark, t)!,
      buttonDarkHover: BoxShadow.lerpList(
        buttonDarkHover,
        other.buttonDarkHover,
        t,
      )!,
    );
  }
}

// Extension to provide dynamic screen width responsive resizing that triggers repaint/rebuild on window changes
extension ResponsiveDesignExtension on BuildContext {
  double responsiveScale(double referenceValue) {
    final width = MediaQuery.sizeOf(this).width;
    double referenceWidth = 1200.0; // Desktop default

    if (width <= 809.98) {
      referenceWidth = 375.0; // Mobile reference
    } else if (width <= 1199.98) {
      referenceWidth = 810.0; // Tablet reference
    }

    return referenceValue * (width / referenceWidth);
  }

  // Spacing Units
  double get space2 => responsiveScale(2.0);
  double get space4 => responsiveScale(4.0);
  double get space6 => responsiveScale(6.0);
  double get space8 => responsiveScale(8.0);
  double get space10 => responsiveScale(10.0);
  double get space12 => responsiveScale(12.0);
  double get space14 => responsiveScale(14.0);
  double get space16 => responsiveScale(16.0);
  double get space20 => responsiveScale(20.0);
  double get space24 => responsiveScale(24.0);
  double get space32 => responsiveScale(32.0);
  double get space40 => responsiveScale(40.0);
  double get space48 => responsiveScale(48.0);
  double get space64 => responsiveScale(64.0);
  double get space88 => responsiveScale(88.0);
  double get space96 => responsiveScale(96.0);

  // Border Radius
  double get radiusSm => responsiveScale(6.0);
  double get radiusMd => responsiveScale(8.0);
  double get radiusLg => responsiveScale(12.0);
  double get radiusXl => responsiveScale(16.0);
  double get radius2xl => responsiveScale(24.0);
  double get radius3xl => responsiveScale(32.0);
  double get radiusPill => responsiveScale(999.0);

  // BorderRadius Helpers
  BorderRadius get borderSm => BorderRadius.all(Radius.circular(radiusSm));
  BorderRadius get borderMd => BorderRadius.all(Radius.circular(radiusMd));
  BorderRadius get borderLg => BorderRadius.all(Radius.circular(radiusLg));
  BorderRadius get borderXl => BorderRadius.all(Radius.circular(radiusXl));
  BorderRadius get border2xl => BorderRadius.all(Radius.circular(radius2xl));
  BorderRadius get border3xl => BorderRadius.all(Radius.circular(radius3xl));
  BorderRadius get borderPill => BorderRadius.all(Radius.circular(radiusPill));

  // Typography Scaling
  TextStyle get displayHeading => GoogleFonts.lora(
    fontSize: responsiveScale(56.0),
    fontWeight: FontWeight.w600,
    height: 64.0 / 56.0,
    letterSpacing: -1.12,
    color: AppColors.inkBlack,
  );

  TextStyle get sectionHeading => GoogleFonts.lora(
    fontSize: responsiveScale(36.0),
    fontWeight: FontWeight.w600,
    height: 48.0 / 36.0,
    letterSpacing: -0.72,
    color: AppColors.inkBlack,
  );

  TextStyle get cardHeading => GoogleFonts.lora(
    fontSize: responsiveScale(32.0),
    fontWeight: FontWeight.w600,
    height: 48.0 / 32.0,
    color: AppColors.inkBlack,
  );

  TextStyle get bodyLarge => GoogleFonts.instrumentSans(
    fontSize: responsiveScale(16.0),
    fontWeight: FontWeight.w400,
    height: 24.0 / 16.0,
    letterSpacing: -0.32,
    color: AppColors.greyBody,
  );

  TextStyle get bodyMedium => GoogleFonts.instrumentSans(
    fontSize: responsiveScale(14.0),
    fontWeight: FontWeight.w400,
    height: 20.0 / 14.0,
    letterSpacing: -0.14,
    color: AppColors.greyBody,
  );

  TextStyle get labelMedium => GoogleFonts.instrumentSans(
    fontSize: responsiveScale(14.0),
    fontWeight: FontWeight.w500,
    height: 20.0 / 14.0,
    letterSpacing: -0.14,
    color: AppColors.inkBlack,
  );

  TextStyle get labelLarge => GoogleFonts.instrumentSans(
    fontSize: responsiveScale(20.0),
    fontWeight: FontWeight.w500,
    height: 30.0 / 20.0,
    letterSpacing: -0.8,
    color: AppColors.inkBlack,
  );

  TextStyle get labelSmall => GoogleFonts.instrumentSans(
    fontSize: responsiveScale(18.0),
    fontWeight: FontWeight.w500,
    height: 28.0 / 18.0,
    letterSpacing: -0.36,
    color: AppColors.inkBlack,
  );

  TextStyle get uiMicro => GoogleFonts.inter(
    fontSize: responsiveScale(13.0),
    fontWeight: FontWeight.w500,
    height: 15.6 / 13.0,
    color: AppColors.greyMuted,
  );
}
