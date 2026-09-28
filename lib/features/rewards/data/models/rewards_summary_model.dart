import '../../domain/entities/rewards_summary_entity.dart';
import 'reward_model.dart';

int _toInt(dynamic v) => v is num ? v.toInt() : int.tryParse(v?.toString() ?? '') ?? 0;

class RewardsSummaryModel extends RewardsSummaryEntity {
  const RewardsSummaryModel({required super.currentVisits, required super.rewards});

  factory RewardsSummaryModel.fromJson(Map<String, dynamic> json) {
    final rawRewards = json['rewards'] as List<dynamic>? ?? [];
    return RewardsSummaryModel(
      // Same visits-vs-points naming ambiguity as the per-reward fields.
      currentVisits: _toInt(json['current_points'] ?? json['current_visits']),
      rewards: rawRewards.map((e) => RewardModel.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}
