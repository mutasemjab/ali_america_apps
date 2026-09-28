import '../../domain/entities/career_entity.dart';
import 'career_spec_model.dart';

class CareerModel extends CareerEntity {
  const CareerModel({
    required super.id,
    required super.title,
    required super.description,
    super.specifications,
  });

  factory CareerModel.fromJson(Map<String, dynamic> json) {
    final rawSpecs = json['specifications'] as List<dynamic>? ?? [];
    return CareerModel(
      id: json['id'] as int,
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      specifications:
          rawSpecs.map((e) => CareerSpecModel.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}
