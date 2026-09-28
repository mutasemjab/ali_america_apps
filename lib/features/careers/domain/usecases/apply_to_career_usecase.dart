import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/career_answer.dart';
import '../repositories/careers_repository.dart';

class ApplyToCareerUseCase implements UseCase<void, ApplyToCareerParams> {
  final CareersRepository repository;
  ApplyToCareerUseCase(this.repository);

  @override
  ResultFuture<void> call(ApplyToCareerParams params) {
    return repository.applyToCareer(careerId: params.careerId, answers: params.answers);
  }
}

class ApplyToCareerParams extends Equatable {
  final int careerId;
  final Map<int, CareerAnswer> answers;

  const ApplyToCareerParams({required this.careerId, required this.answers});

  @override
  List<Object?> get props => [careerId, answers];
}
