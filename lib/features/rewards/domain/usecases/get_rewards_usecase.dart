import '../../../../core/usecase/usecase.dart';
import '../entities/rewards_summary_entity.dart';
import '../repositories/rewards_repository.dart';

class GetRewardsUseCase implements UseCase<RewardsSummaryEntity, NoParams> {
  final RewardsRepository repository;
  GetRewardsUseCase(this.repository);

  @override
  ResultFuture<RewardsSummaryEntity> call(NoParams params) => repository.getRewards();
}
