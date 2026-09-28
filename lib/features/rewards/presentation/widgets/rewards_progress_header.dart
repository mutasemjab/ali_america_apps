import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// The number that drives everything below it — shown big and first.
class RewardsProgressHeader extends StatelessWidget {
  final int currentVisits;

  const RewardsProgressHeader({super.key, required this.currentVisits});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          const Icon(Icons.emoji_events_rounded, color: Colors.white, size: 32),
          const SizedBox(height: 8),
          Text(
            '$currentVisits ${currentVisits == 1 ? 'point' : 'points'}',
            style: AppTextStyles.displayMedium.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 4),
          Text(
            'Keep earning points to unlock more rewards',
            style: AppTextStyles.bodyMedium.copyWith(color: Colors.white.withValues(alpha: 0.85)),
          ),
        ],
      ),
    );
  }
}
