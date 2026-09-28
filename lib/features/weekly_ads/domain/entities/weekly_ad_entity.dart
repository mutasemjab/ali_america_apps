import 'package:equatable/equatable.dart';

class WeeklyAdEntity extends Equatable {
  final int id;
  final String image;
  final DateTime? startAt;
  final DateTime? endAt;

  const WeeklyAdEntity({required this.id, required this.image, this.startAt, this.endAt});

  @override
  List<Object?> get props => [id, image, startAt, endAt];
}
