import 'package:equatable/equatable.dart';

import 'career_spec_entity.dart';

class CareerEntity extends Equatable {
  final int id;
  final String title;
  final String description;
  final List<CareerSpecEntity> specifications;

  const CareerEntity({
    required this.id,
    required this.title,
    required this.description,
    this.specifications = const [],
  });

  @override
  List<Object?> get props => [id, title, description, specifications];
}
