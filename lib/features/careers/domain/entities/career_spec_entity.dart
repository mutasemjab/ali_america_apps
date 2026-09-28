import 'package:equatable/equatable.dart';

/// One field in a career's dynamically-built application form.
class CareerSpecEntity extends Equatable {
  final int id;
  final String name;
  final String type;
  final bool required;
  final List<String> values;

  const CareerSpecEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.required,
    this.values = const [],
  });

  @override
  List<Object?> get props => [id, name, type, required, values];
}
