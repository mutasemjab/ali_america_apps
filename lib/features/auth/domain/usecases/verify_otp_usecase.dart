import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

class VerifyOtpUseCase implements UseCase<void, VerifyOtpParams> {
  final AuthRepository repository;
  VerifyOtpUseCase(this.repository);

  @override
  ResultFuture<void> call(VerifyOtpParams params) {
    return repository.verifyOtp(phone: params.phone, code: params.code, fcmToken: params.fcmToken);
  }
}

class VerifyOtpParams extends Equatable {
  final String phone;
  final String code;
  final String? fcmToken;

  const VerifyOtpParams({required this.phone, required this.code, this.fcmToken});

  @override
  List<Object?> get props => [phone, code, fcmToken];
}
