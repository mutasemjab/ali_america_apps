import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final int id;
  final String name;
  final String? image;
  final String category;
  final int categoryId;
  final double priceUsd;
  final double? priceAfter;
  final bool hasActiveDiscount;
  final double finalPrice;
  final DateTime? discountFrom;
  final DateTime? discountTo;

  /// Ready-to-show price text. Usually "$X.XX", but can be a promotional
  /// string straight from the backend ("2/95¢", "89¢ea") that isn't a
  /// single number — always prefer these over formatting the raw doubles
  /// above yourself.
  final String priceUsdLabel;
  final String finalPriceLabel;

  const ProductEntity({
    required this.id,
    required this.name,
    this.image,
    required this.category,
    required this.categoryId,
    required this.priceUsd,
    this.priceAfter,
    required this.hasActiveDiscount,
    required this.finalPrice,
    this.discountFrom,
    this.discountTo,
    required this.priceUsdLabel,
    required this.finalPriceLabel,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        image,
        category,
        categoryId,
        priceUsd,
        priceAfter,
        hasActiveDiscount,
        finalPrice,
        discountFrom,
        discountTo,
        priceUsdLabel,
        finalPriceLabel,
      ];
}
