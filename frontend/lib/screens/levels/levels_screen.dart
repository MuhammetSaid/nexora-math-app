import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../game/question_screen.dart';

class LevelsScreen extends StatelessWidget {
  const LevelsScreen({super.key});
  final int currentLevel = 12;
  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: Color(0xFF1e1e1e)),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(context, l10n),
              const SizedBox(height: 20),

              // Progress Info
              _buildProgressInfo(l10n),
              const SizedBox(height: 25),

              // Levels Grid
              Expanded(child: _buildLevelsGrid()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          // Geri Butonu
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0x26FFFFFF), width: 1.5),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0x14FFFFFF), Color(0x08FFFFFF)],
                ),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Color(0xE6FFFFFF),
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 15),

          // Başlık
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'SEVİYELİ OYNA',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  l10n.totalLevels,
                  style: const TextStyle(
                    color: Color(0xFFBDBDBD),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),

          // Info Butonu
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0x26FFFFFF), width: 1.5),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0x14FFFFFF), Color(0x08FFFFFF)],
              ),
            ),
            child: const Icon(
              Icons.info_outline_rounded,
              color: Color(0xE6FFFFFF),
              size: 22,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressInfo(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(17),
          border: Border.all(color: const Color(0x26FFFFFF), width: 1.5),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0x14FFFFFF), Color(0x08FFFFFF)],
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'İlerleme',
                      style: TextStyle(
                        color: Color(0xFFBDBDBD),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$currentLevel / 100',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: const Color(0x33FF9F43),
                    border: Border.all(
                      color: const Color(0x4DFF9F43),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    '%$currentLevel',
                    style: TextStyle(
                      color: Color(0xFFFF9F43),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: const LinearProgressIndicator(
                value: 0.15,
                backgroundColor: Color(0x1AFFFFFF),
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF9F43)),
                minHeight: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelsGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: GridView.builder(
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          mainAxisSpacing: 9,
          crossAxisSpacing: 9,
          childAspectRatio: 0.85,
        ),
        itemCount: 100,
        itemBuilder: (context, index) {
          int levelNumber = index + 1;
          bool isCompleted = levelNumber < currentLevel;
          bool isCurrent = levelNumber == currentLevel;
          bool isLocked = levelNumber > currentLevel;

          return _buildLevelCard(
            context: context,
            levelNumber: levelNumber,
            isCompleted: isCompleted,
            isCurrent: isCurrent,
            isLocked: isLocked,
          );
        },
      ),
    );
  }

  Widget _buildLevelCard({
    required BuildContext context,
    required int levelNumber,
    required bool isCompleted,
    required bool isCurrent,
    required bool isLocked,
  }) {
    final Color cardColor;
    final Color borderColor;
    final Color textColor;
    final IconData icon;
    final List<BoxShadow> shadows;

    if (isCompleted) {
      cardColor = const Color(0x334CAF50);
      borderColor = const Color(0x4D4CAF50);
      textColor = const Color(0xFF4CAF50);
      icon = Icons.check_circle_rounded;
      shadows = const [];
    } else if (isCurrent) {
      cardColor = const Color(0x40FF9F43);
      borderColor = const Color(0x4DFF9F43);
      textColor = const Color(0xFFFF9F43);
      icon = Icons.play_circle_filled_rounded;
      shadows = const [
        BoxShadow(color: Color(0x66FF9F43), blurRadius: 12, spreadRadius: 2),
      ];
    } else {
      cardColor = const Color(0x4D424242);
      borderColor = const Color(0x4D424242);
      textColor = const Color(0xFF757575);
      icon = Icons.lock_rounded;
      shadows = const [];
    }

    return GestureDetector(
      onTap: isLocked
          ? null
          : () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => LevelPuzzleScreen(level: levelNumber),
                ),
              );
            },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          border: Border.all(color: borderColor, width: 1.5),
          color: cardColor,
          boxShadow: shadows,
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: textColor, size: 28),
              const SizedBox(height: 6),
              Text(
                '$levelNumber',
                style: TextStyle(
                  color: isLocked ? const Color(0xFF757575) : Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              if (isCompleted)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: const Color(0x334CAF50),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star, color: Color(0xFFFFD700), size: 12),
                      SizedBox(width: 2),
                      Text(
                        '3',
                        style: TextStyle(
                          color: Color(0xFFFFD700),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
