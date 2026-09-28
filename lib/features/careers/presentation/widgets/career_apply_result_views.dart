import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';

/// Shown in place of the form once the application goes through — a
/// checkmark confirmation rather than silently popping the screen.
class CareerApplySuccessView extends StatelessWidget {
  final VoidCallback onDone;
  const CareerApplySuccessView({super.key, required this.onDone});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle),
              child: const Icon(Icons.check_rounded, color: Colors.white, size: 44),
            ).animate().scale(duration: 350.ms, curve: Curves.elasticOut),
            const SizedBox(height: 24),
            Text('Application sent!', style: AppTextStyles.displayMedium, textAlign: TextAlign.center)
                .animate()
                .fadeIn(delay: 150.ms),
            const SizedBox(height: 8),
            Text(
              "We'll be in touch if it's a match.",
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 220.ms),
            const SizedBox(height: 32),
            AppButton(label: 'Done', onPressed: onDone),
          ],
        ),
      ),
    );
  }
}

/// Shown instead of the form when this career has already been applied to
/// — either from a fresh "already applied" 422, or because the device
/// already recorded it locally on a previous visit.
class CareerAlreadyAppliedView extends StatelessWidget {
  final VoidCallback onBack;
  const CareerAlreadyAppliedView({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 84,
              height: 84,
              decoration: const BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
              child: const Icon(Icons.check_circle_rounded, size: 38, color: AppColors.primaryDark),
            ),
            const SizedBox(height: 20),
            Text("You've already applied", style: AppTextStyles.titleLarge, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
              "You can only apply once for this position — we've got your application on file.",
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            AppButton(label: 'Back to Careers', outlined: true, onPressed: onBack),
          ],
        ),
      ),
    );
  }
}
