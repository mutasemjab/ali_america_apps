import 'package:dio/dio.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_response_parser.dart';
import '../models/location_model.dart';

abstract class LocationsRemoteDataSource {
  Future<List<LocationModel>> getLocations();
}

class LocationsRemoteDataSourceImpl implements LocationsRemoteDataSource {
  final Dio _dio;
  LocationsRemoteDataSourceImpl(this._dio);

  @override
  Future<List<LocationModel>> getLocations() async {
    try {
      final response = await _dio.get(ApiEndpoints.locations);
      final data = ApiResponseParser.unwrap(response) as List<dynamic>;
      return data.map((e) => LocationModel.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      ApiResponseParser.handleDioException(e);
    }
  }
}
