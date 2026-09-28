import 'package:equatable/equatable.dart';

class QrEntity extends Equatable {
  final int id;
  final String image;
  final String? link;

  const QrEntity({required this.id, required this.image, this.link});

  @override
  List<Object?> get props => [id, image, link];
}
