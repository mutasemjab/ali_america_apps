import '../../../../core/utils/parsing.dart';
import '../../domain/entities/coupon_entity.dart';

class CouponModel extends CouponEntity {
  const CouponModel({
    required super.id,
    required super.name,
    super.description,
    super.terms,
    super.photo,
    required super.price,
    required super.priceAfterDiscount,
    required super.savePrice,
    super.startAt,
    super.endAt,
    super.timeWhenClipped,
    super.barcode,
    required super.isClipped,
    super.clippedAt,
    super.expiresAt,
    required super.priceLabel,
    required super.priceAfterDiscountLabel,
    required super.savePriceLabel,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    DateTime? toDate(dynamic v) => v == null ? null : DateTime.tryParse(v.toString());
    int? toMinutes(dynamic v) {
      if (v == null) return null;
      if (v is num) return v.toInt();
      return int.tryParse(v.toString());
    }

    return CouponModel(
      id: json['id'] as int,
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString(),
      terms: json['terms']?.toString(),
      photo: json['photo']?.toString(),
      price: parseFlexibleDouble(json['price']),
      priceAfterDiscount: parseFlexibleDouble(json['price_after_discount']),
      savePrice: parseFlexibleDouble(json['save_price']),
      startAt: toDate(json['start_at']),
      endAt: toDate(json['end_at']),
      timeWhenClipped: toMinutes(json['time_when_clipped']),
      barcode: json['barcode']?.toString(),
      isClipped: json['is_clipped'] == true,
      clippedAt: toDate(json['clipped_at']),
      expiresAt: toDate(json['expires_at']),
      priceLabel: formatPriceLabel(json['price']),
      priceAfterDiscountLabel: formatPriceLabel(json['price_after_discount']),
      savePriceLabel: formatPriceLabel(json['save_price']),
    );
  }
}
