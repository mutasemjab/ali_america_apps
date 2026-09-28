import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/product_page_entity.dart';
import '../../domain/repositories/deals_repository.dart';
import '../datasources/deals_remote_data_source.dart';

class DealsRepositoryImpl implements DealsRepository {
  final DealsRemoteDataSource _remote;
  final NetworkInfo _networkInfo;

  DealsRepositoryImpl(this._remote, this._networkInfo);

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
  ResultFuture<List<CategoryEntity>> getCategories() {
    return _guarded(() => _remote.getCategories());
  }

  @override
  ResultFuture<ProductPageEntity> getProducts({int? categoryId, String? search, int page = 1}) {
    return _guarded(() => _remote.getProducts(categoryId: categoryId, search: search, page: page));
  }
}
