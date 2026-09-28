import 'package:equatable/equatable.dart';

import '../../domain/entities/career_entity.dart';

enum CareersStatus { loading, loaded, error }

class CareersState extends Equatable {
  final CareersStatus status;
  final List<CareerEntity> careers;
  final Set<int> appliedIds;
  final String? errorMessage;

  const CareersState({
    this.status = CareersStatus.loading,
    this.careers = const [],
    this.appliedIds = const {},
    this.errorMessage,
  });

  CareersState copyWith({
    CareersStatus? status,
    List<CareerEntity>? careers,
    Set<int>? appliedIds,
    String? errorMessage,
  }) {
    return CareersState(
      status: status ?? this.status,
      careers: careers ?? this.careers,
      appliedIds: appliedIds ?? this.appliedIds,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, careers, appliedIds, errorMessage];
}
