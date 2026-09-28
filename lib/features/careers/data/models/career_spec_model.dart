import '../../domain/entities/career_spec_entity.dart';

class CareerSpecModel extends CareerSpecEntity {
  const CareerSpecModel({
    required super.id,
    required super.name,
    required super.type,
    required super.required,
    super.values,
  });

  factory CareerSpecModel.fromJson(Map<String, dynamic> json) {
    final rawValues = json['values'] as List<dynamic>? ?? [];
    return CareerSpecModel(
      id: json['id'] as int,
      name: json['name']?.toString() ?? '',
      type: json['type']?.toString() ?? 'text',
      required: json['required'] == true,
      values: rawValues.map((e) => e.toString()).toList(),
    );
  }
}
