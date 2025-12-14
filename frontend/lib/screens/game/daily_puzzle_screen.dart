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

class DailyPuzzleScreen extends StatefulWidget {
  const DailyPuzzleScreen({super.key});

  @override
  State<DailyPuzzleScreen> createState() => _DailyPuzzleScreenState();
}

class _DailyPuzzleScreenState extends State<DailyPuzzleScreen> {
  late final PuzzleRepository _repository;
  late final Future<Puzzle> _puzzleFuture;
  final AnswerController _answer = AnswerController();

  @override
  void initState() {
    super.initState();
    _repository = const MockPuzzleRepository();
    _puzzleFuture = _repository.fetchLevel(0);
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
                  child: FutureBuilder<Puzzle>(
                    future: _puzzleFuture,
                    builder: (
                      BuildContext context,
                      AsyncSnapshot<Puzzle> snapshot,
                    ) {
                      final Puzzle puzzle = snapshot.data ??
                          Puzzle(
                            level: 0,
                            lines: const <String>[
                              '5, 3 = 28',
                              '7, 6 = 55',
                              '4, 5 = 21',
                              '3, 8 = ?',
                            ],
                          );
                      return PuzzleCard(lines: puzzle.lines);
                    },
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
    final ScaffoldMessengerState? messenger = ScaffoldMessenger.maybeOf(context);
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
