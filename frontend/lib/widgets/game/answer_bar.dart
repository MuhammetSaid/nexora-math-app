import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../theme/colors.dart';
import '../../theme/text_styles.dart';
import '../../utils/constants.dart';

class AnswerBar extends StatelessWidget {
  const AnswerBar({
    super.key,
    required this.answerListenable,
    required this.onClearLast,
    required this.onClearAll,
    required this.onHint,
    required this.onEnter,
    this.onCorrect,
    required this.answerLabel,
    required this.enterLabel,
    required this.hintLabel,
    required this.answer,
    required this.hint1,
    required this.hint2,
    required this.solutionExplanation,
  });

  final ValueListenable<String> answerListenable;
  final VoidCallback onClearLast;
  final VoidCallback onClearAll;
  final VoidCallback onHint;
  final VoidCallback onEnter;
  final VoidCallback? onCorrect;
  final String answerLabel;
  final String enterLabel;
  final String hintLabel;
  final String answer;
  final String hint1;
  final String hint2;
  final String solutionExplanation;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.keypadSurface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.panelBorder),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: _AnswerField(
              label: answerLabel,
              answerListenable: answerListenable,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          _SquareButton(
            icon: Icons.close_rounded,
            onTap: onClearLast,
            onLongPress: onClearAll,
            tooltip: null,
          ),
          const SizedBox(width: AppSpacing.sm),
          _SquareButton(
            icon: Icons.lightbulb_outline_rounded,
            onTap: onHint,
            tooltip: hintLabel,
          ),
          const SizedBox(width: AppSpacing.sm),
          _EnterButton(label: enterLabel, onTap: () => _handleEnter(context)),
        ],
      ),
    );
  }

  void _handleEnter(BuildContext context) {
    final String userAnswer = answerListenable.value.trim();
    if (userAnswer.isEmpty) {
      return;
    }
    onEnter();

    final String correctAnswer = answer.toString().trim();
    if (userAnswer == correctAnswer) {
      _showSuccessDialog(context);
    } else {
      _showErrorDialog(context);
    }
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.75),
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              color: AppColors.panel,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: AppColors.goldAccent, width: 2),
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
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.goldAccent.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle_outline,
                    color: AppColors.goldAccent,
                    size: 48,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Tebrikler!',
                  style: AppTextStyles.heading2.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 28,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Doğru cevabı buldunuz!',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.mutedText,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xl),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onClearAll();
                    onCorrect?.call();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.goldAccent,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                  child: Text(
                    'Sonraki Level',
                    style: AppTextStyles.buttonLabel.copyWith(
                      color: AppColors.background,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.65),
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              color: AppColors.panel,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: Colors.redAccent, width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(Icons.close_rounded, color: Colors.redAccent, size: 64),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Yanlış Cevap!',
                  style: AppTextStyles.heading3.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Tekrar deneyin veya ipucu alın',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.mutedText,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.lg),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                  child: Text(
                    'Tekrar Dene',
                    style: AppTextStyles.buttonLabel.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AnswerField extends StatelessWidget {
  const _AnswerField({required this.label, required this.answerListenable});

  final String label;
  final ValueListenable<String> answerListenable;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: answerListenable,
      builder: (BuildContext context, String value, Widget? _) {
        final bool isEmpty = value.isEmpty;
        return Container(
          height: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.panel,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: isEmpty ? AppColors.panelBorder : AppColors.goldAccent,
              width: isEmpty ? 1 : 1.4,
            ),
          ),
          alignment: Alignment.centerLeft,
          child: Text(
            isEmpty ? label : value,
            style: isEmpty
                ? AppTextStyles.subtitle.copyWith(color: AppColors.tertiaryText)
                : AppTextStyles.answerInput,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        );
      },
    );
  }
}

class _SquareButton extends StatelessWidget {
  const _SquareButton({
    required this.icon,
    required this.onTap,
    this.onLongPress,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final Widget button = InkResponse(
      onTap: onTap,
      onLongPress: onLongPress,
      radius: 28,
      child: Container(
        width: 48,
        height: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.keypadTile,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.panelBorder),
        ),
        child: Icon(icon, color: AppColors.mutedText, size: 22),
      ),
    );

    if (tooltip == null || tooltip!.isEmpty) {
      return button;
    }

    return Tooltip(message: tooltip!, child: button);
  }
}

class _EnterButton extends StatelessWidget {
  const _EnterButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.keypadTileHighlight,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.goldAccent, width: 1.3),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color(0x332C2410),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          label.toUpperCase(),
          style: AppTextStyles.buttonLabel.copyWith(color: AppColors.mutedText),
        ),
      ),
    );
  }
}
