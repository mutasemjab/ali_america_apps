import '../../../../core/usecase/usecase.dart';
import '../entities/weekly_ad_entity.dart';

abstract class WeeklyAdsRepository {
  ResultFuture<List<WeeklyAdEntity>> getWeeklyAds();
}
