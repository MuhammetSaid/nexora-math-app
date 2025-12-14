import 'package:flutter/material.dart';

import '../../theme/colors.dart';
import '../../theme/text_styles.dart';
import '../../utils/constants.dart';

class NumericKeypad extends StatelessWidget {
  const NumericKeypad({
    super.key,
    required this.layout,
    required this.highlightedValues,
    required this.onKeyTap,
  });

  final List<List<String>> layout;
  final Set<String> highlightedValues;
  final ValueChanged<String> onKeyTap;

  @override
  Widget build(BuildContext context) {
    final List<String> flattened = layout.expand((List<String> row) => row).toList();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.keypadSurface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.panelBorder),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          mainAxisSpacing: AppSpacing.sm,
          crossAxisSpacing: AppSpacing.sm,
          childAspectRatio: 1.05,
        ),
        itemCount: flattened.length,
        itemBuilder: (BuildContext context, int index) {
          final String value = flattened[index];
          return KeyButton(
            label: value,
            highlighted: highlightedValues.contains(value),
            onTap: () => onKeyTap(value),
          );
        },
      ),
    );
  }
}

class KeyButton extends StatefulWidget {
  const KeyButton({
    super.key,
    required this.label,
    required this.onTap,
    this.highlighted = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool highlighted;

  @override
  State<KeyButton> createState() => _KeyButtonState();
}

class _KeyButtonState extends State<KeyButton> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() {
      _pressed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool active = widget.highlighted || _pressed;
    return AnimatedContainer(
      duration: AppDurations.short,
      decoration: BoxDecoration(
        color: active ? AppColors.keypadTileHighlight : AppColors.keypadTile,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(
          color: active ? AppColors.goldAccent : AppColors.panelBorder,
          width: active ? 1.2 : 1,
        ),
        boxShadow: active
            ? const <BoxShadow>[
                BoxShadow(
                  color: Color(0x332C2410),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: GestureDetector(
        onTapDown: (_) => _setPressed(true),
        onTapCancel: () => _setPressed(false),
        onTapUp: (_) => _setPressed(false),
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: Text(
            widget.label,
            style: AppTextStyles.keypadNumber,
          ),
        ),
      ),
    );
  }
}
