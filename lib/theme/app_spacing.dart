import 'package:responsive_sizer/responsive_sizer.dart';

class AppSpacing {
  AppSpacing._();

  // Calibration function to scale reference design pixels based on current screen size vs breakpoint reference
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

  static double get space2 => scale(2.0);
  static double get space4 => scale(4.0);
  static double get space6 => scale(6.0);
  static double get space8 => scale(8.0);
  static double get space10 => scale(10.0);
  static double get space12 => scale(12.0);
  static double get space14 => scale(14.0);
  static double get space16 => scale(16.0);
  static double get space20 => scale(20.0);
  static double get space24 => scale(24.0);
  static double get space32 => scale(32.0);
  static double get space40 => scale(40.0);
  static double get space48 => scale(48.0);
  static double get space64 => scale(64.0);
  static double get space88 => scale(88.0);
  static double get space96 => scale(96.0);

  static double get baseGrid => scale(8.0);
}
