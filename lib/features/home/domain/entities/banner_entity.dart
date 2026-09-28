import 'package:equatable/equatable.dart';

class BannerEntity extends Equatable {
  final int id;
  final String image;

  const BannerEntity({required this.id, required this.image});

  @override
  List<Object?> get props => [id, image];
}
