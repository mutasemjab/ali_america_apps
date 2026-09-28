import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// The "Clip this coupon" action. Tapping it fires [onTap] immediately
/// (never waits on the animation) and plays a one-shot "cut along the
/// dotted line" snip: the scissors icon snaps shut and the dashed divider
/// either side of it pops apart, then everything settles back.
class ClipSnipButton extends StatefulWidget {
  final String label;
  final bool loading;
  final VoidCallback onTap;

  const ClipSnipButton({
    super.key,
    required this.label,
    required this.loading,
    required this.onTap,
  });

  @override
  State<ClipSnipButton> createState() => _ClipSnipButtonState();
}

class _ClipSnipButtonState extends State<ClipSnipButton> {
  int _snipCount = 0;

  void _handleTap() {
    if (widget.loading) return;
    setState(() => _snipCount++);
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primaryLight,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: widget.loading ? null : _handleTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: _DashedLine(key: ValueKey('left-$_snipCount'))
                    .animate()
                    .fadeIn(duration: 150.ms)
                    .slideX(begin: 0.4, end: 0, duration: 250.ms, curve: Curves.easeOut),
              ),
              const SizedBox(width: 10),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: widget.loading
                    ? const SizedBox(
                        key: ValueKey('loading'),
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2.4, color: AppColors.primaryDark),
                      )
                    : Icon(
                        Icons.content_cut_rounded,
                        key: ValueKey('scissors-$_snipCount'),
                        color: AppColors.primaryDark,
                        size: 22,
                      )
                        .animate()
                        .rotate(begin: 0, end: -0.05, duration: 120.ms, curve: Curves.easeOut)
                        .then()
                        .rotate(begin: -0.05, end: 0, duration: 160.ms, curve: Curves.easeIn)
                        .animate()
                        .scaleXY(begin: 1, end: 1.35, duration: 120.ms, curve: Curves.easeOut)
                        .then()
                        .scaleXY(begin: 1.35, end: 1, duration: 160.ms, curve: Curves.easeIn),
              ),
              const SizedBox(width: 10),
              Text(widget.label, style: AppTextStyles.titleMedium.copyWith(color: AppColors.primaryDark)),
              const SizedBox(width: 10),
              Expanded(
                child: _DashedLine(key: ValueKey('right-$_snipCount'))
                    .animate()
                    .fadeIn(duration: 150.ms)
                    .slideX(begin: -0.4, end: 0, duration: 250.ms, curve: Curves.easeOut),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashedLine extends StatelessWidget {
  const _DashedLine({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const dashWidth = 5.0;
        const dashSpace = 4.0;
        final count = (constraints.maxWidth / (dashWidth + dashSpace)).floor();
        return Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            count.clamp(1, 200),
            (_) => const SizedBox(
              width: dashWidth,
              height: 2,
              child: DecoratedBox(decoration: BoxDecoration(color: AppColors.primaryDark)),
            ),
          ),
        );
      },
    );
  }
}
