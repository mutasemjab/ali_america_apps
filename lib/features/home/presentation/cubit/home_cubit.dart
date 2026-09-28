import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/usecases/get_home_usecase.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetHomeUseCase _getHomeUseCase;

  HomeCubit(this._getHomeUseCase) : super(const HomeLoading());

  Future<void> load() async {
    emit(const HomeLoading());
    final result = await _getHomeUseCase(const NoParams());
    result.fold(
      (failure) => emit(HomeError(failure.message)),
      (home) => emit(HomeLoaded(home)),
    );
  }
}
