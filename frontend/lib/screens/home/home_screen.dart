import 'package:flutter/material.dart';
import 'package:frontend/l10n/app_localizations.dart';

import '../../models/user/auth_session.dart';
import '../../services/auth/auth_controller.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';
import '../../utils/constants.dart';
import '../../widgets/common/glow_button.dart';
import '../settings/settings_screen.dart';
import '../game/game_mode_screen.dart';
import '../profile/profile_settings_screen.dart';

/// Single home screen matching the provided dark gold reference.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.authController});

  final AuthController authController;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _authPromptScheduled = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_authPromptScheduled) return;
    _authPromptScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeShowAuthModal());
  }

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
                                  label: 'Profile',
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const ProfileSettingsScreen(),
                                      ),
                                    );
                                  },
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

  Future<void> _maybeShowAuthModal() async {
    if (!mounted) return;
    if (widget.authController.isAuthenticated) return;
    await _showAuthModal(widget.authController);
  }

  Future<void> _showAuthModal(AuthController auth) async {
    final AppLocalizations l10n = AppLocalizations.of(context);
    bool isProcessing = false;
    String? activeKey;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.75),
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            Future<void> handleAction(
              String key,
              Future<AuthSession?> Function() action,
            ) async {
              setState(() {
                isProcessing = true;
                activeKey = key;
              });
              final AuthSession? session = await action();
              if (!mounted) return;
              if (session != null) {
                Navigator.of(dialogContext).pop();
                _showSignedInSnack(session.user.username);
              } else {
                setState(() {
                  isProcessing = false;
                  activeKey = null;
                });
                _showAuthError(l10n.authFailed);
              }
            }

            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.xl,
              ),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.xl),
                decoration: BoxDecoration(
                  gradient: AppColors.panelGradient,
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                  border: Border.all(color: AppColors.panelBorder),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(
                      color: Color(0x55121212),
                      blurRadius: 28,
                      offset: Offset(0, 14),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      l10n.authChoiceTitle,
                      style: AppTextStyles.title.copyWith(
                        color: AppColors.textPrimary,
                        letterSpacing: 0.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      l10n.authChoiceSubtitle,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.mutedText,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    _AuthOptionButton(
                      icon: Icons.bolt_rounded,
                      label: l10n.continueAsGuest,
                      description: l10n.continueAsGuestCaption,
                      isLoading: isProcessing && activeKey == 'guest',
                      onTap: () => handleAction('guest', auth.signInAsGuest),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _AuthOptionButton(
                      icon: Icons.g_mobiledata,
                      label: l10n.signInWithGoogle,
                      description: l10n.signInWithGoogleCaption,
                      highlight: true,
                      isLoading: isProcessing && activeKey == 'google',
                      onTap: () => handleAction(
                        'google',
                        () => auth.signInWithGoogle(
                          idToken: 'mock-google-id-token', // TODO: replace with Google ID token when wired.
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    TextButton(
                      onPressed: isProcessing ? null : () => Navigator.of(dialogContext).pop(),
                      child: Text(
                        l10n.authMaybeLater,
                        style: AppTextStyles.body.copyWith(color: AppColors.mutedText),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showSignedInSnack(String name) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ScaffoldMessengerState? messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(l10n.authSignedInAs(name.isEmpty ? l10n.continueAsGuest : name)),
        duration: AppDurations.medium,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showAuthError(String message) {
    final ScaffoldMessengerState? messenger = ScaffoldMessenger.maybeOf(context);
    messenger?.hideCurrentSnackBar();
    messenger?.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: AppDurations.medium,
        backgroundColor: AppColors.panel,
        behavior: SnackBarBehavior.floating,
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

class _AuthOptionButton extends StatelessWidget {
  const _AuthOptionButton({
    required this.label,
    required this.description,
    required this.icon,
    required this.onTap,
    this.isLoading = false,
    this.highlight = false,
  });

  final String label;
  final String description;
  final IconData icon;
  final VoidCallback onTap;
  final bool isLoading;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final Color borderColor =
        highlight ? AppColors.goldAccent : AppColors.panelBorder;
    final Color background =
        highlight ? AppColors.keypadTileHighlight : AppColors.keypadTile;

    return Opacity(
      opacity: isLoading ? 0.85 : 1,
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: borderColor, width: 1.2),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: AppColors.shadow.withOpacity(0.5),
                blurRadius: 12,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(AppSpacing.xs),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: highlight
                      ? AppColors.gold.withOpacity(0.18)
                      : AppColors.panel,
                  border: Border.all(color: borderColor),
                ),
                child: Icon(
                  icon,
                  color: highlight ? AppColors.gold : AppColors.mutedText,
                  size: 22,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      label,
                      style: AppTextStyles.button.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      description,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.mutedText,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              if (isLoading)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.3,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.goldAccent),
                  ),
                )
              else
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: highlight ? AppColors.goldAccent : AppColors.mutedText,
                ),
            ],
          ),
        ),
      ),
    );
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
