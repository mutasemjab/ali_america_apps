import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/session/auth_session.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../auth/domain/entities/client.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remote;
  final NetworkInfo _networkInfo;
  final AuthSession _authSession;

  ProfileRepositoryImpl(this._remote, this._networkInfo, this._authSession);

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
  ResultFuture<Client> getMe() => _guarded(() => _remote.getMe());

  @override
  ResultFuture<Client> updateMe({required String name, String? email, String? fcmToken}) {
    return _guarded(() => _remote.updateMe(name: name, email: email, fcmToken: fcmToken));
  }

  @override
  ResultFuture<void> deleteMe() {
    return _guarded(() async {
      await _remote.deleteMe();
      await _authSession.clear();
    });
  }
}
