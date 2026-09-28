import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {
  const LoginInitial();
}

class LoginLoading extends LoginState {
  const LoginLoading();
}

class LoginFailure extends LoginState {
  final String message;
  final bool notRegistered;
  const LoginFailure(this.message, {this.notRegistered = false});

  @override
  List<Object?> get props => [message, notRegistered];
}

class LoginSuccess extends LoginState {
  final String phone;
  const LoginSuccess(this.phone);

  @override
  List<Object?> get props => [phone];
}
