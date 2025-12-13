import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../main.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';
import '../../utils/constants.dart';
import '../../widgets/game/nexora_background.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _soundOn = true;

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
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      l10n.settings.toUpperCase(),
                      style: AppTextStyles.heading2.copyWith(
                        color: AppColors.textPrimary,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Center(
                  child: SizedBox(
                    width: 180,
                    height: 180,
                    child: Image.asset(
                      'assets/images/orbital.png',
                      fit: BoxFit.contain,
                      errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                        return Icon(
                          Icons.language_outlined,
                          color: AppColors.goldAccent,
                          size: 72,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                _SettingsButton(
                  icon: Icons.person_outline,
                  label: l10n.profileSettings,
                  onTap: () => _showPlaceholder(context, l10n),
                ),
                const SizedBox(height: AppSpacing.md),
                _SettingsButton(
                  icon: Icons.emoji_events_outlined,
                  label: l10n.achievements,
                  onTap: () => _showPlaceholder(context, l10n),
                ),
                const SizedBox(height: AppSpacing.md),
                _SettingsButton(
                  icon: Icons.language,
                  label: l10n.language,
                  onTap: () => _showLanguageSheet(context),
                ),
                const SizedBox(height: AppSpacing.md),
                _SettingsButton(
                  icon: _soundOn ? Icons.volume_up : Icons.volume_off,
                  label: _soundOn ? l10n.soundsOn : l10n.soundsOff,
                  onTap: () => setState(() => _soundOn = !_soundOn),
                ),
                const SizedBox(height: AppSpacing.md),
                _SettingsButton(
                  icon: Icons.delete_outline,
                  label: l10n.deleteData,
                  onTap: () => _showPlaceholder(context, l10n),
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
          title: Text(l10n.settings),
          content: Text(l10n.dialogPlaceholder),
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

  void _showLanguageSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.panel,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                AppLocalizations.of(context).language,
                style: AppTextStyles.heading3.copyWith(color: AppColors.textPrimary),
              ),
              const SizedBox(height: AppSpacing.md),
              _LanguageTile(
                label: 'English',
                code: 'en',
                onTap: () => _setLocale(const Locale('en')),
              ),
              _LanguageTile(
                label: 'Türkçe',
                code: 'tr',
                onTap: () => _setLocale(const Locale('tr')),
              ),
            ],
          ),
        );
      },
    );
  }

  void _setLocale(Locale locale) {
    NexoraApp.of(context)?.setLocale(locale);
    Navigator.pop(context);
  }
}

class _SettingsButton extends StatelessWidget {
  const _SettingsButton({
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

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({
    required this.label,
    required this.code,
    required this.onTap,
  });

  final String label;
  final String code;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: const Icon(Icons.language, color: AppColors.goldAccent),
      title: Text(
        label,
        style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textPrimary),
      ),
      trailing: Text(
        code.toUpperCase(),
        style: AppTextStyles.label.copyWith(color: AppColors.mutedText),
      ),
    );
  }
}
