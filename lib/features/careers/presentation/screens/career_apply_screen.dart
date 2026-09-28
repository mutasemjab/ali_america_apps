import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../domain/entities/career_entity.dart';
import '../bloc/career_apply_bloc.dart';
import '../bloc/career_apply_event.dart';
import '../bloc/career_apply_state.dart';
import '../widgets/career_apply_result_views.dart';
import '../widgets/career_spec_field.dart';

class CareerApplyScreen extends StatelessWidget {
  final CareerEntity career;

  const CareerApplyScreen({super.key, required this.career});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CareerApplyBloc>()..add(CareerApplyStarted(career)),
      child: const _CareerApplyView(),
    );
  }
}

class _CareerApplyView extends StatelessWidget {
  const _CareerApplyView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Apply')),
      body: BlocBuilder<CareerApplyBloc, CareerApplyState>(
        builder: (context, state) {
          switch (state.status) {
            case CareerApplyStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case CareerApplyStatus.alreadyApplied:
              return CareerAlreadyAppliedView(onBack: () => context.pop(true));
            case CareerApplyStatus.success:
              return CareerApplySuccessView(onDone: () => context.pop(true));
            case CareerApplyStatus.ready:
            case CareerApplyStatus.submitting:
            case CareerApplyStatus.error:
              return _CareerApplyForm(career: state.career!, state: state);
          }
        },
      ),
    );
  }
}

class _CareerApplyForm extends StatelessWidget {
  final CareerEntity career;
  final CareerApplyState state;

  const _CareerApplyForm({required this.career, required this.state});

  @override
  Widget build(BuildContext context) {
    final submitting = state.status == CareerApplyStatus.submitting;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(career.title, style: AppTextStyles.displayMedium),
          const SizedBox(height: 8),
          Text(career.description, style: AppTextStyles.bodyLarge),
          const SizedBox(height: 28),
          for (final spec in career.specifications) ...[
            CareerSpecField(spec: spec, state: state),
            const SizedBox(height: 18),
          ],
          if (state.generalError != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline_rounded, size: 18, color: AppColors.error),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      state.generalError!,
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
          AppButton(
            label: 'Submit Application',
            loading: submitting,
            onPressed: () => context.read<CareerApplyBloc>().add(const CareerApplySubmitted()),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
