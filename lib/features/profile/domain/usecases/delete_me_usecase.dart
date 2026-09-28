import '../../../../core/usecase/usecase.dart';
import '../repositories/profile_repository.dart';

class DeleteMeUseCase implements UseCase<void, NoParams> {
  final ProfileRepository repository;
  DeleteMeUseCase(this.repository);

  @override
  ResultFuture<void> call(NoParams params) => repository.deleteMe();
}
