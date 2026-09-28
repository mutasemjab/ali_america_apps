import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/barcode_countdown_view.dart';

/// Shown right after a successful redemption. Deliberately minimal — just
/// the countdown, "show this at checkout", and the barcode. No product
/// image, name, or price: by the time this shows, the points are already
/// spent, so there's nothing left to decide and nothing else to show.
Future<void> showRewardRedeemedSheet(
  BuildContext context, {
  required String barcode,
  required int? minutesRemaining,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) => DraggableScrollableSheet(
      initialChildSize: 0.42,
      minChildSize: 0.3,
      maxChildSize: 0.6,
      expand: false,
      builder: (context, scrollController) => Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: ListView(
          controller: scrollController,
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12, bottom: 20),
                width: 40,
                height: 4,
                decoration:
                    BoxDecoration(color: AppColors.divider, borderRadius: BorderRadius.circular(4)),
              ),
            ),
            BarcodeCountdownView(
              barcode: barcode,
              minutesRemaining: minutesRemaining,
              readyLabel: 'Redeemed',
            ),
          ],
        ),
      ),
    ),
  );
}
