import '../../../../core/usecase/usecase.dart';
import '../entities/social_entity.dart';

abstract class SocialsRepository {
  ResultFuture<List<SocialEntity>> getSocials();
}
