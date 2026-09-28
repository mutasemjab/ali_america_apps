import '../../../../core/usecase/usecase.dart';
import '../../../auth/domain/entities/client.dart';
import '../repositories/profile_repository.dart';

class GetMeUseCase implements UseCase<Client, NoParams> {
  final ProfileRepository repository;
  GetMeUseCase(this.repository);

  @override
  ResultFuture<Client> call(NoParams params) => repository.getMe();
}
