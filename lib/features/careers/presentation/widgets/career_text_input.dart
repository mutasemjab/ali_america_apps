import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/career_spec_entity.dart';
import 'career_field_label.dart';

class CareerTextInput extends StatefulWidget {
  final CareerSpecEntity spec;
  final String? initialValue;
  final String? errorText;
  final ValueChanged<String> onChanged;

  const CareerTextInput({
    super.key,
    required this.spec,
    required this.initialValue,
    required this.errorText,
    required this.onChanged,
  });

  @override
  State<CareerTextInput> createState() => _CareerTextInputState();
}

class _CareerTextInputState extends State<CareerTextInput> {
  late final _controller = TextEditingController(text: widget.initialValue);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CareerFieldLabel(spec: widget.spec),
        const SizedBox(height: 8),
        TextField(
          controller: _controller,
          onChanged: widget.onChanged,
          maxLines: null,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.surfaceMuted,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.error, width: 1.4),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.error, width: 1.4),
            ),
            errorText: widget.errorText,
          ),
        ),
      ],
    );
  }
}
