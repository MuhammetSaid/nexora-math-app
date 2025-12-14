import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';
import '../../utils/constants.dart';
import '../settings/settings_screen.dart';
import '../../widgets/game/nexora_background.dart';

class ProfileSettingsScreen extends StatelessWidget {
  const ProfileSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Scaffold(
      body: NexoraBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      color: AppColors.goldAccent,
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      l10n.profileSettings.toUpperCase(),
                      style: AppTextStyles.heading2.copyWith(
                        color: AppColors.textPrimary,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                Center(
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: 170,
                        height: 170,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.goldAccent,
                            width: 2,
                          ),
                          boxShadow: const <BoxShadow>[
                            BoxShadow(
                              color: Color(0x332C2410),
                              blurRadius: 18,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.camera_alt_outlined,
                          size: 72,
                          color: AppColors.goldAccent,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        l10n.changeAvatar,
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                _ProfileButton(
                  icon: Icons.switch_account_outlined,
                  label: l10n.loginAnotherAccount,
                  onTap: () => _showPlaceholder(context),
                ),
                const SizedBox(height: AppSpacing.md),
                _ProfileButton(
                  icon: Icons.person_outline,
                  label: l10n.name,
                  onTap: () => _showPlaceholder(context),
                ),
                const SizedBox(height: AppSpacing.md),
                _ProfileButton(
                  icon: Icons.mail_outline,
                  label: l10n.email,
                  onTap: () => _showPlaceholder(context),
                ),
                const SizedBox(height: AppSpacing.md),
                _ProfileButton(
                  icon: Icons.lock_outline,
                  label: l10n.password,
                  onTap: () => _showPlaceholder(context),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    TextButton(
                      onPressed: () => _showPlaceholder(context),
                      child: Text(
                        l10n.privacyPolicy,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.mutedText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => _showPlaceholder(context),
                      child: Text(
                        l10n.termsOfService,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.mutedText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showPlaceholder(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.panel,
        title: const Text(
          'Soon',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: const Text(
          'This action will be available soon.',
          style: TextStyle(color: AppColors.mutedText),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class _ProfileButton extends StatelessWidget {
  const _ProfileButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.md,
          horizontal: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: AppColors.keypadTile,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.goldAccent, width: 1.2),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color(0x332C2410),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            Icon(icon, color: AppColors.goldAccent, size: 24),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.heading3.copyWith(
                  color: AppColors.textPrimary,
                  letterSpacing: 0.4,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.mutedText, size: 22),
          ],
        ),
      ),
    );
  }
}
