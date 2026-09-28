import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/connectivity/connectivity_cubit.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/error_view.dart';
import '../bloc/deals_bloc.dart';
import '../bloc/deals_event.dart';
import '../bloc/deals_state.dart';
import '../widgets/category_chip_row.dart';
import '../widgets/product_card.dart';
import '../widgets/product_grid_shimmer.dart';
import '../widgets/product_list_shimmer.dart';
import '../widgets/product_list_tile.dart';

enum _ViewMode { grid, list }

class DealsScreen extends StatelessWidget {
  const DealsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<DealsBloc>()..add(const DealsStarted()),
      child: const _DealsView(),
    );
  }
}

class _DealsView extends StatefulWidget {
  const _DealsView();

  @override
  State<_DealsView> createState() => _DealsViewState();
}

class _DealsViewState extends State<_DealsView> {
  final _scrollController = ScrollController();
  _ViewMode _viewMode = _ViewMode.list;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 300) {
      context.read<DealsBloc>().add(const DealsMoreRequested());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityCubit, bool>(
      builder: (context, isOnline) {
        return AppScaffold(
          isOffline: !isOnline,
          appBar: AppBar(
            title: const Text('In-Store Deals'),
            actions: [
              IconButton(
                tooltip: _viewMode == _ViewMode.grid ? 'List view' : 'Grid view',
                icon: Icon(_viewMode == _ViewMode.grid ? Icons.view_list_rounded : Icons.grid_view_rounded),
                onPressed: () {
                  setState(() {
                    _viewMode = _viewMode == _ViewMode.grid ? _ViewMode.list : _ViewMode.grid;
                  });
                },
              ),
            ],
          ),
          body: BlocBuilder<DealsBloc, DealsState>(
            builder: (context, state) {
              return Column(
                children: [
                  const SizedBox(height: 4),
                  CategoryChipRow(
                    categories: state.categories,
                    selectedCategoryId: state.selectedCategoryId,
                    onSelected: (id) => context.read<DealsBloc>().add(DealsCategorySelected(id)),
                  ),
                  const SizedBox(height: 12),
                  Expanded(child: _buildContent(context, state)),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, DealsState state) {
    if (state.status == ProductsStatus.loading || state.status == ProductsStatus.initial) {
      return _viewMode == _ViewMode.grid ? const ProductGridShimmer() : const ProductListShimmer();
    }

    if (state.status == ProductsStatus.error && state.products.isEmpty) {
      return ErrorView(
        message: state.errorMessage ?? 'Could not load products',
        onRetry: () => context.read<DealsBloc>().add(const DealsStarted()),
      );
    }

    if (state.products.isEmpty) {
      return const EmptyState(
        icon: Icons.local_offer_outlined,
        title: 'No products here yet',
        message: 'Check back soon or try a different category.',
      );
    }

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async => context.read<DealsBloc>().add(const DealsRefreshed()),
      child: _viewMode == _ViewMode.grid ? _buildGrid(context, state) : _buildList(context, state),
    );
  }

  Widget _buildGrid(BuildContext context, DealsState state) {
    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      itemCount: state.products.length + (state.status == ProductsStatus.loadingMore ? 2 : 0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 0.56,
      ),
      itemBuilder: (context, index) {
        if (index >= state.products.length) {
          return const _ShimmerTile();
        }
        final product = state.products[index];
        return ProductCard(product: product)
            .animate(delay: (30 * (index % 8)).ms)
            .fadeIn(duration: 250.ms)
            .slideY(begin: 0.08, end: 0);
      },
    );
  }

  Widget _buildList(BuildContext context, DealsState state) {
    return ListView.separated(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      itemCount: state.products.length + (state.status == ProductsStatus.loadingMore ? 1 : 0),
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        if (index >= state.products.length) {
          return const _ShimmerTile();
        }
        final product = state.products[index];
        return ProductListTile(product: product)
            .animate(delay: (30 * (index % 8)).ms)
            .fadeIn(duration: 250.ms)
            .slideY(begin: 0.08, end: 0);
      },
    );
  }
}

class _ShimmerTile extends StatelessWidget {
  const _ShimmerTile();

  @override
  Widget build(BuildContext context) {
    // Sliver lists/grids can hand children unbounded height — an
    // unconstrained Center blows up layout, so pin a fixed height here.
    return const SizedBox(
      height: 128,
      child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
    );
  }
}
