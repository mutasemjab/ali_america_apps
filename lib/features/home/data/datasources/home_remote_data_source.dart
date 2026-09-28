import 'package:dio/dio.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_response_parser.dart';
import '../models/home_model.dart';

abstract class HomeRemoteDataSource {
  Future<HomeModel> getHome();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final Dio _dio;
  HomeRemoteDataSourceImpl(this._dio);

  @override
  Future<HomeModel> getHome() async {
    try {
      final response = await _dio.get(ApiEndpoints.home);
      final data = ApiResponseParser.unwrap(response) as Map<String, dynamic>;
      return HomeModel.fromJson(data);
    } on DioException catch (e) {
      ApiResponseParser.handleDioException(e);
    }
  }
}
