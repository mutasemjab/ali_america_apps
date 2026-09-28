import 'package:dio/dio.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_response_parser.dart';
import '../models/verify_otp_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<void> register({required String name, required String phone, String? email, String? fcmToken});
  Future<void> login({required String phone});
  Future<void> resendOtp({required String phone});
  Future<VerifyOtpResponseModel> verifyOtp({
    required String phone,
    required String code,
    String? fcmToken,
  });
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;
  AuthRemoteDataSourceImpl(this._dio);

  @override
  Future<void> register({
    required String name,
    required String phone,
    String? email,
    String? fcmToken,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.register,
        data: {
          'name': name,
          'phone': phone,
          if (email != null && email.isNotEmpty) 'email': email,
          if (fcmToken != null && fcmToken.isNotEmpty) 'fcm_token': fcmToken,
        },
      );
      ApiResponseParser.unwrap(response);
    } on DioException catch (e) {
      ApiResponseParser.handleDioException(e);
    }
  }

  @override
  Future<void> login({required String phone}) async {
    try {
      final response = await _dio.post(ApiEndpoints.login, data: {'phone': phone});
      ApiResponseParser.unwrap(response);
    } on DioException catch (e) {
      ApiResponseParser.handleDioException(e);
    }
  }

  @override
  Future<void> resendOtp({required String phone}) async {
    try {
      final response = await _dio.post(ApiEndpoints.resendOtp, data: {'phone': phone});
      ApiResponseParser.unwrap(response);
    } on DioException catch (e) {
      ApiResponseParser.handleDioException(e);
    }
  }

  @override
  Future<VerifyOtpResponseModel> verifyOtp({
    required String phone,
    required String code,
    String? fcmToken,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.verifyOtp,
        data: {
          'phone': phone,
          'code': code,
          if (fcmToken != null && fcmToken.isNotEmpty) 'fcm_token': fcmToken,
        },
      );
      final data = ApiResponseParser.unwrap(response) as Map<String, dynamic>;
      return VerifyOtpResponseModel.fromJson(data);
    } on DioException catch (e) {
      ApiResponseParser.handleDioException(e);
    }
  }

  @override
  Future<void> logout() async {
    try {
      final response = await _dio.post(ApiEndpoints.logout);
      ApiResponseParser.unwrap(response);
    } on DioException catch (e) {
      ApiResponseParser.handleDioException(e);
    }
  }
}
