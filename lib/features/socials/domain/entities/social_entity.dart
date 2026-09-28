import 'package:equatable/equatable.dart';

class SocialEntity extends Equatable {
  final int id;
  final String name;
  final String? icon;
  final String link;

  const SocialEntity({required this.id, required this.name, this.icon, required this.link});

  @override
  List<Object?> get props => [id, name, icon, link];
}
