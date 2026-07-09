import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AppRadius {
  AppRadius._();

  // Calibration function to scale reference corner roundings based on screen size vs breakpoint reference
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

  static double get sm => scale(6.0);
  static double get md => scale(8.0);
  static double get lg => scale(12.0);
  static double get xl => scale(16.0);
  static double get x2l => scale(24.0);
  static double get x3l => scale(32.0);
  static double get pill => scale(999.0);

  // BorderRadius helpers
  static BorderRadius get borderSm => BorderRadius.all(Radius.circular(sm));
  static BorderRadius get borderMd => BorderRadius.all(Radius.circular(md));
  static BorderRadius get borderLg => BorderRadius.all(Radius.circular(lg));
  static BorderRadius get borderXl => BorderRadius.all(Radius.circular(xl));
  static BorderRadius get border2xl => BorderRadius.all(Radius.circular(x2l));
  static BorderRadius get border3xl => BorderRadius.all(Radius.circular(x3l));
  static BorderRadius get borderPill => BorderRadius.all(Radius.circular(pill));
}
