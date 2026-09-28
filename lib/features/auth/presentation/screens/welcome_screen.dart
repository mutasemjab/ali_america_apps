import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../home/presentation/widgets/store_logo.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const Spacer(flex: 2),
              const StoreLogo(size: 180).animate().fadeIn(duration: 500.ms).scale(
                    begin: const Offset(0.85, 0.85),
                    end: const Offset(1, 1),
                  ),
              const SizedBox(height: 28),
              Text(
                'Welcome',
                style: AppTextStyles.displayLarge,
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 150.ms, duration: 400.ms),
              const SizedBox(height: 10),
              Text(
                'Deals, coupons, and rewards from your favorite store — all in one place.',
                style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 250.ms, duration: 400.ms),
              const Spacer(flex: 3),
              AppButton(
                label: 'Register',
                onPressed: () => context.push('/register'),
              ).animate().fadeIn(delay: 350.ms).slideY(begin: 0.2, end: 0),
              const SizedBox(height: 12),
              AppButton(
                label: 'I already have an account',
                outlined: true,
                onPressed: () => context.push('/login'),
              ).animate().fadeIn(delay: 420.ms).slideY(begin: 0.2, end: 0),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => context.go('/home'),
                child: const Text('Continue as Guest'),
              ).animate().fadeIn(delay: 480.ms),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
