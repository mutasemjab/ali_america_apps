import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/fcm_token_provider.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../auth/domain/usecases/logout_usecase.dart';
import '../../domain/usecases/delete_me_usecase.dart';
import '../../domain/usecases/get_me_usecase.dart';
import '../../domain/usecases/update_me_usecase.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetMeUseCase _getMeUseCase;
  final UpdateMeUseCase _updateMeUseCase;
  final DeleteMeUseCase _deleteMeUseCase;
  final LogoutUseCase _logoutUseCase;

  ProfileCubit(
    this._getMeUseCase,
    this._updateMeUseCase,
    this._deleteMeUseCase,
    this._logoutUseCase,
  ) : super(const ProfileState());

  Future<void> load() async {
    emit(state.copyWith(status: ProfileStatus.loading));
    final result = await _getMeUseCase(const NoParams());
    result.fold(
      (failure) => emit(state.copyWith(status: ProfileStatus.error, errorMessage: failure.message)),
      (client) => emit(state.copyWith(status: ProfileStatus.loaded, client: client)),
    );
  }

  Future<bool> save({required String name, String? email}) async {
    emit(state.copyWith(saving: true, actionError: null));
    final fcmToken = await FcmTokenProvider.current();
    final result = await _updateMeUseCase(
      UpdateMeParams(name: name, email: email, fcmToken: fcmToken),
    );
    var success = false;
    result.fold(
      (failure) => emit(state.copyWith(saving: false, actionError: failure.message)),
      (client) {
        success = true;
        emit(state.copyWith(saving: false, client: client, actionError: null));
      },
    );
    return success;
  }

  /// Returns null on success, an error message on failure.
  Future<String?> deleteAccount() async {
    emit(state.copyWith(deleting: true));
    final result = await _deleteMeUseCase(const NoParams());
    String? error;
    result.fold((failure) => error = failure.message, (_) {});
    emit(state.copyWith(deleting: false));
    return error;
  }

  Future<void> logout() async {
    emit(state.copyWith(loggingOut: true));
    await _logoutUseCase(const NoParams());
    emit(state.copyWith(loggingOut: false));
  }
}
