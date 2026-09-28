import '../../../../core/usecase/usecase.dart';
import '../entities/weekly_ad_entity.dart';
import '../repositories/weekly_ads_repository.dart';

class GetWeeklyAdsUseCase implements UseCase<List<WeeklyAdEntity>, NoParams> {
  final WeeklyAdsRepository repository;
  GetWeeklyAdsUseCase(this.repository);

  @override
  ResultFuture<List<WeeklyAdEntity>> call(NoParams params) => repository.getWeeklyAds();
}
