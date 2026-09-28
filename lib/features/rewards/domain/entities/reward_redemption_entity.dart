import 'package:equatable/equatable.dart';

/// The result of redeeming a reward — a freshly issued barcode with its
/// own countdown, separate from anything shown on the list. Points have
/// already been deducted server-side by the time this comes back.
class RewardRedemptionEntity extends Equatable {
  final String barcode;
  final int? minutesRemaining;

  /// Updated point balance after the deduction, if the backend sends it.
  /// When absent, the caller falls back to subtracting the reward's own
  /// cost locally.
  final int? currentPoints;

  const RewardRedemptionEntity({
    required this.barcode,
    this.minutesRemaining,
    this.currentPoints,
  });

  @override
  List<Object?> get props => [barcode, minutesRemaining, currentPoints];
}
