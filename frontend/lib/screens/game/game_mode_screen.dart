import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../l10n/app_localizations.dart';
import '../../models/user_profile.dart';
import '../../theme/colors.dart';
import '../levels/levels_screen.dart';
import '../profile/profile_settings_screen.dart';
import '../settings/settings_screen.dart';
import 'bot_level_selection_sheet.dart';
import 'daily_puzzle_screen.dart';
import 'question_screen.dart';

class GameModeScreen extends StatefulWidget {
  const GameModeScreen({super.key, this.profile, this.onProfileUpdated});

  final UserProfile? profile;
  final ValueChanged<UserProfile>? onProfileUpdated;

  @override
  State<GameModeScreen> createState() => _GameModeScreenState();
}

class _GameModeScreenState extends State<GameModeScreen> {
  UserProfile? _profile;

  @override
  void initState() {
    super.initState();
    _profile = widget.profile;
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final int currentLevel = _profile?.level ?? 1;

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(_profile);
        return false;
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(color: Color(0xFF1e1e1e)),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  _buildProfileCard(context, _profile),
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
                          title: l10n.levelMode,
                          subtitle: l10n.play,
                          showProgress: true,
                          progressValue: 0.6,
                          gradientColors: const [
                            Color(0x4D6B4CE6),
                            Color(0x339B6CE6),
                          ],
                          onTap: (context) async {
                            final UserProfile? updated =
                                await Navigator.of(context).push<UserProfile?>(
                                  MaterialPageRoute(
                                    builder: (context) => LevelsScreen(
                                      profile: _profile,
                                      onProfileUpdated: _handleProfileUpdated,
                                    ),
                                  ),
                                );
                            if (!mounted) return;
                            if (updated != null) {
                              _handleProfileUpdated(updated);
                            }
                          },
                        ),
                        _buildGameModeCard(
                          icon: Icons.calendar_month_rounded,
                          title: l10n.dailyPuzzle,
                          subtitle: l10n.quiz,
                          gradientColors: const [
                            Color(0x4D6B4CE6),
                            Color(0x339B6CE6),
                          ],

                          onTap: (context) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const DailyPuzzleScreen(),
                              ),
                            );
                          },
                        ),
                        _buildGameModeCard(
                          icon: Icons.smart_toy_rounded,
                          title: l10n.botPlay,
                          subtitle: l10n.play,
                          gradientColors: const [
                            Color(0x4D6B4CE6),
                            Color(0x339B6CE6),
                          ],
                          onTap: (context) => _showBotLevelSelection(context),
                        ),
                        _buildGameModeCard(
                          icon: Icons.emoji_events_rounded,
                          title: l10n.tournament,
                          subtitle: l10n.play,
                          gradientColors: const [
                            Color(0x4D6B4CE6),
                            Color(0x339B6CE6),
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
            left: BorderSide(
              color: AppColors.gold.withOpacity(0.15),
              width: 1.5,
            ),
            right: BorderSide(
              color: AppColors.gold.withOpacity(0.15),
              width: 1.5,
            ),
            bottom: BorderSide(
              color: AppColors.gold.withOpacity(0.15),
              width: 1.5,
            ),
          ),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.gold.withOpacity(0.08), const Color(0x08FFFFFF)],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, UserProfile? user) {
    final String displayName = (user?.name.isNotEmpty ?? false)
        ? user!.name
        : 'Guest';
    final String diamondText = NumberFormat.decimalPattern().format(
      user?.diamond ?? 0,
    );

    return RepaintBoundary(
      child: GestureDetector(
        onTap: () => _openProfile(context),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColors.gold.withOpacity(0.3),
              width: 2,
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.gold.withOpacity(0.15),
                const Color(0x66000000),
              ],
            ),
          ),
          child: Row(
            children: [
              // Profil Resmi
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.goldAccent, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.goldAccent.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const ClipOval(
                  child: Icon(Icons.person, color: Colors.white, size: 38),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  displayName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
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
                      cacheWidth: 54,
                      cacheHeight: 54,
                    ),
                    const SizedBox(width: 7),
                    Text(
                      diamondText,
                      style: const TextStyle(
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
    final String subtitleText = subtitle == null ? title : '$title $subtitle';

    return GestureDetector(
      onTap: onTap != null ? () => onTap(context) : null,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.gold.withOpacity(0.4), width: 1),
          color: Color(0x1EFFFFFF),
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
                    subtitleText,
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
    );
  }

  Widget _buildLevelProgressCard(BuildContext context, int currentLevel) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: AppColors.gold.withOpacity(0.2), width: 1.5),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.gold.withOpacity(0.08), const Color(0x08FFFFFF)],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLevelIndicator(
                    'Level $currentLevel',
                    true,
                    subtitle: 'Resume Level $currentLevel',
                  ),
                  _buildProgressLine(),
                  _buildLevelIndicator(
                    'Level ${currentLevel + 1}',
                    false,
                    subtitle: 'Chapter: Calculus Basics',
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(flex: 2, child: _buildPlayOrb(context, currentLevel)),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelIndicator(String level, bool isActive, {String? subtitle}) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? AppColors.goldAccent : const Color(0xFF616161),
            border: Border.all(
              color: isActive ? AppColors.gold : const Color(0xFF757575),
              width: 1.5,
            ),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppColors.goldAccent.withOpacity(0.6),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                    BoxShadow(
                      color: AppColors.gold.withOpacity(0.3),
                      blurRadius: 18,
                      spreadRadius: 4,
                    ),
                  ]
                : const [],
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
                  color: isActive ? Colors.white : const Color(0xFF9E9E9E),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              if (subtitle != null)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    subtitle,
                    style: TextStyle(
                      color: isActive
                          ? const Color(0xFFBDBDBD)
                          : const Color(0xFF9E9E9E),
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
            AppColors.goldAccent.withOpacity(0.8),
            const Color(0x99616161),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.goldAccent.withOpacity(0.3),
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
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => LevelPuzzleScreen(
                level: currentLevel,
                profile: _profile,
                onProfileUpdated: _handleProfileUpdated,
              ),
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
                AppColors.goldSoft.withOpacity(0.4),
                AppColors.gold.withOpacity(0.2),
                AppColors.goldAccent.withOpacity(0.1),
                Colors.transparent,
              ],
              stops: const [0.0, 0.3, 0.6, 1.0],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.goldAccent.withOpacity(0.3),
                blurRadius: 30,
                spreadRadius: 6,
              ),
              BoxShadow(
                color: AppColors.gold.withOpacity(0.2),
                blurRadius: 45,
                spreadRadius: 10,
              ),
            ],
          ),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.gold.withOpacity(0.4),
                width: 2,
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.goldSoft, AppColors.gold],
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.play_arrow_rounded,
                color: Color(0xFF1E1E1E),
                size: 63,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _openProfile(BuildContext context) {
    Navigator.of(context)
        .push<UserProfile?>(
          MaterialPageRoute<UserProfile?>(
            builder: (context) =>
                ProfileSettingsScreen(onProfileChanged: _handleProfileUpdated),
          ),
        )
        .then((UserProfile? value) {
          if (value != null) {
            _handleProfileUpdated(value);
          }
        });
  }

  Widget _buildBottomNavigation(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.gold.withOpacity(0.2), width: 1),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.gold.withOpacity(0.08), const Color(0x0DFFFFFF)],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(Icons.emoji_events, 'Trophy'),
          _buildNavItem(
            Icons.person_outline,
            'Profile',
            onTap: () => _openProfile(context),
          ),
          _buildNavItem(
            Icons.settings_outlined,
            'Settings',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.goldSoft, size: 28),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: AppColors.goldSoft.withOpacity(0.8),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  void _handleProfileUpdated(UserProfile profile) {
    setState(() {
      _profile = profile;
    });
    widget.onProfileUpdated?.call(profile);
  }

  void _showBotLevelSelection(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const BotLevelSelectionSheet(),
    );
  }
}
