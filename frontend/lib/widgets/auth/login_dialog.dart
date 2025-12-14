import 'dart:io';

import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../models/user_profile.dart';
import '../../services/api/auth_service.dart';
import '../../services/storage/profile_storage.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';
import '../../utils/constants.dart';

Future<UserProfile?> showLoginDialog(
  BuildContext context, {
  String? initialEmail,
}) async {
  final TextEditingController emailController =
      TextEditingController(text: initialEmail ?? '');
  final TextEditingController passwordController = TextEditingController();
  bool submitting = false;
  String? errorMessage;

  final AppLocalizations l10n = AppLocalizations.of(context);

  final UserProfile? result = await showDialog<UserProfile?>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      return StatefulBuilder(
        builder: (BuildContext _, StateSetter setState) {
          Future<void> submit() async {
            final String email = emailController.text.trim();
            final String password = passwordController.text;
            if (email.isEmpty) {
              setState(() => errorMessage = l10n.emailRequired);
              return;
            }
            if (password.isEmpty) {
              setState(() => errorMessage = l10n.passwordRequired);
              return;
            }

            setState(() {
              submitting = true;
              errorMessage = null;
            });

            try {
              final UserProfile profile = await AuthService.login(
                email: email,
                password: password,
              );
              await ProfileStorage.save(profile);
              Navigator.of(dialogContext).pop(profile);
            } on HttpException catch (error) {
              final String message = error.message.contains('Invalid credentials')
                  ? l10n.loginInvalid
                  : l10n.loginFailed;
              setState(() {
                submitting = false;
                errorMessage = message;
              });
            } catch (_) {
              setState(() {
                submitting = false;
                errorMessage = l10n.loginFailed;
              });
            }
          }

          return AlertDialog(
            backgroundColor: AppColors.background,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            title: Text(
              l10n.loginTitle,
              style: AppTextStyles.heading2.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  l10n.loginSubtitle,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                _LoginTextField(
                  controller: emailController,
                  label: l10n.profileEmail,
                  icon: Icons.mail_outline_rounded,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: AppSpacing.sm),
                _LoginTextField(
                  controller: passwordController,
                  label: l10n.profilePassword,
                  icon: Icons.lock_outline,
                  obscureText: true,
                ),
                if (errorMessage != null) ...<Widget>[
                  const SizedBox(height: AppSpacing.sm),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      errorMessage!,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed:
                    submitting ? null : () => Navigator.of(dialogContext).pop(),
                child: Text(
                  l10n.loginCancel,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.mutedText,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: submitting ? null : submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.goldAccent,
                  foregroundColor: AppColors.background,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                ),
                child: submitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.background,
                          ),
                        ),
                      )
                    : Text(
                        l10n.loginButton,
                        style: AppTextStyles.buttonLabel.copyWith(
                          color: AppColors.background,
                        ),
                      ),
              ),
            ],
          );
        },
      );
    },
  );

  emailController.dispose();
  passwordController.dispose();
  return result;
}

class _LoginTextField extends StatelessWidget {
  const _LoginTextField({
    required this.controller,
    required this.label,
    required this.icon,
    this.obscureText = false,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool obscureText;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.keypadTile,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.panelBorder),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: <Widget>[
          Icon(icon, color: AppColors.goldAccent),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              obscureText: obscureText,
              style: AppTextStyles.heading3.copyWith(
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                labelText: label,
                labelStyle: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
