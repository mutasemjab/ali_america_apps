import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../domain/entities/coupon_entity.dart';

class CouponCard extends StatelessWidget {
  final CouponEntity coupon;
  final VoidCallback onTap;

  const CouponCard({super.key, required this.coupon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: AppColors.secondary.withValues(alpha: 0.05),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        // IntrinsicHeight gives the Row a concrete height to stretch to —
        // without it, an unbounded-height parent (a ListView item) plus
        // CrossAxisAlignment.stretch asks children to be infinitely tall.
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Hero(
                tag: 'coupon-${coupon.id}',
                // Same background as the card itself: BoxFit.contain never
                // crops, and any letterboxing blends into the card instead
                // of reading as a gray gap around the image.
                child: Container(
                  width: 130,
                  color: AppColors.surface,
                  child: AppNetworkImage(url: coupon.photo, fit: BoxFit.contain),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        coupon.name,
                        style: AppTextStyles.titleLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Text('Regular  ', style: AppTextStyles.bodyMedium),
                          Flexible(
                            child: Text(
                              coupon.priceLabel,
                              style: AppTextStyles.priceStrike,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Coupon Price',
                        style: AppTextStyles.label.copyWith(color: AppColors.success),
                      ),
                      Text(coupon.priceAfterDiscountLabel, style: AppTextStyles.couponPrice),
                      const SizedBox(height: 8),
                      _SaveBadge(label: coupon.savePriceLabel),
                      const SizedBox(height: 6),
                      _ClipBadge(isClipped: coupon.isClipped),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SaveBadge extends StatelessWidget {
  final String label;
  const _SaveBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.warning,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'YOU SAVE $label',
        style: AppTextStyles.label.copyWith(color: AppColors.textPrimary, letterSpacing: 0.4),
      ),
    );
  }
}

class _ClipBadge extends StatelessWidget {
  final bool isClipped;
  const _ClipBadge({required this.isClipped});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isClipped ? AppColors.success.withValues(alpha: 0.12) : AppColors.primaryLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isClipped ? Icons.check_circle_rounded : Icons.content_cut_rounded,
            size: 14,
            color: isClipped ? AppColors.success : AppColors.primaryDark,
          ),
          const SizedBox(width: 4),
          Text(
            isClipped ? 'Clipped' : 'Clip',
            style: AppTextStyles.label.copyWith(
              color: isClipped ? AppColors.success : AppColors.primaryDark,
            ),
          ),
        ],
      ),
    );
  }
}
