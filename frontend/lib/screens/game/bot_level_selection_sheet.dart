import 'package:flutter/material.dart';
import 'bot_game_screen.dart';

class BotLevelSelectionSheet extends StatelessWidget {
  const BotLevelSelectionSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final levels = [
      {
        'name': 'Başlangıç',
        'icon': Icons.play_circle_outline,
        'color': const Color(0xFF4CAF50),
        'difficulty': 1,
      },
      {
        'name': 'Amatör',
        'icon': Icons.sports_esports,
        'color': const Color(0xFF2196F3),
        'difficulty': 2,
      },
      {
        'name': 'Orta Seviye',
        'icon': Icons.emoji_events,
        'color': const Color(0xFFFF9800),
        'difficulty': 3,
      },
      {
        'name': 'Profesyonel',
        'icon': Icons.military_tech,
        'color': const Color(0xFFE91E63),
        'difficulty': 4,
      },
      {
        'name': 'Efsane',
        'icon': Icons.diamond,
        'color': const Color(0xFF9C27B0),
        'difficulty': 5,
      },
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1e1e1e),
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Üst Çubuk
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0x33FFFFFF),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 24),

              // Başlık
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: const LinearGradient(
                        colors: [Color(0x4D6B4CE6), Color(0x339B6CE6)],
                      ),
                    ),
                    child: const Icon(
                      Icons.smart_toy_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Seviye Seçin',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          'Bot zorluk seviyesini belirleyin',
                          style: TextStyle(
                            color: Color(0xFFBDBDBD),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Seviye Kartları
              ...levels.map(
                (level) => _buildLevelCard(
                  context: context,
                  name: level['name'] as String,
                  icon: level['icon'] as IconData,
                  color: level['color'] as Color,
                  difficulty: level['difficulty'] as int,
                ),
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLevelCard({
    required BuildContext context,
    required String name,
    required IconData icon,
    required Color color,
    required int difficulty,
  }) {
    // Efsane modu için özel ödül
    final isLegendary = difficulty == 5;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
            // Bot oyununu başlat
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BotGameScreen(
                  difficulty: difficulty,
                  difficultyName: name,
                  difficultyColor: color,
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.withOpacity(0.3), width: 1.5),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [color.withOpacity(0.15), color.withOpacity(0.05)],
              ),
            ),
            child: Row(
              children: [
                // İkon Container
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.withOpacity(0.2),
                    border: Border.all(color: color.withOpacity(0.5), width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(width: 16),

                // Seviye Bilgisi
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          // Yıldızlar (Sol taraf)
                          ...List.generate(
                            5,
                            (index) => Padding(
                              padding: const EdgeInsets.only(right: 4),
                              child: Icon(
                                index < difficulty
                                    ? Icons.star
                                    : Icons.star_border,
                                color: index < difficulty
                                    ? const Color(0xFFFFD700)
                                    : const Color(0xFF757575),
                                size: 16,
                              ),
                            ),
                          ),

                          // Efsane için elmas ödülü (Sağ taraf)
                          if (isLegendary) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF9C27B0).withOpacity(0.3),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: const Color(
                                    0xFF9C27B0,
                                  ).withOpacity(0.5),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    '+5',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Image.asset(
                                    'assets/elmas.png',
                                    width: 16,
                                    height: 16,
                                    fit: BoxFit.contain,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),

                // Ok İkonu
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: color.withOpacity(0.7),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
