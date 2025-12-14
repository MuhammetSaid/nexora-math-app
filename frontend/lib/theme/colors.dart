import 'package:flutter/material.dart';

/// Uygulama genel renk paleti (Landing + Game + UI)
class AppColors {
  const AppColors._();

  // ==== Arka Plan & Yuzey Renkleri ====
  static const Color background = Color(0xFF1E1E1E);
  static const Color backgroundTop = Color(0xFF0F0F11);
  static const Color backgroundBottom = Color(0xFF1C1C1F);
  static const Color surface = Color(0xFF242424);
  static const Color mutedSurface = Color(0xFF2C2C2C);
  static const Color cardBackground = Color(0xFF2D2D2D);
  static const Color border = Color(0xFF3A3A3A);
  static const Color divider = Color(0xFF404040);
  static const Color overlay = Color(0x11C9A24D);
  static const Color panel = Color(0xFF1B1B1F);
  static const Color panelBorder = Color(0xFF2A2A2D);
  static const Color keypadSurface = Color(0xFF121214);
  static const Color keypadTile = Color(0xFF1A1B1F);
  static const Color keypadTileHighlight = Color(0xFF222328);

  // ==== Metin Renkleri ====
  static const Color textPrimary = Color(0xFFEDE8D1);
  static const Color textSecondary = Color(0xFFB6B0A0);
  static const Color primaryText = Color(0xFFFFFFFF);
  static const Color secondaryText = Color(0xFFB0B0B0);
  static const Color mutedText = Color(0xFFBEBEBE);
  static const Color tertiaryText = Color(0xFF8C8C8C);

  // ==== Altin Tonlari (Landing Tasarimi) ====
  static const Color gold = Color(0xFFD6B15F);
  static const Color goldAccent = Color(0xFFC9A24D);
  static const Color goldSoft = Color(0xFFE9D9A2);

  static const LinearGradient goldGlow = LinearGradient(
    colors: <Color>[gold, Color(0xFFB18A3A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient backgroundGradient = LinearGradient(
    colors: <Color>[backgroundTop, backgroundBottom],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static const LinearGradient panelGradient = LinearGradient(
    colors: <Color>[Color(0xFF1F1F23), Color(0xFF18181B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ==== Buton Renkleri ====
  static const Color primaryButton = Color(0xFF4CAF50);
  static const Color secondaryButton = Color(0xFF2196F3);
  static const Color dangerButton = Color(0xFFF44336);

  // ==== Modlara Ozel Renkler ====
  static const Color levelModeColor = Color(0xFF9C27B0);
  static const Color tournamentModeColor = Color(0xFFFF9800);
  static const Color botModeColor = Color(0xFF00BCD4);

  // ==== Durum Renkleri ====
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);

  // ==== Diger ====
  static const Color mutedIcon = Color(0xFF8A8370);
  static const Color shadow = Color.fromRGBO(0, 0, 0, 0.55);
}
