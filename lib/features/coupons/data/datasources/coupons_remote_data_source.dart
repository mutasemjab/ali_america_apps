import 'package:dio/dio.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_response_parser.dart';
import '../models/coupon_model.dart';

abstract class CouponsRemoteDataSource {
  Future<List<CouponModel>> getCoupons();
  Future<CouponModel> clipCoupon(int couponId);
}

class CouponsRemoteDataSourceImpl implements CouponsRemoteDataSource {
  final Dio _dio;
  CouponsRemoteDataSourceImpl(this._dio);

  List<CouponModel> _parseList(Response response) {
    final data = ApiResponseParser.unwrap(response) as List<dynamic>;
    return data.map((e) => CouponModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<CouponModel>> getCoupons() async {
    try {
      final response = await _dio.get(ApiEndpoints.coupons);
      return _parseList(response);
    } on DioException catch (e) {
      ApiResponseParser.handleDioException(e);
    }
  }

  @override
  Future<CouponModel> clipCoupon(int couponId) async {
    try {
      final response = await _dio.post(ApiEndpoints.clipCoupon(couponId));
      final data = ApiResponseParser.unwrap(response) as Map<String, dynamic>;
      return CouponModel.fromJson(data);
    } on DioException catch (e) {
      ApiResponseParser.handleDioException(e);
    }
  }
}
