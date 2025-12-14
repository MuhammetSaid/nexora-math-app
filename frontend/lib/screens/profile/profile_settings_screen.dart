import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';
import '../../utils/constants.dart';
import '../../widgets/game/nexora_background.dart';

class ProfileSettingsScreen extends StatelessWidget {
  const ProfileSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Scaffold(
      body: NexoraBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      color: AppColors.goldAccent,
                      onPressed: () => Navigator.maybePop(context),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      l10n.profileSettings.toUpperCase(),
                      style: AppTextStyles.heading2.copyWith(
                        color: AppColors.textPrimary,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Center(
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: 148,
                        height: 148,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.keypadSurface,
                          border: Border.all(
                            color: AppColors.goldAccent,
                            width: 1.6,
                          ),
                          boxShadow: const <BoxShadow>[
                            BoxShadow(
                              color: Color(0x1AC9A24D),
                              blurRadius: 18,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Container(
                              width: 112,
                              height: 112,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.panelBorder,
                                  width: 1.2,
                                ),
                                gradient: AppColors.panelGradient,
                              ),
                            ),
                            Icon(
                              Icons.camera_alt_outlined,
                              color: AppColors.goldAccent,
                              size: 46,
                            ),
                            Positioned(
                              bottom: 18,
                              right: 40,
                              child: Container(
                                width: 18,
                                height: 18,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.goldAccent,
                                  border: Border.all(
                                    color: AppColors.keypadSurface,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        l10n.changeAvatar,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.mutedText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                _ProfileActionButton(
                  icon: Icons.switch_account_outlined,
                  label: l10n.loginAnotherAccount,
                  onTap: () => _showPlaceholder(context, l10n),
                ),
                const SizedBox(height: AppSpacing.md),
                _ProfileActionButton(
                  icon: Icons.person_outline,
                  label: l10n.profileName,
                  onTap: () => _showPlaceholder(context, l10n),
                ),
                const SizedBox(height: AppSpacing.md),
                _ProfileActionButton(
                  icon: Icons.mail_outline_rounded,
                  label: l10n.profileEmail,
                  onTap: () => _showPlaceholder(context, l10n),
                ),
                const SizedBox(height: AppSpacing.md),
                _ProfileActionButton(
                  icon: Icons.lock_outline,
                  label: l10n.profilePassword,
                  onTap: () => _showPlaceholder(context, l10n),
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextButton(
                      onPressed: () => _showPlaceholder(context, l10n),
                      child: Text(
                        l10n.privacyPolicy,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.mutedText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    TextButton(
                      onPressed: () => _showPlaceholder(context, l10n),
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

  void _showPlaceholder(BuildContext context, AppLocalizations l10n) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.panel,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
            side: const BorderSide(color: AppColors.goldAccent, width: 1.1),
          ),
          title: Text(
            l10n.profileSettings,
            style: AppTextStyles.heading3.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          content: Text(
            l10n.dialogPlaceholder,
            style: AppTextStyles.body.copyWith(
              color: AppColors.mutedText,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class _ProfileActionButton extends StatelessWidget {
  const _ProfileActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Ink(
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
