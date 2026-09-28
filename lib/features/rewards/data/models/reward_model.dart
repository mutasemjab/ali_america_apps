import '../../domain/entities/reward_entity.dart';

class RewardModel extends RewardEntity {
  const RewardModel({
    required super.id,
    required super.name,
    super.image,
    required super.visitsRequired,
    required super.earned,
    required super.visitsRemaining,
    super.barcode,
  });

  factory RewardModel.fromJson(Map<String, dynamic> json) {
    // The backend has used both visit-based ("visits_required", "earned",
    // "visits_remaining") and points-based ("points_required", "unlocked",
    // "points_remaining") key names for this same data at different times
    // — accept either so this doesn't silently break if one is in use.
    final requiredRaw = json['points_required'] ?? json['visits_required'];
    final remainingRaw = json['points_remaining'] ?? json['visits_remaining'];
    final earnedRaw = json['unlocked'] ?? json['earned'];
    // Laravel can serialize a boolean as true, 1, or "1" depending on casts.
    final earned = earnedRaw == true || earnedRaw == 1 || earnedRaw == '1' || earnedRaw == 'true';
    int toInt(dynamic v) => v is num ? v.toInt() : int.tryParse(v?.toString() ?? '') ?? 0;

    return RewardModel(
      id: json['id'] as int,
      name: json['name']?.toString() ?? '',
      image: json['image']?.toString(),
      visitsRequired: toInt(requiredRaw),
      earned: earned,
      visitsRemaining: toInt(remainingRaw),
      barcode: json['barcode']?.toString(),
    );
  }
}
