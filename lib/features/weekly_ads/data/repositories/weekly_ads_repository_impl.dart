import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/weekly_ad_entity.dart';
import '../../domain/repositories/weekly_ads_repository.dart';
import '../datasources/weekly_ads_remote_data_source.dart';

class WeeklyAdsRepositoryImpl implements WeeklyAdsRepository {
  final WeeklyAdsRemoteDataSource _remote;
  final NetworkInfo _networkInfo;

  WeeklyAdsRepositoryImpl(this._remote, this._networkInfo);

  @override
  ResultFuture<List<WeeklyAdEntity>> getWeeklyAds() async {
    if (!await _networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      return Right(await _remote.getWeeklyAds());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, errors: e.errors, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }
}
