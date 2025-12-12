import 'package:flutter/material.dart';

import '../utils/constants.dart';
import 'colors.dart';
import 'text_styles.dart';

/// Builds the application-wide ThemeData with Material 3 settings.
class AppTheme {
  const AppTheme._();

  /// Dark theme tailored to the NumerA landing design.
  static ThemeData light() {
    try {
      final ColorScheme base = const ColorScheme.dark();
      final ColorScheme colorScheme = base.copyWith(
        surface: AppColors.surface,
        primary: AppColors.gold,
        secondary: AppColors.goldSoft,
        onPrimary: AppColors.background,
        onSurface: AppColors.textPrimary,
      );

      return ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: AppColors.background,
          surfaceTintColor: Colors.transparent,
          foregroundColor: AppColors.textPrimary,
          titleTextStyle: AppTextStyles.title,
        ),
        textTheme: const TextTheme(
          headlineLarge: AppTextStyles.headline,
          headlineMedium: AppTextStyles.title,
          bodyLarge: AppTextStyles.body,
          bodyMedium: AppTextStyles.body,
          labelLarge: AppTextStyles.label,
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          color: AppColors.surface,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            side: const BorderSide(color: AppColors.border),
          ),
        ),
        snackBarTheme: const SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          shape: StadiumBorder(),
          backgroundColor: AppColors.surface,
          contentTextStyle: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: AppColors.gold,
          unselectedItemColor: AppColors.textSecondary,
          backgroundColor: AppColors.background,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
        ),
      );
    } catch (error, stackTrace) {
      debugPrint('Theme fallback due to error: $error\n$stackTrace');
      return ThemeData.light(useMaterial3: true);
    }
  }
}
