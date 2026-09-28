import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/usecases/get_locations_usecase.dart';
import 'locations_state.dart';

class LocationsCubit extends Cubit<LocationsState> {
  final GetLocationsUseCase _getLocationsUseCase;

  LocationsCubit(this._getLocationsUseCase) : super(const LocationsState());

  Future<void> load() async {
    emit(const LocationsState(status: LocationsStatus.loading));
    final result = await _getLocationsUseCase(const NoParams());
    result.fold(
      (failure) => emit(LocationsState(status: LocationsStatus.error, errorMessage: failure.message)),
      (locations) => emit(LocationsState(status: LocationsStatus.loaded, locations: locations)),
    );
  }
}
