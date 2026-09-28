import 'package:equatable/equatable.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object?> get props => [];
}

class RegisterInitial extends RegisterState {
  const RegisterInitial();
}

class RegisterLoading extends RegisterState {
  const RegisterLoading();
}

class RegisterFailure extends RegisterState {
  final String message;
  const RegisterFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class RegisterSuccess extends RegisterState {
  final String phone;
  const RegisterSuccess(this.phone);

  @override
  List<Object?> get props => [phone];
}
