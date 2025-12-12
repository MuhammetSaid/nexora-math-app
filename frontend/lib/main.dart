import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/game/game_mode_screen.dart';

void main() {
  runApp(const NexoraMathApp());
}

class NexoraMathApp extends StatelessWidget {
  const NexoraMathApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nexora Math',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      // Şimdilik test için game mode screen'i gösteriyoruz
      // Ana sayfa hazır olunca home: MainScreen() olarak değiştirilecek
      home: const GameModeScreen(),
    );
  }
}
