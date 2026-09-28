import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/social_entity.dart';
import '../../domain/repositories/socials_repository.dart';
import '../datasources/socials_remote_data_source.dart';

class SocialsRepositoryImpl implements SocialsRepository {
  final SocialsRemoteDataSource _remote;
  final NetworkInfo _networkInfo;

  SocialsRepositoryImpl(this._remote, this._networkInfo);

  @override
  ResultFuture<List<SocialEntity>> getSocials() async {
    if (!await _networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      return Right(await _remote.getSocials());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, errors: e.errors, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }
}
