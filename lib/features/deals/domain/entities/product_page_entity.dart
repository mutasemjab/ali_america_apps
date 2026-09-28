import 'package:equatable/equatable.dart';

import 'product_entity.dart';

class ProductPageEntity extends Equatable {
  final List<ProductEntity> products;
  final int currentPage;
  final int lastPage;

  const ProductPageEntity({
    required this.products,
    required this.currentPage,
    required this.lastPage,
  });

  bool get hasMore => currentPage < lastPage;

  @override
  List<Object?> get props => [products, currentPage, lastPage];
}
