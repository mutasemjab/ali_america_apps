import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/coupon_entity.dart';
import '../../domain/repositories/coupons_repository.dart';
import '../datasources/coupons_remote_data_source.dart';

class CouponsRepositoryImpl implements CouponsRepository {
  final CouponsRemoteDataSource _remote;
  final NetworkInfo _networkInfo;

  CouponsRepositoryImpl(this._remote, this._networkInfo);

  Future<Either<Failure, T>> _guarded<T>(Future<T> Function() action) async {
    if (!await _networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      return Right(await action());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, errors: e.errors, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  ResultFuture<List<CouponEntity>> getCoupons() => _guarded(() => _remote.getCoupons());

  @override
  ResultFuture<CouponEntity> clipCoupon(int couponId) => _guarded(() => _remote.clipCoupon(couponId));
}
