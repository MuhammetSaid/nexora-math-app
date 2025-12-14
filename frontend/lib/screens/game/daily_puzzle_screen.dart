import 'dart:math';

import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../models/game/puzzle.dart';
import '../../services/game/puzzle_repository.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';
import '../../utils/constants.dart';
import '../../widgets/game/answer_bar.dart';
import '../../widgets/game/level_app_bar.dart';
import '../../widgets/game/nexora_background.dart';
import '../../widgets/game/numeric_keypad.dart';
import '../../widgets/game/puzzle_card.dart';
import 'question_screen.dart';

import '../../services/api/level_service.dart';

class DailyPuzzleScreen extends StatefulWidget {
  const DailyPuzzleScreen({super.key});

  @override
  State<DailyPuzzleScreen> createState() => _DailyPuzzleScreenState();
}

class _DailyPuzzleScreenState extends State<DailyPuzzleScreen> {
  late final PuzzleRepository _repository;
  late final Future<Puzzle> _puzzleFuture;
  final AnswerController _answer = AnswerController();
  Map<String, dynamic>? _levelData; // Backend'den gelen level verisi
  bool _isLoadingLevel = true; // Backend'den veri yükleniyor mu?
  bool _hasError = false; // Hata oluştu mu?
  late final int level; // Rastgele level (1-2 arası)
  Future<void> _fetchLevelFromBackend() async {
    setState(() {
      _isLoadingLevel = true;
      _hasError = false;
    });

    try {
      final levelData = await LevelService.getLevel(level);

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
    } catch (e) {
      setState(() {
        _isLoadingLevel = false;
        _hasError = true;
      });
      print('Hata oluştu: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    // Rastgele 1-2 arası level oluştur
    level = Random().nextInt(8) + 1;
    _repository = const MockPuzzleRepository();
    _puzzleFuture = _repository.fetchLevel(level);

    // Backend'den level bilgisini çek
    _fetchLevelFromBackend();
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
                  title: l10n.dailyPuzzle,
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
                                    level: level,
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
                                level: level,
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
                  onHint: () => _showSoonSnack(context, l10n),
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
}
