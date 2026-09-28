import '../../../../core/usecase/usecase.dart';
import '../entities/category_entity.dart';
import '../repositories/deals_repository.dart';

class GetCategoriesUseCase implements UseCase<List<CategoryEntity>, NoParams> {
  final DealsRepository repository;
  GetCategoriesUseCase(this.repository);

  @override
  ResultFuture<List<CategoryEntity>> call(NoParams params) => repository.getCategories();
}
