import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/career_spec_entity.dart';
import 'career_field_label.dart';

class CareerSelectInput extends StatelessWidget {
  final CareerSpecEntity spec;
  final String? value;
  final String? errorText;
  final ValueChanged<String> onChanged;

  const CareerSelectInput({
    super.key,
    required this.spec,
    required this.value,
    required this.errorText,
    required this.onChanged,
  });

  Future<void> _openPicker(BuildContext context) async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => _SelectSheet(spec: spec, currentValue: value),
    );
    if (selected != null) onChanged(selected);
  }

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CareerFieldLabel(spec: spec),
        const SizedBox(height: 8),
        InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => _openPicker(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.surfaceMuted,
              borderRadius: BorderRadius.circular(14),
              border: hasError ? Border.all(color: AppColors.error, width: 1.4) : null,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value?.isNotEmpty == true ? value! : 'Select ${spec.name}',
                    style: value?.isNotEmpty == true
                        ? AppTextStyles.bodyLarge
                        : AppTextStyles.bodyMedium,
                  ),
                ),
                const Icon(Icons.expand_more_rounded, color: AppColors.textSecondary),
              ],
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 6),
          Text(errorText!, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error)),
        ],
      ],
    );
  }
}

class _SelectSheet extends StatelessWidget {
  final CareerSpecEntity spec;
  final String? currentValue;
  const _SelectSheet({required this.spec, required this.currentValue});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(color: AppColors.divider, borderRadius: BorderRadius.circular(4)),
            ),
          ),
          Text(spec.name, style: AppTextStyles.titleLarge),
          const SizedBox(height: 8),
          ...spec.values.map((option) {
            final selected = option == currentValue;
            return ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(option, style: AppTextStyles.bodyLarge),
              trailing: selected
                  ? const Icon(Icons.check_circle_rounded, color: AppColors.primary)
                  : null,
              onTap: () => Navigator.of(context).pop(option),
            );
          }),
        ],
      ),
    );
  }
}
