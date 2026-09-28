import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/career_spec_entity.dart';
import '../bloc/career_apply_state.dart';
import 'career_field_label.dart';

class CareerFileInput extends StatelessWidget {
  final CareerSpecEntity spec;
  final PickedCareerFile? file;
  final String? errorText;
  final void Function(String path, String name) onPicked;
  final VoidCallback onCleared;

  const CareerFileInput({
    super.key,
    required this.spec,
    required this.file,
    required this.errorText,
    required this.onPicked,
    required this.onCleared,
  });

  Future<void> _pick(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles();
    final picked = result?.files.single;
    if (picked?.path != null) onPicked(picked!.path!, picked.name);
  }

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null;
    final hasFile = file != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CareerFieldLabel(spec: spec),
        const SizedBox(height: 8),
        InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => _pick(context),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surfaceMuted,
              borderRadius: BorderRadius.circular(14),
              border: hasError ? Border.all(color: AppColors.error, width: 1.4) : null,
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryLight,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    hasFile ? Icons.insert_drive_file_rounded : Icons.upload_file_rounded,
                    color: AppColors.primaryDark,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    hasFile ? file!.name : 'Tap to upload a file',
                    style: hasFile ? AppTextStyles.bodyLarge : AppTextStyles.bodyMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (hasFile)
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 18, color: AppColors.textSecondary),
                    onPressed: onCleared,
                    tooltip: 'Remove',
                  ),
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
