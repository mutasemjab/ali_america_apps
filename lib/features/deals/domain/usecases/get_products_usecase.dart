import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/product_page_entity.dart';
import '../repositories/deals_repository.dart';

class GetProductsUseCase implements UseCase<ProductPageEntity, GetProductsParams> {
  final DealsRepository repository;
  GetProductsUseCase(this.repository);

  @override
  ResultFuture<ProductPageEntity> call(GetProductsParams params) {
    return repository.getProducts(categoryId: params.categoryId, search: params.search, page: params.page);
  }
}

class GetProductsParams extends Equatable {
  final int? categoryId;
  final String? search;
  final int page;

  const GetProductsParams({this.categoryId, this.search, this.page = 1});

  @override
  List<Object?> get props => [categoryId, search, page];
}
