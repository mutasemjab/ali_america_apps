import '../../domain/entities/weekly_ad_entity.dart';

class WeeklyAdModel extends WeeklyAdEntity {
  const WeeklyAdModel({required super.id, required super.image, super.startAt, super.endAt});

  factory WeeklyAdModel.fromJson(Map<String, dynamic> json) {
    DateTime? toDate(dynamic v) => v == null ? null : DateTime.tryParse(v.toString());
    return WeeklyAdModel(
      id: json['id'] as int,
      image: json['image']?.toString() ?? '',
      startAt: toDate(json['start_at']),
      endAt: toDate(json['end_at']),
    );
  }
}
