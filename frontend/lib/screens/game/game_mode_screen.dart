import 'dart:ui';

import 'package:flutter/material.dart';

import '../levels/levels_screen.dart';
import 'question_screen.dart';
import 'daily_puzzle_screen.dart';
import '../settings/settings_screen.dart';
import '../../l10n/app_localizations.dart';

class GameModeScreen extends StatelessWidget {
  const GameModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    const int currentLevel = 15;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: Color(0xFF1e1e1e)),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // Kullanıcı Profil Kartı
                _buildProfileCard(),
                const SizedBox(height: 50),

                // Oyun Modları Grid (2x2)
                Expanded(
                  flex: 2,
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.4,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildGameModeCard(
                        icon: Icons.layers_rounded,
                        title: 'SEVİYELİ',
                        subtitle: 'OYNA',
                        showProgress: true,
                        progressValue: 0.6,
                        gradientColors: [
                          const Color(0xFF6B4CE6).withOpacity(0.3),
                          const Color(0xFF9B6CE6).withOpacity(0.2),
                        ],
                        onTap: (context) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LevelsScreen(),
                            ),
                          );
                        },
                      ),
                      _buildGameModeCard(
                        icon: Icons.calendar_month_rounded,
                        title: 'GÜNLÜK',
                        subtitle: 'QUIZ',
                        gradientColors: [
                          const Color(0xFF6B4CE6).withOpacity(0.3),
                          const Color(0xFF9B6CE6).withOpacity(0.2),
                        ],
                      ),
                      _buildGameModeCard(
                        icon: Icons.smart_toy_rounded,
                        title: 'ROBOTA KARŞI',
                        subtitle: 'OYNA',
                        gradientColors: [
                          const Color(0xFF6B4CE6).withOpacity(0.3),
                          const Color(0xFF9B6CE6).withOpacity(0.2),
                        ],
                      ),
                      _buildGameModeCard(
                        icon: Icons.emoji_events_rounded,
                        title: l10n.tournament,
                        subtitle: l10n.play,
                        gradientColors: [
                          const Color(0xFF6B4CE6).withOpacity(0.3),
                          const Color(0xFF9B6CE6).withOpacity(0.2),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Seviye Progress Kartı
                SizedBox(
                  height: 265,
                  child: _buildLevelProgressCard(context, currentLevel),
                ),
                _deneme(pad: 14),
                _deneme(pad: 22),

                const SizedBox(height: 15),

                // Alt Navigasyon
                _buildBottomNavigation(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _deneme({int pad = 12}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: pad.toDouble()),
      child: Container(
        width: double.infinity,
        height: 10,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          border: Border(
            left: BorderSide(color: Colors.white.withOpacity(0.15), width: 1.5),
            right: BorderSide(
              color: Colors.white.withOpacity(0.15),
              width: 1.5,
            ),
            bottom: BorderSide(
              color: Colors.white.withOpacity(0.15),
              width: 1.5,
            ),
          ),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.08),
              Colors.white.withOpacity(0.03),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white30, width: 2),
          // gradient: LinearGradient(
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          //   colors: [
          //     const Color(0xFF2A2A3E).withOpacity(0.6),
          //     const Color(0xFF1A1A2E).withOpacity(0.4),
          //   ],
          // ),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color.fromARGB(255, 198, 198, 198).withOpacity(0.6),
              const Color.fromARGB(255, 0, 0, 0).withOpacity(0.4),
            ],
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            decoration: BoxDecoration(),
            child: Row(
              children: [
                // Profil Resmi
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color.fromARGB(
                        255,
                        54,
                        63,
                        65,
                      ).withOpacity(0.9),
                      width: 3,
                    ),
                  ),
                  child: ClipOval(
                    child: Container(
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 38,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // İsim
                const Expanded(
                  child: Text(
                    'John Doe',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),

                // IQ Puanı
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/elmas.png',
                        width: 27,
                        height: 27,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 7),
                      const Text(
                        '3,450',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGameModeCard({
    required IconData icon,
    required String title,
    String? subtitle,
    bool showProgress = false,
    double progressValue = 0.0,
    required List<Color> gradientColors,
    Function(BuildContext)? onTap,
  }) {
    return Builder(
      builder: (context) => GestureDetector(
        onTap: onTap != null ? () => onTap(context) : null,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
            color: const Color.fromARGB(255, 229, 229, 229).withOpacity(0.2),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, color: Colors.white, size: 36),
                    const Spacer(),
                    Text(
                      title + ' ' + subtitle!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),

                    if (showProgress) ...[
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: progressValue,
                          backgroundColor: Colors.white.withOpacity(0.2),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFFFF9F43),
                          ),
                          minHeight: 6,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLevelProgressCard(BuildContext context, int currentLevel) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: Colors.white.withOpacity(0.15), width: 1.5),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.08),
            Colors.white.withOpacity(0.03),
          ],
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Row(
              children: [
                // Sol taraf - Progress Timeline
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLevelIndicator('Level 15', true, isResume: true),
                      _buildProgressLine(),
                      _buildLevelIndicator('Level 16', false),
                    ],
                  ),
                ),

                const SizedBox(width: 16),

                // Sağ taraf - Play Orb
                Expanded(flex: 2, child: _buildPlayOrb(context, currentLevel)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLevelIndicator(
    String level,
    bool isActive, {
    bool isResume = false,
  }) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? const Color(0xFFFF9F43) : Colors.grey.shade700,
            border: Border.all(
              color: isActive
                  ? const Color(0xFFFF9F43).withOpacity(0.5)
                  : Colors.grey.shade600,
              width: 1.5,
            ),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: const Color(0xFFFF9F43).withOpacity(0.6),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                    BoxShadow(
                      color: const Color(0xFFFF9F43).withOpacity(0.3),
                      blurRadius: 18,
                      spreadRadius: 4,
                    ),
                  ]
                : [],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                level,
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.grey.shade500,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              if (isResume)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    'Resume Level 42',
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              if (!isActive)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    'Chapter: Calculus Basics',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressLine() {
    return Container(
      margin: const EdgeInsets.only(left: 9, top: 8, bottom: 8),
      width: 2.5,
      height: 38,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFFFF9F43).withOpacity(0.8),
            Colors.grey.shade700.withOpacity(0.6),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF9F43).withOpacity(0.3),
            blurRadius: 6,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }

  Widget _buildPlayOrb(BuildContext context, int currentLevel) {
    return Center(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (_) => LevelPuzzleScreen(level: currentLevel),
            ),
          );
        },
        child: Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              center: Alignment.topLeft,
              radius: 1.2,
              colors: [
                Colors.white.withOpacity(0.4),
                Colors.white.withOpacity(0.2),
                Colors.white.withOpacity(0.1),
                Colors.transparent,
              ],
              stops: const [0.0, 0.3, 0.6, 1.0],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.3),
                blurRadius: 30,
                spreadRadius: 6,
              ),
              BoxShadow(
                color: Colors.white.withOpacity(0.2),
                blurRadius: 45,
                spreadRadius: 10,
              ),
            ],
          ),
          child: ClipOval(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.4),
                    width: 2,
                  ),
                  color: const Color(0xFFFFFFFF).withOpacity(0.70),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.play_arrow_rounded,
                      color: const Color(0xFF1E1E1E).withOpacity(0.75),
                      size: 63,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigation(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(Icons.emoji_events, 'Trophy'),
              _buildNavItem(Icons.person_outline, 'Profile'),
              _buildNavItem(
                Icons.settings_outlined,
                'Settings',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) => const SettingsScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, {VoidCallback? onTap}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Icon(icon, color: Colors.white.withOpacity(0.8), size: 28),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
        ),
      ],
    );
  }
}
