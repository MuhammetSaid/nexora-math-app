import 'package:flutter/material.dart';

import '../utils/constants.dart';
import 'colors.dart';
import 'text_styles.dart';

/// Uygulama Tema Yapılandırması (Light + Modern Dark)
class AppTheme {
  const AppTheme._();

  /// 🔆 Light Theme (Landing Design)
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

  /// 🌙 Modern Dark Theme
  static ThemeData get dark {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.primaryButton,
      scaffoldBackgroundColor: AppColors.background,

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.cardBackground,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.primaryText),
        titleTextStyle: TextStyle(
          color: AppColors.primaryText,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),

      cardTheme: CardThemeData(
        color: AppColors.cardBackground,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryButton,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryButton,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cardBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.primaryButton,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),

      iconTheme: const IconThemeData(color: AppColors.primaryText, size: 24),

      textTheme: const TextTheme(
        displayLarge: TextStyle(color: AppColors.primaryText),
        displayMedium: TextStyle(color: AppColors.primaryText),
        displaySmall: TextStyle(color: AppColors.primaryText),
        headlineLarge: TextStyle(color: AppColors.primaryText),
        headlineMedium: TextStyle(color: AppColors.primaryText),
        headlineSmall: TextStyle(color: AppColors.primaryText),
        titleLarge: TextStyle(color: AppColors.primaryText),
        titleMedium: TextStyle(color: AppColors.primaryText),
        titleSmall: TextStyle(color: AppColors.primaryText),
        bodyLarge: TextStyle(color: AppColors.primaryText),
        bodyMedium: TextStyle(color: AppColors.primaryText),
        bodySmall: TextStyle(color: AppColors.secondaryText),
        labelLarge: TextStyle(color: AppColors.primaryText),
        labelMedium: TextStyle(color: AppColors.primaryText),
        labelSmall: TextStyle(color: AppColors.secondaryText),
      ),

      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryButton,
        secondary: AppColors.secondaryButton,
        surface: AppColors.cardBackground,
        error: AppColors.error,
      ),
    );
  }
}
