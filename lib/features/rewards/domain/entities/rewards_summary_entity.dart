import 'package:equatable/equatable.dart';

import 'reward_entity.dart';

class RewardsSummaryEntity extends Equatable {
  /// Current point balance for this client. Named `currentVisits` for
  /// historical reasons (the backend originally drove this off visit
  /// count) — it's the one number every reward's availability is compared
  /// against.
  final int currentVisits;
  final List<RewardEntity> rewards;

  const RewardsSummaryEntity({required this.currentVisits, required this.rewards});

  /// A reward is redeemable purely by comparing the current point balance
  /// to its threshold — not a server-computed "earned" flag. That flag is
  /// a one-time achievement concept; this is a spend-and-refill points
  /// economy, so availability has to be recomputed against the live
  /// balance every time (in particular, right after a redemption spends
  /// points, a reward that was available a second ago may no longer be).
  bool isRedeemable(RewardEntity reward) => currentVisits >= reward.visitsRequired;

  int pointsRemainingFor(RewardEntity reward) =>
      (reward.visitsRequired - currentVisits).clamp(0, reward.visitsRequired);

  List<RewardEntity> get redeemableRewards => rewards.where(isRedeemable).toList();

  List<RewardEntity> get lockedRewards => rewards.where((r) => !isRedeemable(r)).toList();

  RewardsSummaryEntity copyWith({int? currentVisits}) {
    return RewardsSummaryEntity(currentVisits: currentVisits ?? this.currentVisits, rewards: rewards);
  }

  @override
  List<Object?> get props => [currentVisits, rewards];
}
