import 'package:equatable/equatable.dart';

import '../../domain/entities/rewards_summary_entity.dart';

enum RewardsStatus { loading, loaded, error }

/// A barcode already issued by a redemption, kept in memory so dismissing
/// the bottom sheet (tapping outside) doesn't lose it — the user can tap
/// the reward again and see the same barcode/countdown until it genuinely
/// expires. [expiresAt] is a local device-clock deadline computed once,
/// right when the barcode was issued (`DateTime.now() + minutesRemaining`);
/// every later check compares it against the same local clock, so this is
/// not the server-timestamp-vs-device-clock comparison that caused
/// timezone bugs elsewhere in this app.
class ActiveRedemption extends Equatable {
  final String barcode;
  final DateTime? expiresAt;

  const ActiveRedemption({required this.barcode, this.expiresAt});

  bool get isExpired => expiresAt != null && !DateTime.now().isBefore(expiresAt!);

  /// Recomputed live from [expiresAt] every call — always reflects
  /// however much time has actually passed, including while the sheet
  /// was closed. Rounded up so the countdown never visibly jumps
  /// backwards by rounding down mid-minute.
  int? get minutesRemaining {
    final deadline = expiresAt;
    if (deadline == null) return null;
    final secondsLeft = deadline.difference(DateTime.now()).inSeconds;
    if (secondsLeft <= 0) return 0;
    return (secondsLeft / 60).ceil();
  }

  @override
  List<Object?> get props => [barcode, expiresAt];
}

class RewardsState extends Equatable {
  final RewardsStatus status;
  final RewardsSummaryEntity? summary;
  final String? errorMessage;
  final Set<int> redeemingIds;
  final Map<int, ActiveRedemption> activeRedemptions;

  const RewardsState({
    this.status = RewardsStatus.loading,
    this.summary,
    this.errorMessage,
    this.redeemingIds = const {},
    this.activeRedemptions = const {},
  });

  ActiveRedemption? activeRedemptionFor(int rewardId) {
    final entry = activeRedemptions[rewardId];
    if (entry == null || entry.isExpired) return null;
    return entry;
  }

  RewardsState copyWith({
    RewardsStatus? status,
    RewardsSummaryEntity? summary,
    String? errorMessage,
    Set<int>? redeemingIds,
    Map<int, ActiveRedemption>? activeRedemptions,
  }) {
    return RewardsState(
      status: status ?? this.status,
      summary: summary ?? this.summary,
      errorMessage: errorMessage,
      redeemingIds: redeemingIds ?? this.redeemingIds,
      activeRedemptions: activeRedemptions ?? this.activeRedemptions,
    );
  }

  @override
  List<Object?> get props => [status, summary, errorMessage, redeemingIds, activeRedemptions];
}
