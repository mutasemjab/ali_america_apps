import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/connectivity/connectivity_cubit.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/shimmer_box.dart';
import '../../domain/entities/home_icons_entity.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../widgets/banner_carousel.dart';
import '../widgets/feature_tile_grid.dart';
import '../widgets/store_logo.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HomeCubit>()..load(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityCubit, bool>(
      builder: (context, isOnline) {
        return BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            final storeName = state is HomeLoaded ? state.home.store.name : 'Store';

            return AppScaffold(
              isOffline: !isOnline,
              appBar: AppBar(
                title: Row(
                  children: [
                    const StoreLogo(size: 60),
                    const SizedBox(width: 10),
                    Flexible(child: Text(storeName, overflow: TextOverflow.ellipsis)),
                  ],
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.person_outline_rounded),
                    tooltip: 'Profile',
                    onPressed: () => context.push('/profile'),
                  ),
                ],
              ),
              body: RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () => context.read<HomeCubit>().load(),
                child: _buildBody(context, state),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, HomeState state) {
    if (state is HomeError) {
      return ErrorView(
        message: state.message,
        onRetry: () => context.read<HomeCubit>().load(),
      );
    }

    final banners = state is HomeLoaded ? state.home.banners : null;
    final icons = state is HomeLoaded ? state.home.icons : null;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        if (banners == null)
          const ShimmerBox(height: 210, borderRadius: BorderRadius.all(Radius.circular(20)))
        else
          BannerCarousel(banners: banners),
        const SizedBox(height: 24),
        Text('Explore', style: AppTextStyles.headline),
        const SizedBox(height: 14),
        if (icons == null)
          const _TileGridShimmer()
        else
          FeatureTileGrid(tiles: _buildTiles(context, icons)),
      ],
    );
  }

  List<FeatureTile> _buildTiles(BuildContext context, HomeIconsEntity icons) {
    return [
      if (icons.inStoreDeals)
        FeatureTile(
          icon: Icons.local_offer_rounded,
          label: 'In-Store Deals',
          onTap: () => context.push('/deals'),
        ),
      if (icons.social)
        FeatureTile(
          icon: Icons.share_rounded,
          label: 'Social',
          onTap: () => context.push('/socials'),
        ),
      if (icons.qr)
        FeatureTile(
          icon: Icons.qr_code_rounded,
          label: 'QR Code',
          onTap: () => context.push('/qr'),
        ),
      if (icons.weeklyAds)
        FeatureTile(
          icon: Icons.campaign_rounded,
          label: 'Weekly Ads',
          onTap: () => context.push('/weekly-ads'),
        ),
      if (icons.coupons)
        FeatureTile(
          icon: Icons.confirmation_number_rounded,
          label: 'Coupons',
          onTap: () => context.push('/coupons'),
        ),
      if (icons.location)
        FeatureTile(
          icon: Icons.location_on_rounded,
          label: 'Location',
          onTap: () => context.push('/locations'),
        ),
      if (icons.rewards)
        FeatureTile(
          icon: Icons.emoji_events_rounded,
          label: 'Rewards',
          onTap: () => context.push('/rewards'),
        ),
      // Careers has no home-icons flag from the API — always shown.
      FeatureTile(
        icon: Icons.work_outline_rounded,
        label: 'Careers',
        onTap: () => context.push('/careers'),
      ),
    ];
  }
}

class _TileGridShimmer extends StatelessWidget {
  const _TileGridShimmer();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 6,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 1.25,
      ),
      itemBuilder: (context, index) =>
          const ShimmerBox(borderRadius: BorderRadius.all(Radius.circular(22))),
    );
  }
}
