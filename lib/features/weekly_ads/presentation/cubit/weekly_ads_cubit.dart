import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/usecases/get_weekly_ads_usecase.dart';
import 'weekly_ads_state.dart';

class WeeklyAdsCubit extends Cubit<WeeklyAdsState> {
  final GetWeeklyAdsUseCase _getWeeklyAdsUseCase;

  WeeklyAdsCubit(this._getWeeklyAdsUseCase) : super(const WeeklyAdsState());

  Future<void> load() async {
    emit(const WeeklyAdsState(status: WeeklyAdsStatus.loading));
    final result = await _getWeeklyAdsUseCase(const NoParams());
    result.fold(
      (failure) => emit(WeeklyAdsState(status: WeeklyAdsStatus.error, errorMessage: failure.message)),
      (ads) => emit(WeeklyAdsState(status: WeeklyAdsStatus.loaded, ads: ads)),
    );
  }
}
