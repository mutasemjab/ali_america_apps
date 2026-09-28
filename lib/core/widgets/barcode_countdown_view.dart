import 'dart:async';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Live countdown (optional) plus a scannable barcode — shared by any
/// "redeem this at checkout" flow (coupons today, rewards too).
///
/// Deliberately driven by [minutesRemaining] — a plain number the backend
/// computes server-side — rather than diffing an `expires_at` timestamp
/// against the device clock. Those timestamps come back with no timezone
/// marker, so a server/device timezone mismatch throws a timestamp-based
/// countdown off by hours. A bare number of minutes has nothing to
/// misinterpret: this widget just starts a local timer from it and ticks
/// down every second using the device's own clock, never touching a
/// server timestamp again. Pass null when there's no expiry concept at
/// all (e.g. a reward) — the barcode just shows [readyLabel] instead of a
/// ticking clock, and never dims/disables.
class BarcodeCountdownView extends StatefulWidget {
  final String barcode;
  final int? minutesRemaining;
  final String readyLabel;

  const BarcodeCountdownView({
    super.key,
    required this.barcode,
    required this.minutesRemaining,
    this.readyLabel = 'Ready',
  });

  @override
  State<BarcodeCountdownView> createState() => _BarcodeCountdownViewState();
}

class _BarcodeCountdownViewState extends State<BarcodeCountdownView> {
  Timer? _timer;
  Duration? _remaining;

  @override
  void initState() {
    super.initState();
    final minutes = widget.minutesRemaining;
    if (minutes == null) return;

    _remaining = Duration(minutes: minutes);
    if (_remaining! <= Duration.zero) return;

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      final next = _remaining! - const Duration(seconds: 1);
      setState(() => _remaining = next.isNegative ? Duration.zero : next);
      if (_remaining! <= Duration.zero) _timer?.cancel();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _format(Duration d) {
    if (d <= Duration.zero) return '00:00';
    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60);
    final seconds = d.inSeconds.remainder(60);
    final mm = minutes.toString().padLeft(2, '0');
    final ss = seconds.toString().padLeft(2, '0');
    return hours > 0 ? '$hours:$mm:$ss' : '$mm:$ss';
  }

  @override
  Widget build(BuildContext context) {
    final remaining = _remaining;
    final expired = remaining != null && remaining <= Duration.zero;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              expired ? Icons.timer_off_rounded : Icons.timer_outlined,
              size: 18,
              color: expired ? AppColors.textSecondary : AppColors.error,
            ),
            const SizedBox(width: 6),
            Text(
              expired
                  ? 'Expired'
                  : remaining != null
                      ? _format(remaining)
                      : widget.readyLabel,
              style: AppTextStyles.displayMedium.copyWith(
                color: expired ? AppColors.textSecondary : AppColors.error,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          expired ? 'This can no longer be redeemed' : 'Show this barcode at checkout',
          style: AppTextStyles.bodyMedium,
        ),
        // Once expired, the barcode is gone entirely — not dimmed, not
        // still there for a screenshot — so it can't be redeemed after
        // the window closes.
        if (!expired) ...[
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.divider),
            ),
            child: BarcodeWidget(
              barcode: Barcode.code128(),
              data: widget.barcode,
              width: double.infinity,
              height: 90,
              drawText: true,
              style: AppTextStyles.bodyMedium.copyWith(letterSpacing: 1.2),
              errorBuilder: (context, error) => const SizedBox(
                height: 90,
                child: Center(child: Text('Could not render barcode')),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
