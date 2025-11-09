import 'package:flutter/material.dart';

class AppColors {
  static const primaryColor = Color(0xFF4F46E5); // Indigo-600
  static const secondaryColor = Color(0xFF9333EA); // Purple-600
  static const accentColor = Color(0xFFFBBF24); // Yellow-400
  static const backgroundColor = Color(0xFFF9FAFB); // Gray-50
  static const surfaceColor = Colors.white;
  static const textPrimary = Color(0xFF111827); // Gray-900
  static const textSecondary = Color(0xFF6B7280); // Gray-500
  static const errorColor = Color(0xFFEF4444); // Red-500
  static const successColor = Color(0xFF10B981); // Green-500
}

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: AppColors.backgroundColor,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryColor,
      secondary: AppColors.secondaryColor,
      error: AppColors.errorColor,
      surface: AppColors.surfaceColor,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
      displayMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
      bodyLarge: TextStyle(fontSize: 16, color: AppColors.textPrimary),
      bodyMedium: TextStyle(fontSize: 14, color: AppColors.textSecondary),
      labelSmall: TextStyle(fontSize: 12, color: AppColors.textSecondary),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 1,
      iconTheme: IconThemeData(color: AppColors.textPrimary),
      titleTextStyle: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
  );
}
