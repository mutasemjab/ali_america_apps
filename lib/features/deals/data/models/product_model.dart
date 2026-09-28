import '../../../../core/utils/parsing.dart';
import '../../domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.name,
    super.image,
    required super.category,
    required super.categoryId,
    required super.priceUsd,
    super.priceAfter,
    required super.hasActiveDiscount,
    required super.finalPrice,
    super.discountFrom,
    super.discountTo,
    required super.priceUsdLabel,
    required super.finalPriceLabel,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    double? toDouble(dynamic v) => v == null ? null : parseFlexibleDouble(v);

    DateTime? toDate(dynamic v) => v == null ? null : DateTime.tryParse(v.toString());

    return ProductModel(
      id: json['id'] as int,
      name: json['name']?.toString() ?? '',
      image: json['image']?.toString().trim(),
      category: json['category']?.toString() ?? '',
      categoryId: (json['category_id'] as num?)?.toInt() ?? 0,
      priceUsd: toDouble(json['price_usd']) ?? 0,
      priceAfter: toDouble(json['price_after']),
      hasActiveDiscount: json['has_active_discount'] == true,
      finalPrice: toDouble(json['final_price']) ?? toDouble(json['price_usd']) ?? 0,
      discountFrom: toDate(json['discount_from']),
      discountTo: toDate(json['discount_to']),
      priceUsdLabel: formatPriceLabel(json['price_usd']),
      finalPriceLabel: formatPriceLabel(json['final_price'] ?? json['price_usd']),
    );
  }
}
