import 'package:dio/dio.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_response_parser.dart';
import '../../../auth/data/models/client_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ClientModel> getMe();
  Future<ClientModel> updateMe({required String name, String? email, String? fcmToken});
  Future<void> deleteMe();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio _dio;
  ProfileRemoteDataSourceImpl(this._dio);

  @override
  Future<ClientModel> getMe() async {
    try {
      final response = await _dio.get(ApiEndpoints.me);
      final data = ApiResponseParser.unwrap(response) as Map<String, dynamic>;
      return ClientModel.fromJson(data);
    } on DioException catch (e) {
      ApiResponseParser.handleDioException(e);
    }
  }

  @override
  Future<ClientModel> updateMe({required String name, String? email, String? fcmToken}) async {
    try {
      final response = await _dio.put(
        ApiEndpoints.me,
        data: {
          'name': name,
          if (email != null && email.isNotEmpty) 'email': email,
          if (fcmToken != null && fcmToken.isNotEmpty) 'fcm_token': fcmToken,
        },
      );
      final data = ApiResponseParser.unwrap(response) as Map<String, dynamic>;
      return ClientModel.fromJson(data);
    } on DioException catch (e) {
      ApiResponseParser.handleDioException(e);
    }
  }

  @override
  Future<void> deleteMe() async {
    try {
      final response = await _dio.delete(ApiEndpoints.me);
      ApiResponseParser.unwrap(response);
    } on DioException catch (e) {
      ApiResponseParser.handleDioException(e);
    }
  }
}
