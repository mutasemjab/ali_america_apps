import 'package:dio/dio.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_response_parser.dart';
import '../models/qr_model.dart';

abstract class QrRemoteDataSource {
  Future<List<QrModel>> getQrs();
}

class QrRemoteDataSourceImpl implements QrRemoteDataSource {
  final Dio _dio;
  QrRemoteDataSourceImpl(this._dio);

  @override
  Future<List<QrModel>> getQrs() async {
    try {
      final response = await _dio.get(ApiEndpoints.qrs);
      final data = ApiResponseParser.unwrap(response) as List<dynamic>;
      return data.map((e) => QrModel.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      ApiResponseParser.handleDioException(e);
    }
  }
}
