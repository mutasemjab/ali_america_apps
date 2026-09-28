import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/reward_redemption_entity.dart';
import '../../domain/entities/rewards_summary_entity.dart';
import '../../domain/repositories/rewards_repository.dart';
import '../datasources/rewards_remote_data_source.dart';

class RewardsRepositoryImpl implements RewardsRepository {
  final RewardsRemoteDataSource _remote;
  final NetworkInfo _networkInfo;

  RewardsRepositoryImpl(this._remote, this._networkInfo);

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
  ResultFuture<RewardsSummaryEntity> getRewards() => _guarded(() => _remote.getRewards());

  @override
  ResultFuture<RewardRedemptionEntity> redeemReward(int rewardId) {
    return _guarded(() => _remote.redeemReward(rewardId));
  }
}
