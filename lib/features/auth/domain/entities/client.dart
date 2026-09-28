import 'package:equatable/equatable.dart';

class Client extends Equatable {
  final int id;
  final String name;
  final String phone;
  final String? email;
  final int numberOfVisit;
  final int totalPoints;

  const Client({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    this.numberOfVisit = 0,
    this.totalPoints = 0,
  });

  @override
  List<Object?> get props => [id, name, phone, email, numberOfVisit, totalPoints];
}
