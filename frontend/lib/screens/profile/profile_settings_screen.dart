import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../models/user_profile.dart';
import '../../services/api/user_service.dart';
import '../../services/storage/profile_storage.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';
import '../../utils/constants.dart';
import '../../widgets/game/nexora_background.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _saving = false;
  UserProfile? _cachedProfile;

  @override
  void initState() {
    super.initState();
    _loadProfileFromCache();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadProfileFromCache() async {
    final UserProfile? cached = await ProfileStorage.load();
    if (!mounted) return;
    if (cached != null) {
      setState(() {
        _cachedProfile = cached;
        _nameController.text = cached.name;
        _emailController.text = cached.email;
      });
      await _refreshFromServer(cached.userId);
    }
  }

  Future<void> _refreshFromServer(String userId) async {
    try {
      final UserProfile? remote = await UserService.fetchProfile(userId);
      if (remote != null && mounted) {
        setState(() {
          _cachedProfile = remote;
          _nameController.text = remote.name;
          _emailController.text = remote.email;
        });
        await ProfileStorage.save(remote);
      }
    } catch (_) {
      // Sessizce yoksay - offline olabilir
    }
  }

  Future<void> _saveProfile(AppLocalizations l10n) async {
    final String name = _nameController.text.trim();
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    if (name.isEmpty) {
      _showSnack(l10n.nameRequired);
      return;
    }
    if (email.isEmpty) {
      _showSnack(l10n.emailRequired);
      return;
    }
    if (!_isValidEmail(email)) {
      _showSnack(l10n.invalidEmail);
      return;
    }
    if (_cachedProfile == null && password.isEmpty) {
      _showSnack(l10n.passwordRequired);
      return;
    }

    setState(() => _saving = true);
    try {
      UserProfile profile;
      if (_cachedProfile == null) {
        profile = await UserService.createProfile(
          name: name,
          email: email,
          password: password,
        );
      } else {
        profile = await UserService.updateProfile(
          userId: _cachedProfile!.userId,
          name: name,
          email: email,
          password: password.isEmpty ? null : password,
        );
      }

      await ProfileStorage.save(profile);
      if (!mounted) return;
      setState(() {
        _cachedProfile = profile;
        _passwordController.clear();
      });
      _showSnack(l10n.profileSaved);
    } catch (error) {
      _showSnack(l10n.profileSaveFailed);
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  Future<void> _clearProfile(AppLocalizations l10n) async {
    await ProfileStorage.clear();
    if (!mounted) return;
    setState(() {
      _cachedProfile = null;
      _nameController.clear();
      _emailController.clear();
      _passwordController.clear();
    });
    _showSnack(l10n.clearedProfile);
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: AppDurations.medium,
      ),
    );
  }

  bool _isValidEmail(String email) {
    final RegExp emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Scaffold(
      body: NexoraBackground(
        child: SafeArea(
          child: Stack(
            children: <Widget>[
              SingleChildScrollView(
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
                      onTap: () => _clearProfile(l10n),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _ProfileInputField(
                      icon: Icons.person_outline,
                      label: l10n.profileName,
                      controller: _nameController,
                      keyboardType: TextInputType.name,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _ProfileInputField(
                      icon: Icons.mail_outline_rounded,
                      label: l10n.profileEmail,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _ProfileInputField(
                      icon: Icons.lock_outline,
                      label: l10n.profilePassword,
                      controller: _passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      hintText: _cachedProfile == null
                          ? l10n.passwordRequired
                          : l10n.passwordOptional,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _PrimaryButton(
                      label: l10n.saveProfile,
                      onPressed: _saving ? null : () => _saveProfile(l10n),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextButton(
                          onPressed: () => _showSnack(l10n.dialogPlaceholder),
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
                          onPressed: () => _showSnack(l10n.dialogPlaceholder),
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
              if (_saving)
                Positioned.fill(
                  child: Container(
                    color: AppColors.background.withOpacity(0.65),
                    child: const Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(AppColors.goldAccent),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
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

class _ProfileInputField extends StatelessWidget {
  const _ProfileInputField({
    required this.icon,
    required this.label,
    required this.controller,
    required this.keyboardType,
    this.obscureText = false,
    this.hintText,
  });

  final IconData icon;
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.sm,
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
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              obscureText: obscureText,
              style: AppTextStyles.heading3.copyWith(
                color: AppColors.textPrimary,
                letterSpacing: 0.2,
              ),
              decoration: InputDecoration(
                labelText: label,
                hintText: hintText,
                labelStyle: AppTextStyles.body.copyWith(
                  color: AppColors.mutedText,
                ),
                hintStyle: AppTextStyles.body.copyWith(
                  color: AppColors.mutedText,
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

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.goldAccent,
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.md + 2,
            horizontal: AppSpacing.xl,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.buttonLabel.copyWith(
            color: AppColors.background,
          ),
        ),
      ),
    );
  }
}
