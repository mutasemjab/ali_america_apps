import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Slim, dismissible-feeling bar shown while the device has no connection.
/// Purely presentational — the connectivity stream lives above it.
class OfflineBanner extends StatelessWidget {
  final bool visible;

  const OfflineBanner({super.key, required this.visible});

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      child: !visible
          ? const SizedBox(width: double.infinity)
          : Container(
              width: double.infinity,
              color: AppColors.secondary,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 8,
                bottom: 8,
                left: 16,
                right: 16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.cloud_off_rounded, size: 16, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    "You're offline",
                    style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
    );
  }
}
