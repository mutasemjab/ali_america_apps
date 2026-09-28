import 'package:dio/dio.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_response_parser.dart';
import '../models/weekly_ad_model.dart';

abstract class WeeklyAdsRemoteDataSource {
  Future<List<WeeklyAdModel>> getWeeklyAds();
}

class WeeklyAdsRemoteDataSourceImpl implements WeeklyAdsRemoteDataSource {
  final Dio _dio;
  WeeklyAdsRemoteDataSourceImpl(this._dio);

  @override
  Future<List<WeeklyAdModel>> getWeeklyAds() async {
    try {
      final response = await _dio.get(ApiEndpoints.weeklyAds);
      final data = ApiResponseParser.unwrap(response) as List<dynamic>;
      return data.map((e) => WeeklyAdModel.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      ApiResponseParser.handleDioException(e);
    }
  }
}
