import 'package:equatable/equatable.dart';

import '../../domain/entities/coupon_entity.dart';

enum CouponsStatus { loading, loaded, error }

class CouponsState extends Equatable {
  final CouponsStatus status;
  final List<CouponEntity> coupons;
  final Set<int> clippingIds;
  final String? errorMessage;

  const CouponsState({
    this.status = CouponsStatus.loading,
    this.coupons = const [],
    this.clippingIds = const {},
    this.errorMessage,
  });

  CouponsState copyWith({
    CouponsStatus? status,
    List<CouponEntity>? coupons,
    Set<int>? clippingIds,
    String? errorMessage,
  }) {
    return CouponsState(
      status: status ?? this.status,
      coupons: coupons ?? this.coupons,
      clippingIds: clippingIds ?? this.clippingIds,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, coupons, clippingIds, errorMessage];
}
