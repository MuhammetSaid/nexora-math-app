import 'dart:convert';

import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../models/game/puzzle.dart';
import '../../models/user_profile.dart';
import '../../services/api/level_service.dart';
import '../../services/api/user_service.dart';
import '../../services/game/puzzle_repository.dart';
import '../../services/storage/profile_storage.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';
import '../../utils/constants.dart';
import '../../widgets/game/answer_bar.dart';
import '../../widgets/game/level_app_bar.dart';
import '../../widgets/game/nexora_background.dart';
import '../../widgets/game/numeric_keypad.dart';
import '../../widgets/game/puzzle_card.dart';
import '../profile/profile_settings_screen.dart';
import '../settings/settings_screen.dart';

class LevelPuzzleScreen extends StatefulWidget {
  const LevelPuzzleScreen({
    super.key,
    required this.level,
    this.profile,
    this.onProfileUpdated,
  });

  final int level;
  final UserProfile? profile;
  final ValueChanged<UserProfile>? onProfileUpdated;

  @override
  State<LevelPuzzleScreen> createState() => _LevelPuzzleScreenState();
}

class _LevelPuzzleScreenState extends State<LevelPuzzleScreen> {
  late final PuzzleRepository _repository;
  late Future<Puzzle> _puzzleFuture;
  final AnswerController _answer = AnswerController();
  Map<String, dynamic>? _levelData;
  bool _isLoadingLevel = true;
  bool _hasError = false;
  UserProfile? _activeProfile;

  @override
  void initState() {
    super.initState();
    _repository = const MockPuzzleRepository();
    _puzzleFuture = _repository.fetchLevel(widget.level);
    _activeProfile = widget.profile;
    _fetchLevelFromBackend();
  }

