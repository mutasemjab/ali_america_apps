import 'package:equatable/equatable.dart';

import '../../domain/entities/career_entity.dart';

enum CareerApplyStatus { loading, ready, submitting, success, alreadyApplied, error }

class PickedCareerFile extends Equatable {
  final String path;
  final String name;
  const PickedCareerFile({required this.path, required this.name});

  @override
  List<Object?> get props => [path, name];
}

class CareerApplyState extends Equatable {
  final CareerApplyStatus status;
  final CareerEntity? career;
  final Map<int, String> values;
  final Map<int, PickedCareerFile> files;
  final Map<int, String> fieldErrors;
  final String? generalError;

  const CareerApplyState({
    this.status = CareerApplyStatus.loading,
    this.career,
    this.values = const {},
    this.files = const {},
    this.fieldErrors = const {},
    this.generalError,
  });

  CareerApplyState copyWith({
    CareerApplyStatus? status,
    CareerEntity? career,
    Map<int, String>? values,
    Map<int, PickedCareerFile>? files,
    Map<int, String>? fieldErrors,
    String? generalError,
  }) {
    return CareerApplyState(
      status: status ?? this.status,
      career: career ?? this.career,
      values: values ?? this.values,
      files: files ?? this.files,
      fieldErrors: fieldErrors ?? this.fieldErrors,
      generalError: generalError,
    );
  }

  @override
  List<Object?> get props => [status, career, values, files, fieldErrors, generalError];
}
