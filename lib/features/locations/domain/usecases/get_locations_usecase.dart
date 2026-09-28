import '../../../../core/usecase/usecase.dart';
import '../entities/location_entity.dart';
import '../repositories/locations_repository.dart';

class GetLocationsUseCase implements UseCase<List<LocationEntity>, NoParams> {
  final LocationsRepository repository;
  GetLocationsUseCase(this.repository);

  @override
  ResultFuture<List<LocationEntity>> call(NoParams params) => repository.getLocations();
}
