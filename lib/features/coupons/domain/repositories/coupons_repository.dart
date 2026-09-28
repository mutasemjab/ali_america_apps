import '../../../../core/usecase/usecase.dart';
import '../entities/coupon_entity.dart';

abstract class CouponsRepository {
  ResultFuture<List<CouponEntity>> getCoupons();
  ResultFuture<CouponEntity> clipCoupon(int couponId);
}
