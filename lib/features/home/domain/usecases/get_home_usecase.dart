import '../../../../core/usecase/usecase.dart';
import '../entities/home_entity.dart';
import '../repositories/home_repository.dart';

class GetHomeUseCase implements UseCase<HomeEntity, NoParams> {
  final HomeRepository repository;
  GetHomeUseCase(this.repository);

  @override
  ResultFuture<HomeEntity> call(NoParams params) => repository.getHome();
}
