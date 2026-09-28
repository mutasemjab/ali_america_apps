import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase implements UseCase<void, RegisterParams> {
  final AuthRepository repository;
  RegisterUseCase(this.repository);

  @override
  ResultFuture<void> call(RegisterParams params) {
    return repository.register(
      name: params.name,
      phone: params.phone,
      email: params.email,
      fcmToken: params.fcmToken,
    );
  }
}

class RegisterParams extends Equatable {
  final String name;
  final String phone;
  final String? email;
  final String? fcmToken;

  const RegisterParams({required this.name, required this.phone, this.email, this.fcmToken});

  @override
  List<Object?> get props => [name, phone, email, fcmToken];
}
