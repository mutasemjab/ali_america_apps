import '../../../../core/usecase/usecase.dart';
import '../entities/career_answer.dart';
import '../entities/career_entity.dart';

abstract class CareersRepository {
  ResultFuture<List<CareerEntity>> getCareers();

  ResultFuture<void> applyToCareer({
    required int careerId,
    required Map<int, CareerAnswer> answers,
  });
}
