import 'package:equatable/equatable.dart';

import '../../domain/entities/location_entity.dart';

enum LocationsStatus { loading, loaded, error }

class LocationsState extends Equatable {
  final LocationsStatus status;
  final List<LocationEntity> locations;
  final String? errorMessage;

  const LocationsState({
    this.status = LocationsStatus.loading,
    this.locations = const [],
    this.errorMessage,
  });

  @override
  List<Object?> get props => [status, locations, errorMessage];
}
