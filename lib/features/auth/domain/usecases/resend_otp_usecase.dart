import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

class ResendOtpUseCase implements UseCase<void, ResendOtpParams> {
  final AuthRepository repository;
  ResendOtpUseCase(this.repository);

  @override
  ResultFuture<void> call(ResendOtpParams params) {
    return repository.resendOtp(phone: params.phone);
  }
}

class ResendOtpParams extends Equatable {
  final String phone;
  const ResendOtpParams({required this.phone});

  @override
  List<Object?> get props => [phone];
}
