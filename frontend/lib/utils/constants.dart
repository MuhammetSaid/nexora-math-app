import 'package:flutter/widgets.dart';

/// Shared layout constants and simple safe helpers to keep spacing consistent.
class AppSpacing {
  const AppSpacing._();

  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 32;

  /// Default page padding used across screens with a defensive fallback.
  static EdgeInsets page() {
    try {
      return const EdgeInsets.symmetric(horizontal: lg, vertical: md);
    } catch (error) {
      debugPrint('Padding fallback used: $error');
      return EdgeInsets.zero;
    }
  }

  /// Safe horizontal padding builder to avoid negative values.
  static EdgeInsets horizontal(double value) {
    final double sanitized = _sanitize(value);
    return EdgeInsets.symmetric(horizontal: sanitized);
  }

  static double _sanitize(double value) {
    if (value.isNaN || value.isNegative) {
      debugPrint('Spacing value sanitized: $value');
      return 0;
    }
    return value;
  }
}

/// Corner radius tokens for a coherent rounded style.
class AppRadius {
  const AppRadius._();

  static const double sm = 10;
  static const double md = 14;
  static const double lg = 18;
  static const double xl = 24;
}

/// Animation and interaction durations kept in one place.
class AppDurations {
  const AppDurations._();

  static const Duration short = Duration(milliseconds: 150);
  static const Duration medium = Duration(milliseconds: 250);
  static const Duration long = Duration(milliseconds: 400);
}