  Future<void> _fetchLevelFromBackend() async {
    setState(() {
      _isLoadingLevel = true;
      _hasError = false;
    });

    try {
      final Map<String, dynamic>? levelData =
          await LevelService.getLevel(widget.level);

      if (!mounted) return;
      if (levelData != null) {
        setState(() {
          _levelData = levelData;
          _isLoadingLevel = false;
        });
      } else {
        setState(() {
          _isLoadingLevel = false;
          _hasError = true;
        });
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoadingLevel = false;
        _hasError = true;
      });
    }
  }

  @override
  void dispose() {
    _answer.dispose();
    super.dispose();
  }

  Future<void> _goToNextLevel() async {
    final int nextLevel = widget.level + 1;
    UserProfile? updatedProfile = _activeProfile;

    if (_activeProfile != null && nextLevel > _activeProfile!.level) {
      try {
        updatedProfile = await UserService.updateProfile(
          userId: _activeProfile!.userId,
          level: nextLevel,
        );
        await ProfileStorage.save(updatedProfile);
        _handleProfileUpdated(updatedProfile);
      } catch (_) {
        // backend unreachable; continue without updating cached profile
      }
    }

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => LevelPuzzleScreen(
          level: nextLevel,
          profile: updatedProfile,
          onProfileUpdated: widget.onProfileUpdated,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Scaffold(
      body: NexoraBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.lg,
            ),
            child: Column(
              children: <Widget>[
                LevelAppBar(
                  title: l10n.levelTitle(widget.level),
                  onBack: () => Navigator.maybePop(context),
                ),
                const SizedBox(height: AppSpacing.lg),
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      FutureBuilder<Puzzle>(
                        future: _puzzleFuture,
                        builder:
                            (BuildContext context, AsyncSnapshot<Puzzle> snapshot) {
                          final Puzzle puzzle = snapshot.data ??
                              Puzzle(
                                level: widget.level,
                                lines: const <String>[
                                  '5, 3 = 28',
                                  '7, 6 = 55',
                                  '4, 5 = 21',
                                  '3, 8 = ?',
                                ],
                              );
                          return PuzzleCard(
                            lines: puzzle.lines,
                            imagePath: _levelData?['image_path'] ?? '',
                            level: widget.level,
                          );
                        },
                      ),
                      if (_isLoadingLevel)
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.background.withOpacity(0.85),
                            borderRadius: BorderRadius.circular(AppRadius.lg),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.goldAccent,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.md),
                                Text(
                                  'Level yükleniyor...',
                                  style: AppTextStyles.body.copyWith(
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (_hasError && !_isLoadingLevel)
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.background.withOpacity(0.85),
                            borderRadius: BorderRadius.circular(AppRadius.lg),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Icon(
                                  Icons.error_outline,
                                  color: AppColors.goldAccent,
                                  size: 48,
                                ),
                                const SizedBox(height: AppSpacing.md),
                                Text(
                                  'Level yüklenemedi',
                                  style: AppTextStyles.heading3.copyWith(
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                Text(
                                  'Lütfen tekrar deneyin',
                                  style: AppTextStyles.body.copyWith(
                                    color: AppColors.mutedText,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.lg),
                                ElevatedButton(
                                  onPressed: _fetchLevelFromBackend,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.goldAccent,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppSpacing.xl,
                                      vertical: AppSpacing.md,
                                    ),
                                  ),
                                  child: Text(
                                    'Tekrar Dene',
                                    style: AppTextStyles.buttonLabel.copyWith(
                                      color: AppColors.background,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                AnswerBar(
                  answerListenable: _answer,
                  onClearLast: _answer.removeLast,
                  onClearAll: _answer.clear,
                  onHint: () => _showHintDialog(context),
                  onEnter: () {},
                  onCorrect: _goToNextLevel,
                  answerLabel: l10n.answerLabel,
                  enterLabel: l10n.enter,
                  hintLabel: l10n.hint,
                  answer: _levelData?['answer_value']?.toString() ?? '',
                ),
                const SizedBox(height: AppSpacing.sm),
                NumericKeypad(
                  layout: const <List<String>>[
                    <String>['1', '2', '3', '4', '5'],
                    <String>['6', '7', '8', '9', '0'],
                  ],
                  highlightedValues: const <String>{},
                  onKeyTap: _answer.append,
                ),
                const SizedBox(height: AppSpacing.md),
                _FooterMetaBar(
                  onProfileTap: _openProfile,
                  onSettingsTap: () {
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
      ),
    );
  }

  Future<void> _openProfile() async {
    final UserProfile? result = await Navigator.push<UserProfile?>(
      context,
      MaterialPageRoute<UserProfile?>(
        builder: (_) => ProfileSettingsScreen(
          onProfileChanged: _handleProfileUpdated,
        ),
      ),
    );
    if (result != null) {
      _handleProfileUpdated(result);
    }
  }

  void _handleProfileUpdated(UserProfile profile) {
    setState(() {
      _activeProfile = profile;
    });
    widget.onProfileUpdated?.call(profile);
  }

  void _showHintDialog(BuildContext context) {
    final Locale locale = Localizations.localeOf(context);
    final List<_HintItem> entries = <_HintItem>[];
    final String hint1 = _localizedText(_levelData?['hint1'], locale);
    final String hint2 = _localizedText(_levelData?['hint2'], locale);
    final String solution =
        _localizedText(_levelData?['solution_explanation'], locale);

    if (hint1.isNotEmpty) entries.add(_HintItem('Hint 1', hint1));
    if (hint2.isNotEmpty) entries.add(_HintItem('Hint 2', hint2));
    if (solution.isNotEmpty) entries.add(_HintItem('Solution', solution));
    int selected = 0;

    showDialog<void>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.65),
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Material(
            color: Colors.transparent,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.panel,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(color: AppColors.goldAccent, width: 1.2),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(
                      color: Color(0x662C2410),
                      blurRadius: 28,
                      offset: Offset(0, 12),
                    ),
                  ],
                ),
                child: entries.isEmpty
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'Bu seviye için ipucu bulunamadı.',
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.textPrimary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'Kapat',
                              style: AppTextStyles.buttonLabel.copyWith(
                                color: AppColors.goldAccent,
                              ),
                            ),
                          ),
                        ],
                      )
                    : StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Hints',
                                style: AppTextStyles.heading2.copyWith(
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.md),
                              Wrap(
                                spacing: AppSpacing.sm,
                                runSpacing: AppSpacing.sm,
                                children: List<Widget>.generate(entries.length,
                                    (int index) {
                                  final bool isSelected = selected == index;
                                  return ChoiceChip(
                                    label: Text(
                                      entries[index].label,
                                      style: AppTextStyles.caption.copyWith(
                                        color: isSelected
                                            ? AppColors.background
                                            : AppColors.textPrimary,
                                      ),
                                    ),
                                    selected: isSelected,
                                    onSelected: (bool _) {
                                      setState(() {
                                        selected = index;
                                      });
                                    },
                                    selectedColor: AppColors.goldAccent,
                                    backgroundColor: AppColors.keypadTile,
                                    labelPadding: const EdgeInsets.symmetric(
                                      horizontal: AppSpacing.sm,
                                      vertical: AppSpacing.xs,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(AppRadius.md),
                                      side: BorderSide(
                                        color: isSelected
                                            ? AppColors.goldAccent
                                            : AppColors.panelBorder,
                                      ),
                                    ),
                                  );
                                }),
                              ),
                              const SizedBox(height: AppSpacing.md),
                              Container(
                                width: double.infinity,
                                constraints:
                                    const BoxConstraints(maxHeight: 280),
                                padding: const EdgeInsets.all(AppSpacing.md),
                                decoration: BoxDecoration(
                                  color: AppColors.keypadTile,
                                  borderRadius:
                                      BorderRadius.circular(AppRadius.md),
                                  border: Border.all(
                                    color: AppColors.panelBorder,
                                  ),
                                ),
                                child: SingleChildScrollView(
                                  child: Text(
                                    entries[selected].value,
                                    style: AppTextStyles.body.copyWith(
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: AppSpacing.md),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(
                                    'Kapat',
                                    style: AppTextStyles.buttonLabel.copyWith(
                                      color: AppColors.goldAccent,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _HintItem {
  _HintItem(this.label, this.value);

  final String label;
  final String value;
}

String _localizedText(dynamic raw, Locale locale) {
  if (raw == null) return '';
  if (raw is Map) {
    final Object? direct = raw[locale.languageCode];
    if (direct != null && direct.toString().trim().isNotEmpty) {
      return direct.toString().trim();
    }
    final Object? en = raw['en'];
    if (en != null && en.toString().trim().isNotEmpty) {
      return en.toString().trim();
    }
    for (final Object? value in raw.values) {
      if (value != null && value.toString().trim().isNotEmpty) {
        return value.toString().trim();
      }
    }
    return '';
  }

  final String str = raw.toString().trim();
  if (str.isEmpty) return '';
  // Try decode JSON-like string to pick locale-specific content
  if (str.startsWith('{') && str.endsWith('}')) {
    try {
      final Object? decoded = jsonDecode(str);
      if (decoded is Map<String, dynamic>) {
        return _localizedText(decoded, locale);
      }
    } catch (_) {
      // fall through to return raw string
    }
  }
  return str;
}

class _FooterMetaBar extends StatelessWidget {
  const _FooterMetaBar({this.onProfileTap, this.onSettingsTap});

  final VoidCallback? onProfileTap;
  final VoidCallback? onSettingsTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.sm,
        horizontal: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.keypadSurface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.panelBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          const _FooterMeta(icon: Icons.emoji_events_outlined, label: 'Trophy'),
          _FooterMeta(
            icon: Icons.person_outline,
            label: 'Profile',
            onTap: onProfileTap,
          ),
          _FooterMeta(
            icon: Icons.settings_outlined,
            label: 'Settings',
            onTap: onSettingsTap,
          ),
        ],
      ),
    );
  }
}

class _FooterMeta extends StatelessWidget {
  const _FooterMeta({required this.icon, required this.label, this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(icon, color: AppColors.goldAccent, size: 22),
        const SizedBox(height: AppSpacing.xs),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.mutedText,
            fontSize: 12,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
    if (onTap == null) return content;
    return GestureDetector(onTap: onTap, child: content);
  }
}

class AnswerController extends ValueNotifier<String> {
  AnswerController() : super('');

  void append(String value) {
    if (value.isEmpty) return;
    this.value = '${this.value}$value';
  }

  void removeLast() {
    if (value.isEmpty) return;
    value = value.substring(0, value.length - 1);
  }

  void clear() {
    value = '';
  }
}
