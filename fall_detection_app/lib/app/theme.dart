import 'package:flutter/material.dart';
import 'package:fall_detection_app/core/constants/colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.primaryBlue,
      scaffoldBackgroundColor: AppColors.background,
      cardColor: AppColors.cardBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: AppColors.white,
        centerTitle: true,
      ),
    );
  }
}
