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
import '../cubit/socials_cubit.dart';
import '../cubit/socials_state.dart';

class SocialsScreen extends StatelessWidget {
  const SocialsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SocialsCubit>()..load(),
      child: Builder(
        builder: (context) => AppScaffold(
          appBar: AppBar(title: const Text('Social')),
          body: BlocBuilder<SocialsCubit, SocialsState>(
            builder: (context, state) {
              if (state.status == SocialsStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.status == SocialsStatus.error && state.socials.isEmpty) {
                return ErrorView(
                  message: state.errorMessage ?? 'Could not load social links',
                  onRetry: () => context.read<SocialsCubit>().load(),
                );
              }
              if (state.socials.isEmpty) {
                return const EmptyState(
                  icon: Icons.share_outlined,
                  title: 'No social links yet',
                  message: 'Check back later for ways to follow this store.',
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: state.socials.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final social = state.socials[index];
                  return _SocialTile(name: social.name, icon: social.icon, onTap: () => LaunchHelper.openUrl(social.link))
                      .animate(delay: (40 * index).ms)
                      .fadeIn(duration: 260.ms)
                      .slideX(begin: 0.05, end: 0);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SocialTile extends StatelessWidget {
  final String name;
  final String? icon;
  final VoidCallback onTap;

  const _SocialTile({required this.name, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              ClipOval(child: AppNetworkImage(url: icon, width: 40, height: 40)),
              const SizedBox(width: 14),
              Expanded(child: Text(name, style: AppTextStyles.titleMedium)),
              const Icon(Icons.open_in_new_rounded, size: 18, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
