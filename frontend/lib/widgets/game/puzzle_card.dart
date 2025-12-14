import 'package:flutter/material.dart';

import '../../theme/colors.dart';
import '../../theme/text_styles.dart';
import '../../utils/constants.dart';

class PuzzleCard extends StatelessWidget {
  const PuzzleCard({
    super.key,
    required this.lines,
    required this.imagePath,
    required this.level,
  });

  final List<String> lines;
  final String imagePath;
  final int level;
  @override
  Widget build(BuildContext context) {
    final String content = lines.join('\n');
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 320),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.xl + AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: Color(0xFF1e1e1e),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.panelBorder),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Center(
        child: Image.asset(
          imagePath,
        ),
      ),
    );
  }
}
