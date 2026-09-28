import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/session/auth_session.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remote;
  final NetworkInfo _networkInfo;
  final AuthSession _authSession;

  AuthRepositoryImpl(this._remote, this._networkInfo, this._authSession);

  Future<Either<Failure, T>> _guarded<T>(Future<T> Function() action) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
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
  ResultFuture<void> register({
    required String name,
    required String phone,
    String? email,
    String? fcmToken,
  }) {
    return _guarded(
      () => _remote.register(name: name, phone: phone, email: email, fcmToken: fcmToken),
    );
  }

  @override
  ResultFuture<void> login({required String phone}) {
    return _guarded(() => _remote.login(phone: phone));
  }

  @override
  ResultFuture<void> resendOtp({required String phone}) {
    return _guarded(() => _remote.resendOtp(phone: phone));
  }

  @override
  ResultFuture<void> verifyOtp({required String phone, required String code, String? fcmToken}) {
    return _guarded(() async {
      final result = await _remote.verifyOtp(phone: phone, code: code, fcmToken: fcmToken);
      await _authSession.setToken(result.token);
    });
  }

  @override
  ResultFuture<void> logout() async {
    // Always clear the local session — a signed-out device shouldn't stay
    // "stuck" logged in just because the revoke call couldn't reach the
    // server (offline, expired token, etc).
    try {
      if (await _networkInfo.isConnected) {
        await _remote.logout();
      }
    } catch (_) {
      // ignore — local session is cleared below regardless.
    } finally {
      await _authSession.clear();
    }
    return const Right(null);
  }
}
