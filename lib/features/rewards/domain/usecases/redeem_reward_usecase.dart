import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/reward_redemption_entity.dart';
import '../repositories/rewards_repository.dart';

class RedeemRewardUseCase implements UseCase<RewardRedemptionEntity, RedeemRewardParams> {
  final RewardsRepository repository;
  RedeemRewardUseCase(this.repository);

  @override
  ResultFuture<RewardRedemptionEntity> call(RedeemRewardParams params) {
    return repository.redeemReward(params.rewardId);
  }
}

class RedeemRewardParams extends Equatable {
  final int rewardId;
  const RedeemRewardParams(this.rewardId);

  @override
  List<Object?> get props => [rewardId];
}
