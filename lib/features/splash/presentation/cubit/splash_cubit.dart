import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/session/auth_session.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../home/domain/usecases/get_home_usecase.dart';
import '../../../profile/domain/usecases/get_me_usecase.dart';
import 'splash_state.dart';

/// Warms the store logo/banner cache and decides, in the background,
/// whether the device has a still-valid session — the splash screen just
/// renders whatever this emits.
class SplashCubit extends Cubit<SplashState> {
  final GetHomeUseCase _getHomeUseCase;
  final GetMeUseCase _getMeUseCase;
  final AuthSession _authSession;

  SplashCubit(this._getHomeUseCase, this._getMeUseCase, this._authSession) : super(const SplashState());

  Future<void> start() async {
    final homeResult = await _getHomeUseCase(const NoParams());
    homeResult.fold((_) {}, (home) => emit(state.copyWith(store: home.store)));

    String destination = '/welcome';
    if (_authSession.isAuthenticated) {
      final meResult = await _getMeUseCase(const NoParams());
      destination = meResult.fold((_) => '/welcome', (_) => '/home');
    }

    emit(state.copyWith(destination: destination));
  }
}
