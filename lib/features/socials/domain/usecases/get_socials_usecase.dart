import '../../../../core/usecase/usecase.dart';
import '../entities/social_entity.dart';
import '../repositories/socials_repository.dart';

class GetSocialsUseCase implements UseCase<List<SocialEntity>, NoParams> {
  final SocialsRepository repository;
  GetSocialsUseCase(this.repository);

  @override
  ResultFuture<List<SocialEntity>> call(NoParams params) => repository.getSocials();
}
