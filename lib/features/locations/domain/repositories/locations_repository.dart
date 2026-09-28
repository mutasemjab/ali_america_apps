import '../../../../core/usecase/usecase.dart';
import '../entities/location_entity.dart';

abstract class LocationsRepository {
  ResultFuture<List<LocationEntity>> getLocations();
}
