import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../models/game/puzzle.dart';
import '../../services/game/puzzle_repository.dart';
import '../../services/api/level_service.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';
import '../../utils/constants.dart';
import '../../widgets/game/answer_bar.dart';
import '../../widgets/game/level_app_bar.dart';
import '../../widgets/game/nexora_background.dart';
import '../../widgets/game/numeric_keypad.dart';
import '../../widgets/game/puzzle_card.dart';
import '../settings/settings_screen.dart';

class LevelPuzzleScreen extends StatefulWidget {
  const LevelPuzzleScreen({super.key, required this.level});

  final int level;

  @override
  State<LevelPuzzleScreen> createState() => _LevelPuzzleScreenState();
}

class _LevelPuzzleScreenState extends State<LevelPuzzleScreen> {
  late final PuzzleRepository _repository;
  late final Future<Puzzle> _puzzleFuture;
  final AnswerController _answer = AnswerController();
  Map<String, dynamic>? _levelData; // Backend'den gelen level verisi
  bool _isLoadingLevel = true; // Backend'den veri yükleniyor mu?
  bool _hasError = false; // Hata oluştu mu?

  @override
  void initState() {
    super.initState();
    _repository = const MockPuzzleRepository();
    _puzzleFuture = _repository.fetchLevel(widget.level);

    // Backend'den level bilgisini çek
    _fetchLevelFromBackend();
  }

  /// Backend'den level bilgisini çeker ve konsola yazdırır
  Future<void> _fetchLevelFromBackend() async {
    setState(() {
      _isLoadingLevel = true;
      _hasError = false;
    });

    try {
      final levelData = await LevelService.getLevel(widget.level);

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
        print('Level bilgisi alınamadı!');
      }
    } catch (e) {
      setState(() {
        _isLoadingLevel = false;
        _hasError = true;
      });
      print('Hata oluştu: $e');
    }
  }

  @override
  void dispose() {
    _answer.dispose();
    super.dispose();
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
                            (
                              BuildContext context,
                              AsyncSnapshot<Puzzle> snapshot,
                            ) {
                              final Puzzle puzzle =
                                  snapshot.data ??
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
                      // Loading overlay
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
                      // Hata durumu
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
                  onEnter: () => _showSoonSnack(context, l10n),
                  answerLabel: l10n.answerLabel,
                  enterLabel: l10n.enter,
                  hintLabel: l10n.hint,
                  answer: _levelData?['answer_value']?.toString() ?? '',
                  hint1: _levelData?['hint1']?.toString() ?? '',
                  hint2: _levelData?['hint2']?.toString() ?? '',
                  solutionExplanation:
                      _levelData?['solution_explanation']?.toString() ?? '',
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

  void _showSoonSnack(BuildContext context, AppLocalizations l10n) {
    final ScaffoldMessengerState? messenger = ScaffoldMessenger.maybeOf(
      context,
    );
    messenger?.hideCurrentSnackBar();
    messenger?.showSnackBar(
      SnackBar(
        content: Text(l10n.comingSoon),
        backgroundColor: AppColors.panel,
        duration: AppDurations.medium,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showHintDialog(BuildContext context) {
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
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.xl,
                ),
                decoration: BoxDecoration(
                  color: AppColors.panel,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(color: AppColors.goldAccent, width: 1.4),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(
                      color: Color(0x662C2410),
                      blurRadius: 32,
                      offset: Offset(0, 14),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Need Help?',
                      style: AppTextStyles.heading2.copyWith(
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    _HintOptionButton(
                      icon: Icons.ondemand_video,
                      title: 'Watch Ads for',
                      accent: 'Hint',
                      onTap: () => Navigator.pop(context),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _HintOptionButton(
                      icon: Icons.ondemand_video,
                      title: 'Watch Ads for',
                      accent: 'Solution',
                      onTap: () => Navigator.pop(context),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                      'OR',
                      style: AppTextStyles.heading3.copyWith(
                        color: AppColors.goldAccent,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    _PremiumButton(onTap: () => Navigator.pop(context)),
                    const SizedBox(height: AppSpacing.lg),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text(
                        'No, thanks',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.mutedText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _HintOptionButton extends StatelessWidget {
  const _HintOptionButton({
    required this.icon,
    required this.title,
    required this.accent,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm + 2,
        ),
        decoration: BoxDecoration(
          color: AppColors.keypadTile,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.panelBorder),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(icon, color: AppColors.mutedText, size: 26),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  title,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.mutedText,
                  ),
                ),
              ],
            ),
            Text(
              accent,
              style: AppTextStyles.heading3.copyWith(
                color: AppColors.textPrimary,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PremiumButton extends StatelessWidget {
  const _PremiumButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.md,
          horizontal: AppSpacing.lg,
        ),
        decoration: BoxDecoration(
          color: AppColors.keypadTileHighlight,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.goldAccent, width: 1.2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.workspace_premium_outlined,
              color: AppColors.goldAccent,
              size: 22,
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'Be Premium',
              style: AppTextStyles.buttonLabel.copyWith(
                color: AppColors.goldAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FooterMetaBar extends StatelessWidget {
  const _FooterMetaBar({this.onSettingsTap});

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
          const _FooterMeta(icon: Icons.person_outline, label: 'Profile'),
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
