import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/services/applied_careers_store.dart';
import '../../domain/entities/career_answer.dart';
import '../../domain/entities/career_spec_type.dart';
import '../../domain/usecases/apply_to_career_usecase.dart';
import 'career_apply_event.dart';
import 'career_apply_state.dart';

final _answerFieldPattern = RegExp(r'^answers\.(\d+)$');

/// Drives the dynamically-built apply form: per-field values/files, client
/// -side required-field validation before ever hitting the network,
/// mapping the backend's `answers.{id}` validation errors back onto the
/// right field, and the already-applied special case. Real multi-step
/// logic across several interacting pieces, hence a full Bloc.
class CareerApplyBloc extends Bloc<CareerApplyEvent, CareerApplyState> {
  final ApplyToCareerUseCase _applyToCareerUseCase;
  final AppliedCareersStore _appliedCareersStore;

  CareerApplyBloc(this._applyToCareerUseCase, this._appliedCareersStore)
      : super(const CareerApplyState()) {
    on<CareerApplyStarted>(_onStarted);
    on<CareerApplyFieldChanged>(_onFieldChanged);
    on<CareerApplyFilePicked>(_onFilePicked);
    on<CareerApplyFileCleared>(_onFileCleared);
    on<CareerApplySubmitted>(_onSubmitted);
  }

  void _onStarted(CareerApplyStarted event, Emitter<CareerApplyState> emit) {
    final alreadyApplied = _appliedCareersStore.getAppliedIds().contains(event.career.id);
    emit(state.copyWith(
      career: event.career,
      status: alreadyApplied ? CareerApplyStatus.alreadyApplied : CareerApplyStatus.ready,
    ));
  }

  void _onFieldChanged(CareerApplyFieldChanged event, Emitter<CareerApplyState> emit) {
    final fieldErrors = Map<int, String>.from(state.fieldErrors)..remove(event.specId);
    emit(state.copyWith(
      values: {...state.values, event.specId: event.value},
      fieldErrors: fieldErrors,
    ));
  }

  void _onFilePicked(CareerApplyFilePicked event, Emitter<CareerApplyState> emit) {
    final fieldErrors = Map<int, String>.from(state.fieldErrors)..remove(event.specId);
    emit(state.copyWith(
      files: {...state.files, event.specId: PickedCareerFile(path: event.filePath, name: event.fileName)},
      fieldErrors: fieldErrors,
    ));
  }

  void _onFileCleared(CareerApplyFileCleared event, Emitter<CareerApplyState> emit) {
    final files = Map<int, PickedCareerFile>.from(state.files)..remove(event.specId);
    emit(state.copyWith(files: files));
  }

  Future<void> _onSubmitted(CareerApplySubmitted event, Emitter<CareerApplyState> emit) async {
    final career = state.career;
    if (career == null || state.status == CareerApplyStatus.submitting) return;

    final validationErrors = <int, String>{};
    for (final spec in career.specifications) {
      if (!spec.required) continue;
      final answered = spec.type == CareerSpecType.file
          ? state.files.containsKey(spec.id)
          : (state.values[spec.id]?.trim().isNotEmpty ?? false);
      if (!answered) validationErrors[spec.id] = 'This field is required.';
    }

    if (validationErrors.isNotEmpty) {
      emit(state.copyWith(fieldErrors: validationErrors, generalError: null));
      return;
    }

    emit(state.copyWith(status: CareerApplyStatus.submitting, fieldErrors: {}, generalError: null));

    final answers = <int, CareerAnswer>{};
    for (final spec in career.specifications) {
      final file = state.files[spec.id];
      if (file != null) {
        answers[spec.id] = CareerAnswer.file(file.path, file.name);
        continue;
      }
      final text = state.values[spec.id]?.trim();
      if (text != null && text.isNotEmpty) {
        answers[spec.id] = CareerAnswer.text(text);
      }
    }

    final result = await _applyToCareerUseCase(
      ApplyToCareerParams(careerId: career.id, answers: answers),
    );

    await result.fold(
      (failure) async {
        if (_isAlreadyApplied(failure)) {
          await _appliedCareersStore.markApplied(career.id);
          emit(state.copyWith(status: CareerApplyStatus.alreadyApplied));
          return;
        }

        final fieldErrorsFromServer = _mapFieldErrors(failure);
        if (fieldErrorsFromServer.isNotEmpty) {
          emit(state.copyWith(status: CareerApplyStatus.ready, fieldErrors: fieldErrorsFromServer));
        } else {
          emit(state.copyWith(status: CareerApplyStatus.ready, generalError: failure.message));
        }
      },
      (_) async {
        await _appliedCareersStore.markApplied(career.id);
        emit(state.copyWith(status: CareerApplyStatus.success));
      },
    );
  }

  bool _isAlreadyApplied(Failure failure) {
    return failure is ServerFailure &&
        failure.statusCode == 422 &&
        failure.message.toLowerCase().contains('already applied');
  }

  Map<int, String> _mapFieldErrors(Failure failure) {
    if (failure is! ServerFailure || failure.errors == null) return const {};
    final mapped = <int, String>{};
    for (final entry in failure.errors!.entries) {
      final match = _answerFieldPattern.firstMatch(entry.key);
      if (match == null || entry.value.isEmpty) continue;
      mapped[int.parse(match.group(1)!)] = entry.value.first;
    }
    return mapped;
  }
}
