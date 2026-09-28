import '../../../../core/usecase/usecase.dart';
import '../entities/coupon_entity.dart';
import '../repositories/coupons_repository.dart';

class GetCouponsUseCase implements UseCase<List<CouponEntity>, NoParams> {
  final CouponsRepository repository;
  GetCouponsUseCase(this.repository);

  @override
  ResultFuture<List<CouponEntity>> call(NoParams params) => repository.getCoupons();
}
