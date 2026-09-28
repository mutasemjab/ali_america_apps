import '../../domain/entities/legal_document_entity.dart';

class LegalDocumentModel extends LegalDocumentEntity {
  const LegalDocumentModel({required super.content});

  factory LegalDocumentModel.fromJson(Map<String, dynamic> json) {
    return LegalDocumentModel(content: json['content']?.toString() ?? '');
  }
}
