import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/connectivity/connectivity_cubit.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/session/auth_session.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/guest_prompt.dart';
import '../../../../core/widgets/shimmer_box.dart';
import '../../domain/entities/career_entity.dart';
import '../cubit/careers_cubit.dart';
import '../cubit/careers_state.dart';
import '../widgets/career_card.dart';

class CareersScreen extends StatelessWidget {
  const CareersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CareersCubit>()..load(),
      child: const _CareersView(),
    );
  }
}

class _CareersView extends StatelessWidget {
  const _CareersView();

  Future<void> _openCareer(BuildContext context, CareerEntity career) async {
    if (!sl<AuthSession>().isAuthenticated) {
      await showGuestPromptSheet(context, message: 'Log in to apply for this position.');
      return;
    }

    final shouldRefresh = await context.push('/career-apply', extra: career);
    if (shouldRefresh == true && context.mounted) {
      context.read<CareersCubit>().refreshAppliedIds();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityCubit, bool>(
      builder: (context, isOnline) {
        return AppScaffold(
          isOffline: !isOnline,
          appBar: AppBar(title: const Text('Careers')),
          body: BlocBuilder<CareersCubit, CareersState>(
            builder: (context, state) {
              if (state.status == CareersStatus.loading) {
                return const _CareersShimmer();
              }
              if (state.status == CareersStatus.error && state.careers.isEmpty) {
                return ErrorView(
                  message: state.errorMessage ?? 'Could not load open positions',
                  onRetry: () => context.read<CareersCubit>().load(),
                );
              }
              if (state.careers.isEmpty) {
                return const EmptyState(
                  icon: Icons.work_outline_rounded,
                  title: 'No open positions right now',
                  message: "Check back soon — we'll post new openings here.",
                );
              }

              return RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () => context.read<CareersCubit>().load(),
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.careers.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final career = state.careers[index];
                    return CareerCard(
                      career: career,
                      applied: state.appliedIds.contains(career.id),
                      onTap: () => _openCareer(context, career),
                    ).animate(delay: (40 * index).ms).fadeIn(duration: 280.ms).slideY(begin: 0.08, end: 0);
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

class _CareersShimmer extends StatelessWidget {
  const _CareersShimmer();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 4,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) =>
          const ShimmerBox(height: 132, borderRadius: BorderRadius.all(Radius.circular(18))),
    );
  }
}
