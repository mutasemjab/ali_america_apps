import '../../../../core/usecase/usecase.dart';
import '../entities/qr_entity.dart';
import '../repositories/qr_repository.dart';

class GetQrsUseCase implements UseCase<List<QrEntity>, NoParams> {
  final QrRepository repository;
  GetQrsUseCase(this.repository);

  @override
  ResultFuture<List<QrEntity>> call(NoParams params) => repository.getQrs();
}
