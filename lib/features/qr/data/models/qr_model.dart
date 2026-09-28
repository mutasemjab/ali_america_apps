import '../../domain/entities/qr_entity.dart';

class QrModel extends QrEntity {
  const QrModel({required super.id, required super.image, super.link});

  factory QrModel.fromJson(Map<String, dynamic> json) {
    return QrModel(
      id: json['id'] as int,
      image: json['image']?.toString() ?? '',
      link: json['link']?.toString(),
    );
  }
}
