import '../../domain/entities/product_page_entity.dart';
import 'product_model.dart';

class ProductPageModel extends ProductPageEntity {
  const ProductPageModel({
    required super.products,
    required super.currentPage,
    required super.lastPage,
  });

  factory ProductPageModel.fromJson(List<dynamic> data, Map<String, dynamic> pagination) {
    return ProductPageModel(
      products: data.map((e) => ProductModel.fromJson(e as Map<String, dynamic>)).toList(),
      currentPage: (pagination['current_page'] as num?)?.toInt() ?? 1,
      lastPage: (pagination['last_page'] as num?)?.toInt() ?? 1,
    );
  }
}
