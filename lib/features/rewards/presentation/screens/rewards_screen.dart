import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/connectivity/connectivity_cubit.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/session/auth_session.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/guest_prompt.dart';
import '../../../../core/widgets/shimmer_box.dart';
import '../../domain/entities/reward_entity.dart';
import '../cubit/rewards_cubit.dart';
import '../cubit/rewards_state.dart';
import '../widgets/reward_barcode_sheet.dart';
import '../widgets/reward_card.dart';
import '../widgets/rewards_progress_header.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // current_visits only resolves for an identified client — showing this
    // screen to a guest would just be a misleading all-zero state.
    if (!sl<AuthSession>().isAuthenticated) {
      return Scaffold(
        appBar: AppBar(title: const Text('Rewards')),
        body: const GuestPrompt(
          title: 'Track your rewards',
          message: 'Log in to see your points and unlock rewards.',
        ),
      );
    }

    return BlocProvider(
      create: (_) => sl<RewardsCubit>()..load(),
      child: const _RewardsView(),
    );
  }
}

class _RewardsView extends StatelessWidget {
  const _RewardsView();

  Future<void> _redeem(BuildContext context, RewardEntity reward) async {
    final cubit = context.read<RewardsCubit>();
    final result = await cubit.redeem(reward);

    if (!context.mounted) return;

    if (result.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result.error!)));
      return;
    }

    final redemption = result.redemption;
    if (redemption != null) {
      await showRewardRedeemedSheet(
        context,
        barcode: redemption.barcode,
        minutesRemaining: redemption.minutesRemaining,
      );
    }
  }

  // Reopens an already-issued barcode (no new points spent) — recomputed
  // live each call so the countdown reflects real elapsed time, including
  // however long the sheet was closed.
  Future<void> _viewBarcode(BuildContext context, RewardEntity reward) {
    final active = context.read<RewardsCubit>().activeRedemptionFor(reward);
    if (active == null) return Future.value();
    return showRewardRedeemedSheet(
      context,
      barcode: active.barcode,
      minutesRemaining: active.minutesRemaining,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityCubit, bool>(
      builder: (context, isOnline) {
        return AppScaffold(
          isOffline: !isOnline,
          appBar: AppBar(title: const Text('Rewards')),
          body: BlocBuilder<RewardsCubit, RewardsState>(
            builder: (context, state) {
              if (state.status == RewardsStatus.loading) {
                return const _RewardsShimmer();
              }
              if (state.status == RewardsStatus.error) {
                return ErrorView(
                  message: state.errorMessage ?? 'Could not load your rewards',
                  onRetry: () => context.read<RewardsCubit>().load(),
                );
              }

              final summary = state.summary!;
              if (summary.rewards.isEmpty) {
                return const EmptyState(
                  icon: Icons.card_giftcard_outlined,
                  title: 'No rewards set up yet for this store',
                  message: 'Check back later — new rewards may be added soon.',
                );
              }

              // A reward with a still-valid barcode stays actionable even
              // if spending its points dropped the balance below what a
              // fresh redemption of it would need — it belongs with the
              // other "you can do something here" cards, not "locked".
              bool hasActive(RewardEntity r) => state.activeRedemptionFor(r.id) != null;
              final redeemable = [
                ...summary.redeemableRewards,
                ...summary.lockedRewards.where(hasActive),
              ];
              final locked = summary.lockedRewards.where((r) => !hasActive(r)).toList();

              return RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () => context.read<RewardsCubit>().load(),
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    RewardsProgressHeader(currentVisits: summary.currentVisits),
                    if (redeemable.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      Text('Available to Redeem', style: AppTextStyles.headline),
                      const SizedBox(height: 12),
                      for (var i = 0; i < redeemable.length; i++) ...[
                        RewardCard(
                          reward: redeemable[i],
                          isRedeemable: summary.isRedeemable(redeemable[i]),
                          pointsRemaining: 0,
                          loading: state.redeemingIds.contains(redeemable[i].id),
                          hasActiveRedemption: hasActive(redeemable[i]),
                          onRedeem: () => _redeem(context, redeemable[i]),
                          onViewBarcode: () => _viewBarcode(context, redeemable[i]),
                        ).animate(delay: (40 * i).ms).fadeIn(duration: 260.ms).slideY(begin: 0.08, end: 0),
                        if (i != redeemable.length - 1) const SizedBox(height: 12),
                      ],
                    ],
                    if (locked.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      Text('Still to Unlock', style: AppTextStyles.headline),
                      const SizedBox(height: 12),
                      for (var i = 0; i < locked.length; i++) ...[
                        RewardCard(
                          reward: locked[i],
                          isRedeemable: false,
                          pointsRemaining: summary.pointsRemainingFor(locked[i]),
                          loading: false,
                        ).animate(delay: (40 * i).ms).fadeIn(duration: 260.ms).slideY(begin: 0.08, end: 0),
                        if (i != locked.length - 1) const SizedBox(height: 12),
                      ],
                    ],
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _RewardsShimmer extends StatelessWidget {
  const _RewardsShimmer();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        ShimmerBox(height: 132, borderRadius: BorderRadius.all(Radius.circular(22))),
        SizedBox(height: 24),
        ShimmerBox(height: 96, borderRadius: BorderRadius.all(Radius.circular(18))),
        SizedBox(height: 12),
        ShimmerBox(height: 96, borderRadius: BorderRadius.all(Radius.circular(18))),
      ],
    );
  }
}
