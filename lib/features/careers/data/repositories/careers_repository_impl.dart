import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/career_answer.dart';
import '../../domain/entities/career_entity.dart';
import '../../domain/repositories/careers_repository.dart';
import '../datasources/careers_remote_data_source.dart';

class CareersRepositoryImpl implements CareersRepository {
  final CareersRemoteDataSource _remote;
  final NetworkInfo _networkInfo;

  CareersRepositoryImpl(this._remote, this._networkInfo);

  Future<Either<Failure, T>> _guarded<T>(Future<T> Function() action) async {
    if (!await _networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      return Right(await action());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, errors: e.errors, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  ResultFuture<List<CareerEntity>> getCareers() => _guarded(() => _remote.getCareers());

  @override
  ResultFuture<void> applyToCareer({required int careerId, required Map<int, CareerAnswer> answers}) {
    return _guarded(() => _remote.applyToCareer(careerId: careerId, answers: answers));
  }
}
