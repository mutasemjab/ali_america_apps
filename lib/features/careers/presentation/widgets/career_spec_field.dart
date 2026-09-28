import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/career_spec_entity.dart';
import '../../domain/entities/career_spec_type.dart';
import '../bloc/career_apply_bloc.dart';
import '../bloc/career_apply_event.dart';
import '../bloc/career_apply_state.dart';
import 'career_file_input.dart';
import 'career_select_input.dart';
import 'career_text_input.dart';

/// Renders whichever input a specification's `type` calls for. Anything
/// that isn't "select" or "file" falls back to a plain text field rather
/// than the form silently dropping an unrecognized field.
class CareerSpecField extends StatelessWidget {
  final CareerSpecEntity spec;
  final CareerApplyState state;

  const CareerSpecField({super.key, required this.spec, required this.state});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CareerApplyBloc>();
    final errorText = state.fieldErrors[spec.id];

    switch (spec.type) {
      case CareerSpecType.select:
        return CareerSelectInput(
          spec: spec,
          value: state.values[spec.id],
          errorText: errorText,
          onChanged: (value) => bloc.add(CareerApplyFieldChanged(spec.id, value)),
        );
      case CareerSpecType.file:
        return CareerFileInput(
          spec: spec,
          file: state.files[spec.id],
          errorText: errorText,
          onPicked: (path, name) => bloc.add(CareerApplyFilePicked(spec.id, path, name)),
          onCleared: () => bloc.add(CareerApplyFileCleared(spec.id)),
        );
      default:
        return CareerTextInput(
          spec: spec,
          initialValue: state.values[spec.id],
          errorText: errorText,
          onChanged: (value) => bloc.add(CareerApplyFieldChanged(spec.id, value)),
        );
    }
  }
}
