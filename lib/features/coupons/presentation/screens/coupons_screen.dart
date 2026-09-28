import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/connectivity/connectivity_cubit.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/session/auth_session.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/guest_prompt.dart';
import '../../domain/entities/coupon_entity.dart';
import '../cubit/coupons_cubit.dart';
import '../cubit/coupons_state.dart';
import '../widgets/coupon_card.dart';
import '../widgets/coupon_detail_sheet.dart';

class CouponsScreen extends StatelessWidget {
  const CouponsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CouponsCubit>()..load(),
      child: const _CouponsView(),
    );
  }
}

class _CouponsView extends StatelessWidget {
  const _CouponsView();

  Future<void> _openDetail(BuildContext context, CouponEntity coupon) async {
    final isAuthenticated = sl<AuthSession>().isAuthenticated;

    if (!isAuthenticated) {
      await showGuestPromptSheet(context, message: 'Log in to clip coupons and start saving.');
      return;
    }

    // The sheet stays open through the clip action — it live-updates via
    // this cubit's state and lands straight on the countdown/barcode.
    await showCouponDetailSheet(context, coupon: coupon, cubit: context.read<CouponsCubit>());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityCubit, bool>(
      builder: (context, isOnline) {
        return AppScaffold(
          isOffline: !isOnline,
          appBar: AppBar(title: const Text('Coupons')),
          body: BlocBuilder<CouponsCubit, CouponsState>(
            builder: (context, state) {
              if (state.status == CouponsStatus.loading) {
                return const _CouponsShimmer();
              }
              if (state.status == CouponsStatus.error && state.coupons.isEmpty) {
                return ErrorView(
                  message: state.errorMessage ?? 'Could not load coupons',
                  onRetry: () => context.read<CouponsCubit>().load(),
                );
              }
              if (state.coupons.isEmpty) {
                return const EmptyState(
                  icon: Icons.confirmation_number_outlined,
                  title: 'No coupons right now',
                  message: 'New coupons will show up here as soon as they drop.',
                );
              }

              return RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () => context.read<CouponsCubit>().load(),
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.coupons.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final coupon = state.coupons[index];
                    return CouponCard(coupon: coupon, onTap: () => _openDetail(context, coupon))
                        .animate(delay: (40 * index).ms)
                        .fadeIn(duration: 280.ms)
                        .slideY(begin: 0.08, end: 0);
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _CouponsShimmer extends StatelessWidget {
  const _CouponsShimmer();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) => const _ShimmerRow(),
    );
  }
}

class _ShimmerRow extends StatelessWidget {
  const _ShimmerRow();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 190,
      child: DecoratedBox(
        decoration: BoxDecoration(color: AppColors.surfaceMuted, borderRadius: BorderRadius.all(Radius.circular(18))),
      ),
    );
  }
}
