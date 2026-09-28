import 'package:equatable/equatable.dart';

import '../../domain/entities/career_entity.dart';

abstract class CareerApplyEvent extends Equatable {
  const CareerApplyEvent();

  @override
  List<Object?> get props => [];
}

class CareerApplyStarted extends CareerApplyEvent {
  final CareerEntity career;
  const CareerApplyStarted(this.career);

  @override
  List<Object?> get props => [career];
}

class CareerApplyFieldChanged extends CareerApplyEvent {
  final int specId;
  final String value;
  const CareerApplyFieldChanged(this.specId, this.value);

  @override
  List<Object?> get props => [specId, value];
}

class CareerApplyFilePicked extends CareerApplyEvent {
  final int specId;
  final String filePath;
  final String fileName;
  const CareerApplyFilePicked(this.specId, this.filePath, this.fileName);

  @override
  List<Object?> get props => [specId, filePath, fileName];
}

class CareerApplyFileCleared extends CareerApplyEvent {
  final int specId;
  const CareerApplyFileCleared(this.specId);

  @override
  List<Object?> get props => [specId];
}

class CareerApplySubmitted extends CareerApplyEvent {
  const CareerApplySubmitted();
}
