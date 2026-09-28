import 'package:equatable/equatable.dart';

class LocationEntity extends Equatable {
  final int id;
  final String name;
  final String? address;
  final String? photo;
  final double? lat;
  final double? lng;
  final String? phone;

  const LocationEntity({
    required this.id,
    required this.name,
    this.address,
    this.photo,
    this.lat,
    this.lng,
    this.phone,
  });

  @override
  List<Object?> get props => [id, name, address, photo, lat, lng, phone];
}
