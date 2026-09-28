import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/barcode_countdown_view.dart';
import '../../domain/entities/coupon_entity.dart';
import '../cubit/coupons_cubit.dart';
import '../cubit/coupons_state.dart';
import 'clip_snip_button.dart';

/// Shows a coupon's full detail sheet. Pass [cubit] when the coupon can
/// still be clipped from here (the browse list) — the sheet then stays
/// open and live-updates via that cubit's state once clipped, landing on
/// the countdown/barcode without the user needing to reopen anything.
/// Omit it for coupons that are already clipped and won't change here
/// (the wallet) — the sheet just renders the static detail plus the
/// self-ticking countdown.
Future<void> showCouponDetailSheet(
  BuildContext context, {
  required CouponEntity coupon,
  CouponsCubit? cubit,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) => DraggableScrollableSheet(
      initialChildSize: 0.72,
      minChildSize: 0.4,
      maxChildSize: 0.94,
      expand: false,
      builder: (context, scrollController) {
        if (cubit == null) {
          return _CouponDetailContent(
            coupon: coupon,
            loading: false,
            onClip: null,
            scrollController: scrollController,
          );
        }

        return BlocBuilder<CouponsCubit, CouponsState>(
          bloc: cubit,
          builder: (context, state) {
            // Not state.coupons.firstWhere(orElse: ...): the list's runtime
            // type is List<CouponModel> (from the repository), so orElse
            // would have to return a CouponModel too — a plain CouponEntity
            // fallback throws a type error at runtime. .where() sidesteps
            // that since it only needs a bool back.
            final matches = state.coupons.where((c) => c.id == coupon.id);
            final current = matches.isEmpty ? coupon : matches.first;
            return _CouponDetailContent(
              coupon: current,
              loading: state.clippingIds.contains(coupon.id),
              onClip: () async {
                final error = await cubit.clip(coupon.id);
                if (error != null && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
                }
              },
              scrollController: scrollController,
            );
          },
        );
      },
    ),
  );
}

class _CouponDetailContent extends StatelessWidget {
  final CouponEntity coupon;
  final bool loading;
  final Future<void> Function()? onClip;
  final ScrollController scrollController;

  const _CouponDetailContent({
    required this.coupon,
    required this.loading,
    required this.onClip,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat.yMMMd();
    final showBarcode = coupon.isClipped && coupon.barcode != null;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: ListView(
        controller: scrollController,
        padding: EdgeInsets.zero,
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(color: AppColors.divider, borderRadius: BorderRadius.circular(4)),
            ),
          ),
          Hero(
            tag: 'coupon-${coupon.id}',
            child: AppNetworkImage(
              url: coupon.photo,
              width: double.infinity,
              height: 180,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(coupon.name, style: AppTextStyles.displayMedium),
                const SizedBox(height: 8),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10,
                  runSpacing: 4,
                  children: [
                    Text(coupon.priceAfterDiscountLabel, style: AppTextStyles.couponPrice),
                    Text(coupon.priceLabel, style: AppTextStyles.couponPriceStrike),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Save ${coupon.savePriceLabel}',
                        style: AppTextStyles.titleMedium.copyWith(color: AppColors.success),
                      ),
                    ),
                  ],
                ),
                if (coupon.description != null && coupon.description!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text('Details', style: AppTextStyles.titleMedium),
                  const SizedBox(height: 6),
                  Text(coupon.description!, style: AppTextStyles.bodyLarge),
                ],
                if (coupon.terms != null && coupon.terms!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text('Terms', style: AppTextStyles.titleMedium),
                  const SizedBox(height: 6),
                  Text(coupon.terms!, style: AppTextStyles.bodyMedium),
                ],
                if (coupon.endAt != null) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.schedule_rounded, size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 6),
                      Text('Valid until ${dateFormat.format(coupon.endAt!)}', style: AppTextStyles.bodyMedium),
                    ],
                  ),
                ],
                const SizedBox(height: 24),
                if (showBarcode)
                  BarcodeCountdownView(
                    barcode: coupon.barcode!,
                    minutesRemaining: coupon.timeWhenClipped,
                    readyLabel: 'Clipped',
                  )
                else if (onClip != null)
                  ClipSnipButton(
                    label: 'Clip this coupon',
                    loading: loading,
                    onTap: () => onClip!(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
