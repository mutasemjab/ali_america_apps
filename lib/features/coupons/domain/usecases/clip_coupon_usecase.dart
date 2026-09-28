import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/coupon_entity.dart';
import '../repositories/coupons_repository.dart';

class ClipCouponUseCase implements UseCase<CouponEntity, ClipCouponParams> {
  final CouponsRepository repository;
  ClipCouponUseCase(this.repository);

  @override
  ResultFuture<CouponEntity> call(ClipCouponParams params) => repository.clipCoupon(params.couponId);
}

class ClipCouponParams extends Equatable {
  final int couponId;
  const ClipCouponParams(this.couponId);

  @override
  List<Object?> get props => [couponId];
}
