import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../auth/domain/entities/client.dart';
import '../repositories/profile_repository.dart';

class UpdateMeUseCase implements UseCase<Client, UpdateMeParams> {
  final ProfileRepository repository;
  UpdateMeUseCase(this.repository);

  @override
  ResultFuture<Client> call(UpdateMeParams params) {
    return repository.updateMe(name: params.name, email: params.email, fcmToken: params.fcmToken);
  }
}

class UpdateMeParams extends Equatable {
  final String name;
  final String? email;
  final String? fcmToken;
  const UpdateMeParams({required this.name, this.email, this.fcmToken});

  @override
  List<Object?> get props => [name, email, fcmToken];
}
