import 'package:dio/dio.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_response_parser.dart';
import '../models/category_model.dart';
import '../models/product_page_model.dart';

abstract class DealsRemoteDataSource {
  Future<List<CategoryModel>> getCategories();
  Future<ProductPageModel> getProducts({int? categoryId, String? search, int page = 1});
}

class DealsRemoteDataSourceImpl implements DealsRemoteDataSource {
  final Dio _dio;
  DealsRemoteDataSourceImpl(this._dio);

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await _dio.get(ApiEndpoints.categories);
      final data = ApiResponseParser.unwrap(response) as List<dynamic>;
      return data.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      ApiResponseParser.handleDioException(e);
    }
  }

  @override
  Future<ProductPageModel> getProducts({int? categoryId, String? search, int page = 1}) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.products,
        queryParameters: {
          if (categoryId != null) 'category_id': categoryId,
          if (search?.isNotEmpty ?? false) 'search': search,
          'page': page,
        },
      );
      final data = ApiResponseParser.unwrap(response) as List<dynamic>;
      final pagination = ApiResponseParser.pagination(response);
      return ProductPageModel.fromJson(data, pagination);
    } on DioException catch (e) {
      ApiResponseParser.handleDioException(e);
    }
  }
}
