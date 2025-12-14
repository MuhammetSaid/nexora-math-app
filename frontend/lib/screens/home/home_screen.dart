import 'package:flutter/material.dart';
import 'package:frontend/l10n/app_localizations.dart';

import '../../theme/colors.dart';
import '../../theme/text_styles.dart';
import '../../utils/constants.dart';
import '../../widgets/common/glow_button.dart';
import '../settings/settings_screen.dart';
import '../game/game_mode_screen.dart';

/// Single home screen matching the provided dark gold reference.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double minHeight =
                (constraints.maxHeight -
                        MediaQuery.of(context).padding.vertical)
                    .clamp(0, double.infinity);
            return Center(
              child: SingleChildScrollView(
                padding: AppSpacing.page(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 520,
                    minHeight: minHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const SizedBox(height: AppSpacing.xl),
                            Text(
                              l10n.homeTitle,
                              style: AppTextStyles.headline.copyWith(
                                color: AppColors.gold,
                                letterSpacing: 1.4,
                                shadows: const <Shadow>[
                                  Shadow(
                                    color: AppColors.shadow,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                  Shadow(
                                    color: AppColors.gold,
                                    blurRadius: 8,
                                    offset: Offset(0, 0),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xl),
                            _OrbitalBadge(),
                            const SizedBox(height: AppSpacing.xxl + 8),
                            GlowButton(
                              label: l10n.startGame,
                              height: 68,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const GameModeScreen(),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: AppSpacing.xxl + 8),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: GlowButton(
                                    height: 56,
                                    label: l10n.chapters,
                                    icon: Icons.menu_book_outlined,
                                    onTap: () => _showComingSoon(context),
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.md),
                                Expanded(
                                  child: MutedButton(
                                    label: l10n.endlessMode,
                                    icon: Icons.all_inclusive,
                                    onTap: () => _showComingSoon(context),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            _BottomMetaRow(
                              items: <_BottomMeta>[
                                _BottomMeta(
                                  icon: Icons.psychology_outlined,
                                  label: 'IQ',
                                ),
                                _BottomMeta(
                                  icon: Icons.emoji_events_outlined,
                                  label: 'Leaderboard',
                                ),
                                _BottomMeta(
                                  icon: Icons.settings_outlined,
                                  label: 'Settings',
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const SettingsScreen(),
                                      ),
                                    );
                                  },
                                ),
                                _BottomMeta(
                                  icon: Icons.account_circle_outlined,
                                  label: 'Session',
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              l10n.comingSoon,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    try {
      final ScaffoldMessengerState? messenger = ScaffoldMessenger.maybeOf(
        context,
      );
      messenger?.hideCurrentSnackBar();
      messenger?.showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).comingSoon),
          duration: AppDurations.medium,
        ),
      );
    } catch (error) {
      debugPrint('Unable to show Snackbar: $error');
    }
  }
}

/// Central icon badge to mimic the geometric graphic in the reference.
class _OrbitalBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      height: 220,
      decoration: const BoxDecoration(color: AppColors.background),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            'assets/images/orbital.png',
            width: 250,
            height: 250,
            fit: BoxFit.contain,
            errorBuilder:
                (BuildContext context, Object error, StackTrace? stackTrace) {
                  debugPrint('Orbital asset missing: $error');
                  return Icon(
                    Icons.language,
                    color: AppColors.goldSoft,
                    size: 88,
                  );
                },
          ),
        ),
      ),
    );
  }
}

/// Row of passive meta items at the bottom of the home screen.
class _BottomMetaRow extends StatelessWidget {
  const _BottomMetaRow({required this.items});

  final List<_BottomMeta> items;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: items
          .map(
            (_BottomMeta meta) => Expanded(
              child: GestureDetector(
                onTap: meta.onTap,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(meta.icon, color: AppColors.goldSoft, size: 28),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      meta.label,
                      style: AppTextStyles.navLabel,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

/// Immutable metadata container used to render footer items.
class _BottomMeta {
  const _BottomMeta({required this.icon, required this.label, this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
}
