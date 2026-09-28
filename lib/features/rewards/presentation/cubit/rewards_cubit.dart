import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../profile/domain/usecases/get_me_usecase.dart';
import '../../domain/entities/reward_entity.dart';
import '../../domain/entities/reward_redemption_entity.dart';
import '../../domain/usecases/get_rewards_usecase.dart';
import '../../domain/usecases/redeem_reward_usecase.dart';
import 'rewards_state.dart';

class RewardsCubit extends Cubit<RewardsState> {
  final GetRewardsUseCase _getRewardsUseCase;
  final RedeemRewardUseCase _redeemRewardUseCase;
  final GetMeUseCase _getMeUseCase;

  RewardsCubit(this._getRewardsUseCase, this._redeemRewardUseCase, this._getMeUseCase)
      : super(const RewardsState());

  // load()/redeem() emit via state.copyWith rather than a bare RewardsState(...)
  // so activeRedemptions survives refreshes — otherwise a pull-to-refresh (or
  // the initial load() racing a redeem) would silently drop a barcode the
  // user hasn't finished using yet.
  Future<void> load() async {
    emit(state.copyWith(status: RewardsStatus.loading));
    final result = await _getRewardsUseCase(const NoParams());
    await result.fold(
      (failure) async =>
          emit(state.copyWith(status: RewardsStatus.error, errorMessage: failure.message)),
      (summary) async {
        // The rewards endpoint's own point count has been unreliable
        // (returns 0 under some field-naming variants); /me is what the
        // Settings screen reads and is confirmed correct, so it wins here.
        final meResult = await _getMeUseCase(const NoParams());
        final resolvedSummary = meResult.fold(
          (_) => summary,
          (client) => summary.copyWith(currentVisits: client.totalPoints),
        );
        emit(state.copyWith(status: RewardsStatus.loaded, summary: resolvedSummary));
      },
    );
  }

  /// Spends the reward's points server-side and returns the freshly
  /// issued barcode. On success, the local point balance is updated
  /// immediately so the reward list re-sections (available -> locked)
  /// without waiting on a full reload, and the barcode is kept in
  /// [RewardsState.activeRedemptions] so dismissing the sheet (tapping
  /// outside) doesn't lose it — [viewActiveRedemption] can reopen the same
  /// barcode until it actually expires.
  Future<({RewardRedemptionEntity? redemption, String? error})> redeem(RewardEntity reward) async {
    emit(state.copyWith(redeemingIds: {...state.redeemingIds, reward.id}));
    final result = await _redeemRewardUseCase(RedeemRewardParams(reward.id));

    RewardRedemptionEntity? redemption;
    String? error;
    result.fold((failure) => error = failure.message, (r) {
      redemption = r;
      final summary = state.summary;
      if (summary != null) {
        final updatedPoints = r.currentPoints ?? (summary.currentVisits - reward.visitsRequired);
        emit(state.copyWith(summary: summary.copyWith(currentVisits: updatedPoints)));
      }

      final minutes = r.minutesRemaining;
      final expiresAt = minutes == null ? null : DateTime.now().add(Duration(minutes: minutes));
      emit(
        state.copyWith(
          activeRedemptions: {
            ...state.activeRedemptions,
            reward.id: ActiveRedemption(barcode: r.barcode, expiresAt: expiresAt),
          },
        ),
      );
    });

    emit(state.copyWith(redeemingIds: {...state.redeemingIds}..remove(reward.id)));
    return (redemption: redemption, error: error);
  }

  /// The still-valid barcode from a previous redemption, if any — lets the
  /// UI reopen it without spending points again.
  ActiveRedemption? activeRedemptionFor(RewardEntity reward) => state.activeRedemptionFor(reward.id);
}
