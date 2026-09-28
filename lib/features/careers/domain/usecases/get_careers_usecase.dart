import '../../../../core/usecase/usecase.dart';
import '../entities/career_entity.dart';
import '../repositories/careers_repository.dart';

class GetCareersUseCase implements UseCase<List<CareerEntity>, NoParams> {
  final CareersRepository repository;
  GetCareersUseCase(this.repository);

  @override
  ResultFuture<List<CareerEntity>> call(NoParams params) => repository.getCareers();
}
