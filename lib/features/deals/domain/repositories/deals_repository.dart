import '../../../../core/usecase/usecase.dart';
import '../entities/category_entity.dart';
import '../entities/product_page_entity.dart';

abstract class DealsRepository {
  ResultFuture<List<CategoryEntity>> getCategories();

  ResultFuture<ProductPageEntity> getProducts({int? categoryId, String? search, int page = 1});
}
