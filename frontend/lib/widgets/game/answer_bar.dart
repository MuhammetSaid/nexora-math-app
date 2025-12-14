import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

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
    required this.answerLabel,
    required this.enterLabel,
    required this.hintLabel,
  });

  final ValueListenable<String> answerListenable;
  final VoidCallback onClearLast;
  final VoidCallback onClearAll;
  final VoidCallback onHint;
  final VoidCallback onEnter;
  final String answerLabel;
  final String enterLabel;
  final String hintLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
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
          _EnterButton(
            label: enterLabel,
            onTap: onEnter,
          ),
        ],
      ),
    );
  }
}

class _AnswerField extends StatelessWidget {
  const _AnswerField({
    required this.label,
    required this.answerListenable,
  });

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

    return Tooltip(
      message: tooltip!,
      child: button,
    );
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
