import 'package:equatable/equatable.dart';

enum OtpFlow { register, login }

abstract class OtpEvent extends Equatable {
  const OtpEvent();

  @override
  List<Object?> get props => [];
}

class OtpStarted extends OtpEvent {
  final String phone;
  final OtpFlow flow;
  const OtpStarted({required this.phone, required this.flow});

  @override
  List<Object?> get props => [phone, flow];
}

class OtpCodeChanged extends OtpEvent {
  final String code;
  const OtpCodeChanged(this.code);

  @override
  List<Object?> get props => [code];
}

class OtpSubmitted extends OtpEvent {
  const OtpSubmitted();
}

class OtpResendRequested extends OtpEvent {
  const OtpResendRequested();
}

class OtpCountdownTicked extends OtpEvent {
  final int secondsRemaining;
  const OtpCountdownTicked(this.secondsRemaining);

  @override
  List<Object?> get props => [secondsRemaining];
}
