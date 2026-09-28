import 'package:equatable/equatable.dart';

import '../../domain/entities/category_entity.dart';
import '../../domain/entities/product_entity.dart';

enum ProductsStatus { initial, loading, loadingMore, loaded, error }

class DealsState extends Equatable {
  final List<CategoryEntity> categories;
  final int? selectedCategoryId;
  final List<ProductEntity> products;
  final ProductsStatus status;
  final int currentPage;
  final bool hasMore;
  final String? errorMessage;

  const DealsState({
    this.categories = const [],
    this.selectedCategoryId,
    this.products = const [],
    this.status = ProductsStatus.initial,
    this.currentPage = 1,
    this.hasMore = true,
    this.errorMessage,
  });

  DealsState copyWith({
    List<CategoryEntity>? categories,
    int? selectedCategoryId,
    bool clearSelectedCategory = false,
    List<ProductEntity>? products,
    ProductsStatus? status,
    int? currentPage,
    bool? hasMore,
    String? errorMessage,
  }) {
    return DealsState(
      categories: categories ?? this.categories,
      selectedCategoryId: clearSelectedCategory ? null : (selectedCategoryId ?? this.selectedCategoryId),
      products: products ?? this.products,
      status: status ?? this.status,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [categories, selectedCategoryId, products, status, currentPage, hasMore, errorMessage];
}
