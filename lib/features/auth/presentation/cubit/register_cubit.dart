import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/fcm_token_provider.dart';
import '../../domain/usecases/register_usecase.dart';
import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterUseCase _registerUseCase;

  RegisterCubit(this._registerUseCase) : super(const RegisterInitial());

  Future<void> submit({required String name, required String phone, String? email}) async {
    emit(const RegisterLoading());
    final fcmToken = await FcmTokenProvider.current();
    final result = await _registerUseCase(
      RegisterParams(name: name, phone: phone, email: email, fcmToken: fcmToken),
    );
    result.fold(
      (failure) => emit(RegisterFailure(failure.message)),
      (_) => emit(RegisterSuccess(phone)),
    );
  }

  void reset() => emit(const RegisterInitial());
}
