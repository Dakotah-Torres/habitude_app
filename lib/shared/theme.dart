import 'package:flutter/material.dart';

class AppColors {
  static const juniper = Color(0xFF2F483D);
  static const sand = Color(0xFFF7CE82);
  static const mesaSky = Color(0xFF657CAB);
  static const saguaro = Color(0xFF687229);
  static const ember = Color(0xFFF7841E);
  static const pricklyPear = Color(0xFFC311A8);

  // Backgrounds derived from Sand
  static const backgroundLight = Color(0xFFFFF9F0); // Very light sand
  static const surfaceLight = Color(0xFFFFF4E1); // Slightly warmer sand
}

class AppTheme {
  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.juniper,
        primary: AppColors.juniper,
        secondary: AppColors.mesaSky,
        tertiary: AppColors.saguaro,
        surface: AppColors.backgroundLight,
        error: Colors.red[700],
      ),
      scaffoldBackgroundColor: AppColors.backgroundLight,
      cardTheme: const CardThemeData(
        color: AppColors.surfaceLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          side: BorderSide(color: Color(0x1A2F483D)), // 10% Juniper
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundLight,
        foregroundColor: AppColors.juniper,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.juniper,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.ember,
        foregroundColor: Colors.white,
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          selectedBackgroundColor: AppColors.juniper,
          selectedForegroundColor: Colors.white,
        ),
      ),
    );

    return base;
  }
}
