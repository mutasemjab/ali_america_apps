import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/error_view.dart';
import '../cubit/weekly_ads_cubit.dart';
import '../cubit/weekly_ads_state.dart';

/// Full-bleed, magazine-style swipeable gallery — the ad images are the
/// whole point of this screen, so nothing else competes for attention.
class WeeklyAdsScreen extends StatelessWidget {
  const WeeklyAdsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<WeeklyAdsCubit>()..load(),
      child: const _WeeklyAdsView(),
    );
  }
}

class _WeeklyAdsView extends StatefulWidget {
  const _WeeklyAdsView();

  @override
  State<_WeeklyAdsView> createState() => _WeeklyAdsViewState();
}

class _WeeklyAdsViewState extends State<_WeeklyAdsView> {
  final _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Weekly Ads'),
      ),
      body: BlocBuilder<WeeklyAdsCubit, WeeklyAdsState>(
        builder: (context, state) {
          if (state.status == WeeklyAdsStatus.loading) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          }
          if (state.status == WeeklyAdsStatus.error && state.ads.isEmpty) {
            return ErrorView(
              message: state.errorMessage ?? 'Could not load weekly ads',
              onRetry: () => context.read<WeeklyAdsCubit>().load(),
            );
          }
          if (state.ads.isEmpty) {
            return const EmptyState(
              icon: Icons.campaign_outlined,
              title: 'No active ads',
              message: 'This week\'s ad will appear here once it goes live.',
            );
          }

          return Stack(
            children: [
              PageView.builder(
                controller: _controller,
                itemCount: state.ads.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (context, index) {
                  return Hero(
                    tag: 'weekly-ad-${state.ads[index].id}',
                    child: AppNetworkImage(
                      url: state.ads[index].image,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.contain,
                    ),
                  );
                },
              ),
              if (state.ads.length > 1)
                Positioned(
                  bottom: 24,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(state.ads.length, (i) {
                      final active = i == _index;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: active ? 20 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: active ? AppColors.primary : Colors.white38,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      );
                    }),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
