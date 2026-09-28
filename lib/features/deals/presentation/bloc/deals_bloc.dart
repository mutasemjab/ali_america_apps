import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import '../../domain/usecases/get_products_usecase.dart';
import 'deals_event.dart';
import 'deals_state.dart';

/// Drives the category-filtered, paginated, pull-to-refreshable product
/// list — three interacting async flows, hence a full Bloc rather than a
/// Cubit.
class DealsBloc extends Bloc<DealsEvent, DealsState> {
  final GetCategoriesUseCase _getCategoriesUseCase;
  final GetProductsUseCase _getProductsUseCase;

  DealsBloc(this._getCategoriesUseCase, this._getProductsUseCase) : super(const DealsState()) {
    on<DealsStarted>(_onStarted);
    on<DealsCategorySelected>(_onCategorySelected);
    on<DealsRefreshed>(_onRefreshed);
    on<DealsMoreRequested>(_onMoreRequested);
  }

  Future<void> _onStarted(DealsStarted event, Emitter<DealsState> emit) async {
    emit(state.copyWith(status: ProductsStatus.loading));

    final categoriesResult = await _getCategoriesUseCase(const NoParams());
    final categories = categoriesResult.fold((_) => <CategoryEntity>[], (c) => c);

    await _fetchFirstPage(emit, categories: categories);
  }

  Future<void> _onCategorySelected(DealsCategorySelected event, Emitter<DealsState> emit) async {
    if (event.categoryId == state.selectedCategoryId) return;
    emit(state.copyWith(
      selectedCategoryId: event.categoryId,
      clearSelectedCategory: event.categoryId == null,
      status: ProductsStatus.loading,
    ));
    await _fetchFirstPage(emit, categories: state.categories);
  }

  Future<void> _onRefreshed(DealsRefreshed event, Emitter<DealsState> emit) async {
    await _fetchFirstPage(emit, categories: state.categories);
  }

  Future<void> _onMoreRequested(DealsMoreRequested event, Emitter<DealsState> emit) async {
    if (!state.hasMore || state.status == ProductsStatus.loadingMore) return;

    emit(state.copyWith(status: ProductsStatus.loadingMore));
    final result = await _getProductsUseCase(GetProductsParams(
      categoryId: state.selectedCategoryId,
      page: state.currentPage + 1,
    ));

    result.fold(
      // Silently keep the existing page — a failed "load more" shouldn't
      // blow away what's already on screen.
      (failure) => emit(state.copyWith(status: ProductsStatus.loaded)),
      (page) => emit(state.copyWith(
        products: [...state.products, ...page.products],
        currentPage: page.currentPage,
        hasMore: page.hasMore,
        status: ProductsStatus.loaded,
      )),
    );
  }

  Future<void> _fetchFirstPage(
    Emitter<DealsState> emit, {
    required List<CategoryEntity> categories,
  }) async {
    final result = await _getProductsUseCase(
      GetProductsParams(categoryId: state.selectedCategoryId, page: 1),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        categories: categories,
        status: ProductsStatus.error,
        errorMessage: failure.message,
      )),
      (page) => emit(state.copyWith(
        categories: categories,
        products: page.products,
        currentPage: page.currentPage,
        hasMore: page.hasMore,
        status: ProductsStatus.loaded,
        errorMessage: null,
      )),
    );
  }
}
