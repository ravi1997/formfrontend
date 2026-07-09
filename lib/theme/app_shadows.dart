import 'package:flutter/material.dart';
import 'package:formfrontend/theme/app_colors.dart';

class AppShadows {
  AppShadows._();

  static const List<BoxShadow> cardElevated = [
    BoxShadow(
      color: AppColors.borderLight,
      offset: Offset(0, 4),
      blurRadius: 8,
      spreadRadius: -4,
    ),
  ];

  static const List<BoxShadow> cardFlat = [
    BoxShadow(
      color: AppColors.borderLight,
      offset: Offset(0, 4),
      blurRadius: 8,
      spreadRadius: -4,
    ),
  ];

  static const List<BoxShadow> buttonDarkHover = [
    BoxShadow(
      color: AppColors.greyMuted,
      offset: Offset(0, 4),
      blurRadius: 8,
      spreadRadius: -4,
    ),
  ];

  // Note: CSS inset shadow "inset 0px 2px 0px 0px rgb(68, 69, 76)" is represented
  // as an outer shadow with Offset(0, 2) since standard Flutter BoxShadow does not support inset.
  static const List<BoxShadow> buttonDark = [
    BoxShadow(
      color: AppColors.slateMid,
      offset: Offset(0, 2),
      blurRadius: 0,
      spreadRadius: 0,
    ),
  ];
}
