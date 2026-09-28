import 'package:equatable/equatable.dart';

class RewardEntity extends Equatable {
  final int id;
  final String name;
  final String? image;
  final int visitsRequired;
  final bool earned;
  final int visitsRemaining;
  final String? barcode;

  const RewardEntity({
    required this.id,
    required this.name,
    this.image,
    required this.visitsRequired,
    required this.earned,
    required this.visitsRemaining,
    this.barcode,
  });

  @override
  List<Object?> get props => [id, name, image, visitsRequired, earned, visitsRemaining, barcode];
}
