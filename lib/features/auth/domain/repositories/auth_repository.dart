import '../../../../core/usecase/usecase.dart';

abstract class AuthRepository {
  ResultFuture<void> register({
    required String name,
    required String phone,
    String? email,
    String? fcmToken,
  });

  ResultFuture<void> login({required String phone});

  ResultFuture<void> resendOtp({required String phone});

  /// On success, stores the returned token in the secure session and
  /// resolves — callers don't need to touch the token themselves.
  ResultFuture<void> verifyOtp({required String phone, required String code, String? fcmToken});

  ResultFuture<void> logout();
}
