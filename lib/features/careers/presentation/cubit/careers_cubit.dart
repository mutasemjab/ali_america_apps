import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/applied_careers_store.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/usecases/get_careers_usecase.dart';
import 'careers_state.dart';

class CareersCubit extends Cubit<CareersState> {
  final GetCareersUseCase _getCareersUseCase;
  final AppliedCareersStore _appliedCareersStore;

  CareersCubit(this._getCareersUseCase, this._appliedCareersStore) : super(const CareersState());

  Future<void> load() async {
    emit(state.copyWith(status: CareersStatus.loading));
    final result = await _getCareersUseCase(const NoParams());
    result.fold(
      (failure) => emit(state.copyWith(status: CareersStatus.error, errorMessage: failure.message)),
      (careers) => emit(state.copyWith(
        status: CareersStatus.loaded,
        careers: careers,
        appliedIds: _appliedCareersStore.getAppliedIds(),
      )),
    );
  }

  /// Called when the apply screen comes back having recorded a new
  /// applied career (a fresh success, or a "you already applied" 422) —
  /// refreshes just the applied set without re-fetching the whole list.
  void refreshAppliedIds() {
    emit(state.copyWith(appliedIds: _appliedCareersStore.getAppliedIds()));
  }
}
