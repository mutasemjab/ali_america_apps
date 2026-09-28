import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'app_button.dart';

/// Shown in place of member-only content (profile form, coupon wallet) when
/// browsing as a guest — an invitation to sign up, never a dead end.
class GuestPrompt extends StatelessWidget {
  final String title;
  final String message;

  const GuestPrompt({
    super.key,
    this.title = 'Join to unlock this',
    this.message = 'Register or log in to save coupons, track visits, and manage your profile.',
  });

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
              child: const Icon(Icons.lock_outline_rounded, size: 36, color: AppColors.primaryDark),
            ),
            const SizedBox(height: 20),
            Text(title, style: AppTextStyles.titleLarge, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(message, style: AppTextStyles.bodyMedium, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            AppButton(label: 'Register', onPressed: () => context.push('/register')),
            const SizedBox(height: 10),
            AppButton(
              label: 'Log in',
              outlined: true,
              onPressed: () => context.push('/login'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Bottom-sheet variant for interrupting an in-place action (e.g. tapping
/// "Clip" on a coupon as a guest) without navigating away first.
Future<void> showGuestPromptSheet(BuildContext context, {String? message}) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) => Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(color: AppColors.divider, borderRadius: BorderRadius.circular(4)),
          ),
          const SizedBox(height: 20),
          Text('Log in to continue', style: AppTextStyles.titleLarge),
          const SizedBox(height: 8),
          Text(
            message ?? 'Create a free account or log in to do that.',
            style: AppTextStyles.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          AppButton(
            label: 'Register',
            onPressed: () {
              Navigator.of(sheetContext).pop();
              context.push('/register');
            },
          ),
          const SizedBox(height: 10),
          AppButton(
            label: 'Log in',
            outlined: true,
            onPressed: () {
              Navigator.of(sheetContext).pop();
              context.push('/login');
            },
          ),
        ],
      ),
    ),
  );
}
