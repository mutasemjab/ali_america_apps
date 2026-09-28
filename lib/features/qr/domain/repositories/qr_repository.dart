import '../../../../core/usecase/usecase.dart';
import '../entities/qr_entity.dart';

abstract class QrRepository {
  ResultFuture<List<QrEntity>> getQrs();
}
