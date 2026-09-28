import 'package:equatable/equatable.dart';

import 'otp_event.dart';

enum OtpStatus { idle, submitting, resending, verified, error }

class OtpState extends Equatable {
  final String phone;
  final OtpFlow flow;
  final String code;
  final OtpStatus status;
  final String? errorMessage;
  final int cooldownSeconds;
  final bool shake;

  const OtpState({
    this.phone = '',
    this.flow = OtpFlow.login,
    this.code = '',
    this.status = OtpStatus.idle,
    this.errorMessage,
    this.cooldownSeconds = 60,
    this.shake = false,
  });

  bool get canResend => cooldownSeconds <= 0;

  OtpState copyWith({
    String? phone,
    OtpFlow? flow,
    String? code,
    OtpStatus? status,
    String? errorMessage,
    bool clearError = false,
    int? cooldownSeconds,
    bool? shake,
  }) {
    return OtpState(
      phone: phone ?? this.phone,
      flow: flow ?? this.flow,
      code: code ?? this.code,
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      cooldownSeconds: cooldownSeconds ?? this.cooldownSeconds,
      shake: shake ?? false,
    );
  }

  @override
  List<Object?> get props => [phone, flow, code, status, errorMessage, cooldownSeconds, shake];
}
