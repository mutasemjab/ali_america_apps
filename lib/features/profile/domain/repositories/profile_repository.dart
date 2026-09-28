import '../../../../core/usecase/usecase.dart';
import '../../../auth/domain/entities/client.dart';

abstract class ProfileRepository {
  ResultFuture<Client> getMe();
  ResultFuture<Client> updateMe({required String name, String? email, String? fcmToken});
  ResultFuture<void> deleteMe();
}
