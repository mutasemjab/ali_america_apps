import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../domain/entities/reward_entity.dart';

class RewardCard extends StatelessWidget {
  final RewardEntity reward;
  final bool isRedeemable;
  final int pointsRemaining;
  final bool loading;

  /// True when a barcode from a previous redemption is still valid — takes
  /// priority over [isRedeemable]/[pointsRemaining]: points were already
  /// spent, so the card offers to reopen that barcode instead of a fresh
  /// Redeem action, even if the balance has since dropped below what a new
  /// redemption would need.
  final bool hasActiveRedemption;

  /// Only ever called when [isRedeemable] is true and there's no active
  /// redemption — spending points and issuing a barcode is a real action
  /// with a consequence (the points are gone), so it only fires from the
  /// explicit Redeem button, never from tapping the card.
  final VoidCallback? onRedeem;

  /// Called when [hasActiveRedemption] is true — reopens the existing
  /// barcode/countdown without spending any more points.
  final VoidCallback? onViewBarcode;

  const RewardCard({
    super.key,
    required this.reward,
    required this.isRedeemable,
    required this.pointsRemaining,
    required this.loading,
    this.hasActiveRedemption = false,
    this.onRedeem,
    this.onViewBarcode,
  });

  @override
  Widget build(BuildContext context) {
    final unlocked = isRedeemable || hasActiveRedemption;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: unlocked ? Border.all(color: AppColors.success.withValues(alpha: 0.4)) : null,
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      // IntrinsicHeight gives the Row a concrete height to stretch to —
      // without it, an unbounded-height parent (a ListView item) plus
      // CrossAxisAlignment.stretch asks children to be infinitely tall.
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _RewardImage(reward: reward, isRedeemable: unlocked),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      reward.name,
                      style: AppTextStyles.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text('${reward.visitsRequired} points required', style: AppTextStyles.bodyMedium),
                    const SizedBox(height: 10),
                    if (hasActiveRedemption)
                      _RedeemButton(loading: false, onTap: onViewBarcode, label: 'View Barcode')
                    else if (isRedeemable)
                      _RedeemButton(loading: loading, onTap: onRedeem)
                    else
                      _RewardProgress(reward: reward, pointsRemaining: pointsRemaining),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RedeemButton extends StatelessWidget {
  final bool loading;
  final VoidCallback? onTap;
  final String label;
  const _RedeemButton({required this.loading, required this.onTap, this.label = 'Redeem'});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.success,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: loading ? null : onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          child: loading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      label == 'Redeem' ? Icons.redeem_rounded : Icons.qr_code_rounded,
                      size: 16,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      label,
                      style: AppTextStyles.titleMedium.copyWith(color: Colors.white),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _RewardImage extends StatelessWidget {
  final RewardEntity reward;
  final bool isRedeemable;
  const _RewardImage({required this.reward, required this.isRedeemable});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // Same background as the card itself: BoxFit.contain never crops,
      // and any letterboxing blends into the card instead of reading as
      // a gray gap around the image.
      width: 130,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(color: AppColors.surface),
          Opacity(
            opacity: isRedeemable ? 1 : 0.4,
            child: AppNetworkImage(url: reward.image, fit: BoxFit.contain),
          ),
          if (isRedeemable)
            const Positioned(
              top: 6,
              right: 6,
              child: CircleAvatar(
                radius: 12,
                backgroundColor: AppColors.success,
                child: Icon(Icons.check_rounded, size: 14, color: Colors.white),
              ),
            )
          else
            const Center(
              child: Icon(Icons.lock_rounded, color: AppColors.textSecondary, size: 26),
            ),
        ],
      ),
    );
  }
}

class _RewardProgress extends StatelessWidget {
  final RewardEntity reward;
  final int pointsRemaining;
  const _RewardProgress({required this.reward, required this.pointsRemaining});

  @override
  Widget build(BuildContext context) {
    final done = (reward.visitsRequired - pointsRemaining).clamp(0, reward.visitsRequired);
    final progress = reward.visitsRequired == 0 ? 0.0 : done / reward.visitsRequired;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress.clamp(0, 1),
            minHeight: 6,
            backgroundColor: AppColors.surfaceMuted,
            valueColor: const AlwaysStoppedAnimation(AppColors.primary),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '$pointsRemaining ${pointsRemaining == 1 ? 'point' : 'points'} to go',
          style: AppTextStyles.label.copyWith(color: AppColors.primaryDark),
        ),
      ],
    );
  }
}
