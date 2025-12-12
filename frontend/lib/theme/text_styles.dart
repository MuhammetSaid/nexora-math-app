import 'package:flutter/material.dart';

import 'colors.dart';

/// Typography tokens to keep text styling predictable across widgets.
class AppTextStyles {
  const AppTextStyles._();

  static const TextStyle headline = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: AppColors.textPrimary,
  );

  static const TextStyle title = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    height: 1.25,
    color: AppColors.textPrimary,
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.35,
    color: AppColors.textSecondary,
  );

  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: AppColors.textSecondary,
  );

  static const TextStyle label = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
    color: AppColors.textSecondary,
  );

  static const TextStyle navLabel = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.gold,
  );

  /// Defensive helper to merge styles without crashing on null inputs.
  static TextStyle safeMerge(TextStyle base, TextStyle? other) {
    try {
      return base.merge(other);
    } catch (_) {
      return base;
    }
  }
}
