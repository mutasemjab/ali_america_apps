import '../../domain/entities/reward_redemption_entity.dart';

class RewardRedemptionModel extends RewardRedemptionEntity {
  const RewardRedemptionModel({required super.barcode, super.minutesRemaining, super.currentPoints});

  factory RewardRedemptionModel.fromJson(Map<String, dynamic> json) {
    int? toInt(dynamic v) => v == null ? null : (v is num ? v.toInt() : int.tryParse(v.toString()));

    return RewardRedemptionModel(
      barcode: json['barcode']?.toString() ?? '',
      minutesRemaining: toInt(json['minutes_remaining']),
      currentPoints: toInt(json['current_points'] ?? json['current_visits']),
    );
  }
}
