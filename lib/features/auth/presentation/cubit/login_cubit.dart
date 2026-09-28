import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/usecases/login_usecase.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase _loginUseCase;

  LoginCubit(this._loginUseCase) : super(const LoginInitial());

  Future<void> submit({required String phone}) async {
    emit(const LoginLoading());
    final result = await _loginUseCase(LoginParams(phone: phone));
    result.fold((failure) {
      final notRegistered = failure is ServerFailure && failure.statusCode == 404;
      emit(LoginFailure(failure.message, notRegistered: notRegistered));
    }, (_) => emit(LoginSuccess(phone)));
  }

  void reset() => emit(const LoginInitial());
}
