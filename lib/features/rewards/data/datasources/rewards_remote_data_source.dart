import 'package:dio/dio.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_response_parser.dart';
import '../models/reward_redemption_model.dart';
import '../models/rewards_summary_model.dart';

abstract class RewardsRemoteDataSource {
  Future<RewardsSummaryModel> getRewards();

  Future<RewardRedemptionModel> redeemReward(int rewardId);
}

class RewardsRemoteDataSourceImpl implements RewardsRemoteDataSource {
  final Dio _dio;
  RewardsRemoteDataSourceImpl(this._dio);

  @override
  Future<RewardsSummaryModel> getRewards() async {
    try {
      // The Bearer token (attached automatically by AuthInterceptor) is
      // what actually resolves the visit count — this call is only ever
      // made from a gated, logged-in screen, never as a guest fallback.
      final response = await _dio.get(
        ApiEndpoints.rewards,
        options: Options(headers: {'Accept-Language': 'en'}),
      );
      final data = ApiResponseParser.unwrap(response) as Map<String, dynamic>;
      return RewardsSummaryModel.fromJson(data);
    } on DioException catch (e) {
      ApiResponseParser.handleDioException(e);
    }
  }

  @override
  Future<RewardRedemptionModel> redeemReward(int rewardId) async {
    try {
      final response = await _dio.post(ApiEndpoints.redeemReward(rewardId));
      final data = ApiResponseParser.unwrap(response) as Map<String, dynamic>;
      return RewardRedemptionModel.fromJson(data);
    } on DioException catch (e) {
      ApiResponseParser.handleDioException(e);
    }
  }
}
