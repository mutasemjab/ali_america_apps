import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/launch_helper.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/error_view.dart';
import '../../domain/entities/location_entity.dart';
import '../cubit/locations_cubit.dart';
import '../cubit/locations_state.dart';

class LocationsScreen extends StatelessWidget {
  const LocationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LocationsCubit>()..load(),
      child: Builder(
        builder: (context) => AppScaffold(
          appBar: AppBar(title: const Text('Location')),
          body: BlocBuilder<LocationsCubit, LocationsState>(
            builder: (context, state) {
              if (state.status == LocationsStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.status == LocationsStatus.error && state.locations.isEmpty) {
                return ErrorView(
                  message: state.errorMessage ?? 'Could not load store locations',
                  onRetry: () => context.read<LocationsCubit>().load(),
                );
              }
              if (state.locations.isEmpty) {
                return const EmptyState(
                  icon: Icons.location_off_outlined,
                  title: 'No locations listed',
                  message: 'Store branch details will show up here once available.',
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: state.locations.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  return _LocationCard(location: state.locations[index])
                      .animate(delay: (60 * index).ms)
                      .fadeIn(duration: 300.ms)
                      .slideY(begin: 0.08, end: 0);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _LocationCard extends StatelessWidget {
  final LocationEntity location;
  const _LocationCard({required this.location});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppNetworkImage(url: location.photo, width: double.infinity, height: 140),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(location.name, style: AppTextStyles.titleLarge),
                if (location.address != null && location.address!.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.place_outlined, size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 6),
                      Expanded(child: Text(location.address!, style: AppTextStyles.bodyMedium)),
                    ],
                  ),
                ],
                if (location.phone != null && location.phone!.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.call_outlined, size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 6),
                      Text(location.phone!, style: AppTextStyles.bodyMedium),
                    ],
                  ),
                ],
                const SizedBox(height: 14),
                Row(
                  children: [
                    if (location.lat != null && location.lng != null)
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => LaunchHelper.openDirections(
                            lat: location.lat!,
                            lng: location.lng!,
                            label: location.name,
                          ),
                          icon: const Icon(Icons.directions_rounded, size: 18),
                          label: const Text('Directions'),
                        ),
                      ),
                    if (location.lat != null && location.lng != null && location.phone != null)
                      const SizedBox(width: 10),
                    if (location.phone != null && location.phone!.isNotEmpty)
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => LaunchHelper.callPhone(location.phone!),
                          icon: const Icon(Icons.call_rounded, size: 18),
                          label: const Text('Call'),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
