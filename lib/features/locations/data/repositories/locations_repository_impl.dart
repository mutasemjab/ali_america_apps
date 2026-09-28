import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/location_entity.dart';
import '../../domain/repositories/locations_repository.dart';
import '../datasources/locations_remote_data_source.dart';

class LocationsRepositoryImpl implements LocationsRepository {
  final LocationsRemoteDataSource _remote;
  final NetworkInfo _networkInfo;

  LocationsRepositoryImpl(this._remote, this._networkInfo);

  @override
  ResultFuture<List<LocationEntity>> getLocations() async {
    if (!await _networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      return Right(await _remote.getLocations());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, errors: e.errors, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }
}
