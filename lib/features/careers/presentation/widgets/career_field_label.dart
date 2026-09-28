import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/career_spec_entity.dart';

class CareerFieldLabel extends StatelessWidget {
  final CareerSpecEntity spec;
  const CareerFieldLabel({super.key, required this.spec});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: AppTextStyles.titleMedium,
        children: [
          TextSpan(text: spec.name),
          if (spec.required) const TextSpan(text: ' *', style: TextStyle(color: AppColors.error)),
        ],
      ),
    );
  }
}
