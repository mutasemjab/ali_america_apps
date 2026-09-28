import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase implements UseCase<void, LoginParams> {
  final AuthRepository repository;
  LoginUseCase(this.repository);

  @override
  ResultFuture<void> call(LoginParams params) {
    return repository.login(phone: params.phone);
  }
}

class LoginParams extends Equatable {
  final String phone;
  const LoginParams({required this.phone});

  @override
  List<Object?> get props => [phone];
}
