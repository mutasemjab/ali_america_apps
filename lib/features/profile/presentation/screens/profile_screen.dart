import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/session/auth_session.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/guest_prompt.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!sl<AuthSession>().isAuthenticated) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: const GuestPrompt(),
      );
    }

    return BlocProvider(
      create: (_) => sl<ProfileCubit>()..load(),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatefulWidget {
  const _ProfileView();

  @override
  State<_ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<_ProfileView> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _initialized = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete account?'),
        content: const Text(
          'This permanently deletes your account, points, and clipped coupons. This cannot be undone.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text('Delete', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    final error = await context.read<ProfileCubit>().deleteAccount();
    if (!context.mounted) return;

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
    } else {
      context.go('/welcome');
    }
  }

  Future<void> _logout(BuildContext context) async {
    await context.read<ProfileCubit>().logout();
    if (context.mounted) context.go('/welcome');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state.client != null && !_initialized) {
            _nameController.text = state.client!.name;
            _emailController.text = state.client!.email ?? '';
            _initialized = true;
          }
          if (state.actionError != null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.actionError!)));
          }
        },
        builder: (context, state) {
          if (state.status == ProfileStatus.loading && state.client == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == ProfileStatus.error && state.client == null) {
            return ErrorView(
              message: state.errorMessage ?? 'Could not load your profile',
              onRetry: () => context.read<ProfileCubit>().load(),
            );
          }

          final client = state.client!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: const BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        client.name.isNotEmpty ? client.name[0].toUpperCase() : '?',
                        style: AppTextStyles.displayMedium.copyWith(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(client.name, style: AppTextStyles.titleLarge),
                          const SizedBox(height: 2),
                          Text(client.phone, style: AppTextStyles.bodyMedium),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(label: 'Visits', value: '${client.numberOfVisit}'),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(label: 'Points', value: '${client.totalPoints}'),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                Text('Edit details', style: AppTextStyles.titleMedium),
                const SizedBox(height: 14),
                AppTextField(controller: _nameController, label: 'Full name'),
                const SizedBox(height: 14),
                AppTextField(
                  controller: _emailController,
                  label: 'Email',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.lock_outline_rounded, size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 6),
                      Text('Phone number cannot be changed', style: AppTextStyles.bodyMedium),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                AppButton(
                  label: 'Save changes',
                  loading: state.saving,
                  onPressed: () => context
                      .read<ProfileCubit>()
                      .save(name: _nameController.text.trim(), email: _emailController.text.trim()),
                ),
                const SizedBox(height: 32),
                AppButton(
                  label: 'Log out',
                  outlined: true,
                  loading: state.loggingOut,
                  onPressed: () => _logout(context),
                ),
                const SizedBox(height: 14),
                Center(
                  child: TextButton(
                    onPressed: state.deleting ? null : () => _confirmDelete(context),
                    child: Text(
                      state.deleting ? 'Deleting…' : 'Delete account',
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;

  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: Alignment.center,
      child: Column(
        children: [
          Text(value, style: AppTextStyles.displayMedium),
          const SizedBox(height: 2),
          Text(label, style: AppTextStyles.label),
        ],
      ),
    );
  }
}
