import '../../../../core/usecase/usecase.dart';
import '../entities/reward_redemption_entity.dart';
import '../entities/rewards_summary_entity.dart';

abstract class RewardsRepository {
  ResultFuture<RewardsSummaryEntity> getRewards();

  ResultFuture<RewardRedemptionEntity> redeemReward(int rewardId);
}
