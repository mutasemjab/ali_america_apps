import 'package:equatable/equatable.dart';

class LegalDocumentEntity extends Equatable {
  final String content;

  const LegalDocumentEntity({required this.content});

  @override
  List<Object?> get props => [content];
}
