import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/legal_document_entity.dart';
import '../../domain/repositories/legal_document_repository.dart';
import '../datasources/legal_document_remote_data_source.dart';

class LegalDocumentRepositoryImpl implements LegalDocumentRepository {
  final LegalDocumentRemoteDataSource _remote;
  final NetworkInfo _networkInfo;

  LegalDocumentRepositoryImpl(this._remote, this._networkInfo);

  @override
  ResultFuture<LegalDocumentEntity> getLegalDocument(String type) async {
    if (!await _networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      return Right(await _remote.getLegalDocument(type));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, errors: e.errors, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }
}
