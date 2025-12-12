import 'package:flutter/material.dart';

/// Central color palette for the dark NumerA home screen.
class AppColors {
  const AppColors._();

  static const Color background = Color(0xFF1E1E1E);
  static const Color surface = Color(0xFF242424);
  static const Color mutedSurface = Color(0xFF2C2C2C);
  static const Color border = Color(0xFF3A3A3A);

  static const Color gold = Color(0xFFD6B15F);
  static const Color goldSoft = Color(0xFFE9D9A2);
  static const Color textPrimary = Color(0xFFEDE8D1);
  static const Color textSecondary = Color(0xFFB6B0A0);
  static const Color mutedIcon = Color(0xFF8A8370);
  static const Color shadow = Color.fromRGBO(0, 0, 0, 0.55);

  static const LinearGradient goldGlow = LinearGradient(
    colors: <Color>[gold, Color(0xFFB18A3A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
