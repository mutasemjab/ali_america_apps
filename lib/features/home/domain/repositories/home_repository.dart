import '../../../../core/usecase/usecase.dart';
import '../entities/home_entity.dart';

abstract class HomeRepository {
  ResultFuture<HomeEntity> getHome();
}
