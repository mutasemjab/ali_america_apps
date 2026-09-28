import '../../domain/entities/social_entity.dart';

class SocialModel extends SocialEntity {
  const SocialModel({required super.id, required super.name, super.icon, required super.link});

  factory SocialModel.fromJson(Map<String, dynamic> json) {
    return SocialModel(
      id: json['id'] as int,
      name: json['name']?.toString() ?? '',
      icon: json['icon']?.toString(),
      link: json['link']?.toString() ?? '',
    );
  }
}
