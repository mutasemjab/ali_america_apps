import 'package:dio/dio.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_response_parser.dart';
import '../models/social_model.dart';

abstract class SocialsRemoteDataSource {
  Future<List<SocialModel>> getSocials();
}

class SocialsRemoteDataSourceImpl implements SocialsRemoteDataSource {
  final Dio _dio;
  SocialsRemoteDataSourceImpl(this._dio);

  @override
  Future<List<SocialModel>> getSocials() async {
    try {
      final response = await _dio.get(ApiEndpoints.socials);
      final data = ApiResponseParser.unwrap(response) as List<dynamic>;
      return data.map((e) => SocialModel.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      ApiResponseParser.handleDioException(e);
    }
  }
}
