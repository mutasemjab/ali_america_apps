import 'package:equatable/equatable.dart';

class CouponEntity extends Equatable {
  final int id;
  final String name;
  final String? description;
  final String? terms;
  final String? photo;
  final double price;
  final double priceAfterDiscount;
  final double savePrice;
  final DateTime? startAt;
  final DateTime? endAt;

  /// Minutes remaining on this coupon's redemption window, computed
  /// server-side as of the moment this response was sent — the source of
  /// truth for the countdown. Deliberately not derived from comparing
  /// `clipped_at`/`expires_at` against the device clock: those timestamps
  /// carry no timezone marker, so a server/device timezone mismatch would
  /// throw the countdown off by hours. This is a plain number, so there's
  /// nothing to get wrong.
  final int? timeWhenClipped;
  final String? barcode;
  final bool isClipped;
  final DateTime? clippedAt;
  final DateTime? expiresAt;

  /// Ready-to-show price text. Usually "$X.XX", but can be a promotional
  /// string straight from the backend ("2/95¢", "89¢ea") that isn't a
  /// single number — always prefer these over formatting the raw doubles
  /// above yourself.
  final String priceLabel;
  final String priceAfterDiscountLabel;
  final String savePriceLabel;

  const CouponEntity({
    required this.id,
    required this.name,
    this.description,
    this.terms,
    this.photo,
    required this.price,
    required this.priceAfterDiscount,
    required this.savePrice,
    this.startAt,
    this.endAt,
    this.timeWhenClipped,
    this.barcode,
    required this.isClipped,
    this.clippedAt,
    this.expiresAt,
    required this.priceLabel,
    required this.priceAfterDiscountLabel,
    required this.savePriceLabel,
  });

  CouponEntity copyWith({bool? isClipped, DateTime? clippedAt, DateTime? expiresAt}) {
    return CouponEntity(
      id: id,
      name: name,
      description: description,
      terms: terms,
      photo: photo,
      price: price,
      priceAfterDiscount: priceAfterDiscount,
      savePrice: savePrice,
      startAt: startAt,
      endAt: endAt,
      timeWhenClipped: timeWhenClipped,
      barcode: barcode,
      isClipped: isClipped ?? this.isClipped,
      clippedAt: clippedAt ?? this.clippedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      priceLabel: priceLabel,
      priceAfterDiscountLabel: priceAfterDiscountLabel,
      savePriceLabel: savePriceLabel,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        terms,
        photo,
        price,
        priceAfterDiscount,
        savePrice,
        startAt,
        endAt,
        timeWhenClipped,
        barcode,
        isClipped,
        clippedAt,
        expiresAt,
        priceLabel,
        priceAfterDiscountLabel,
        savePriceLabel,
      ];
}
