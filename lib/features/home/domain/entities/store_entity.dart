import 'package:equatable/equatable.dart';

class StoreEntity extends Equatable {
  final int id;
  final String name;
  final String? logo;
  final String? phone;
  final String? facebookLink;

  const StoreEntity({
    required this.id,
    required this.name,
    this.logo,
    this.phone,
    this.facebookLink,
  });

  @override
  List<Object?> get props => [id, name, logo, phone, facebookLink];
}
