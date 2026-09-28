import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/career_entity.dart';

class CareerCard extends StatelessWidget {
  final CareerEntity career;
  final bool applied;
  final VoidCallback onTap;

  const CareerCard({super.key, required this.career, required this.applied, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(career.title, style: AppTextStyles.titleLarge)),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryLight,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.work_outline_rounded, color: AppColors.primaryDark, size: 20),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  career.description,
                  style: AppTextStyles.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 14),
                if (applied)
                  Row(
                    children: [
                      const Icon(Icons.check_circle_rounded, size: 18, color: AppColors.success),
                      const SizedBox(width: 6),
                      Text(
                        'Applied',
                        style: AppTextStyles.titleMedium.copyWith(color: AppColors.success),
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      Text(
                        'View & Apply',
                        style: AppTextStyles.titleMedium.copyWith(color: AppColors.primaryDark),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.arrow_forward_rounded, size: 16, color: AppColors.primaryDark),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
