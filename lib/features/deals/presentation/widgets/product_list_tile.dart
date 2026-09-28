import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../domain/entities/product_entity.dart';
import 'discount_date_row.dart';

/// Horizontal row layout for list view — same information as [ProductCard],
/// just laid out for a denser, scannable list.
class ProductListTile extends StatelessWidget {
  final ProductEntity product;

  const ProductListTile({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      // IntrinsicHeight gives the Row a concrete height to stretch to —
      // without it, an unbounded-height parent (e.g. a ListView item) plus
      // CrossAxisAlignment.stretch asks children to be infinitely tall.
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                Container(
                  width: 180,
                  height: 220,
                  color: Colors.white,
                  child: AppNetworkImage(
                    width: 180,
                    height: 220,
                    url: product.image,
                    fit: BoxFit.contain,
                  ),
                ),
                if (product.hasActiveDiscount)
                  Positioned(
                    top: 6,
                    left: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'SALE',
                        style: AppTextStyles.label.copyWith(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      product.name,
                      style: AppTextStyles.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      product.category,
                      style: AppTextStyles.bodyMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(product.finalPriceLabel, style: AppTextStyles.price),
                        if (product.hasActiveDiscount) ...[
                          const SizedBox(width: 6),
                          Text(
                            product.priceUsdLabel,
                            style: AppTextStyles.priceStrike,
                          ),
                        ],
                      ],
                    ),
                    DiscountDateRow(product: product),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}