import '../../domain/entities/location_entity.dart';

class LocationModel extends LocationEntity {
  const LocationModel({
    required super.id,
    required super.name,
    super.address,
    super.photo,
    super.lat,
    super.lng,
    super.phone,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    double? toDouble(dynamic v) {
      if (v == null) return null;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString());
    }

    return LocationModel(
      id: json['id'] as int,
      name: json['name']?.toString() ?? '',
      address: json['address']?.toString(),
      photo: json['photo']?.toString(),
      lat: toDouble(json['lat']),
      lng: toDouble(json['lng']),
      phone: json['phone']?.toString(),
    );
  }
}
