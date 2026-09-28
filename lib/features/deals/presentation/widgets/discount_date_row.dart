import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/product_entity.dart';

final _discountDateFormat = DateFormat.MMMd();

String? discountRangeLabel(ProductEntity product) {
  if (!product.hasActiveDiscount) return null;
  final from = product.discountFrom;
  final to = product.discountTo;
  if (from == null && to == null) return null;
  if (from != null && to != null) {
    return '${_discountDateFormat.format(from)} - ${_discountDateFormat.format(to)}';
  }
  return _discountDateFormat.format(from ?? to!);
}

/// The sale window ("Aug 21 - Aug 30") shown in red under the price on any
/// discounted product — grid card or list tile.
class DiscountDateRow extends StatelessWidget {
  final ProductEntity product;

  const DiscountDateRow({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final label = discountRangeLabel(product);
    if (label == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.local_fire_department_rounded, size: 13, color: AppColors.error),
          const SizedBox(width: 3),
          Flexible(
            child: Text(
              label,
              style: AppTextStyles.label.copyWith(color: AppColors.error),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
